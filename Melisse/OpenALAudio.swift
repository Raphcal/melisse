//
//  OpenALAudio.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import OpenAL
import AudioToolbox
import AVFoundation

public class OpenALAudio: Audio {
    
    let context: AudioContext
    let device: AudioDevice
    let alBufferDataStaticProc: alBufferDataStaticProcPtr
    
    let sources: AudioSources
    var source = 0
    
    let sounds: [Sound]
    let buffers: AudioBuffers
    
    var data: [AudioData]
    
    var player: AVAudioPlayer?
    var audioPlayerDelegate: AudioPlayerDelegate?
    
    public init?(sounds: [Sound], numberOfSources: Int = 2) {
        self.sounds = sounds
        
        if let device = AudioDevice() {
            self.device = device
        } else {
            print("Erreur OpenAL, erreur lors de l'ouverture du device.")
            return nil
        }
        
        if let context = AudioContext(device: device) {
            self.context = context
        } else {
            print("Erreur OpenAL, erreur lors de la création du context.")
            return nil
        }
        
        let proc = alcGetProcAddress(device.device, "alBufferDataStatic")
        if proc == nil {
            print("Erreur OpenAL lors de la recherche de la fonction 'alBufferDataStatic'.")
            return nil
        }
        alBufferDataStaticProc = unsafeBitCast(proc, alBufferDataStaticProcPtr.self)
        
        if let sources = AudioSources(context: context, numberOfSources: numberOfSources) {
            self.sources = sources
        } else {
            print("Erreur OpenAL pendant le chargement des sources.")
            return nil
        }
        
        if let buffers = AudioBuffers(context: context, numberOfBuffers: sounds.count) {
            self.buffers = buffers
        } else {
            print("Erreur OpenAL pendant le chargement des buffers.")
            return nil
        }
        
        data = Array(count: sounds.count, repeatedValue: AudioData())
        for sound in sounds {
            load(sound)
        }
    }
    
    public func play(sound: Sound) {
        alSourceStop(sources.sources[source])
        alSourcei(sources.sources[source], AL_BUFFER, ALint(buffers.buffers[sound.rawValue]))
        
        var error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur \(error) lors de l'attachement du buffer \(sound) à la source.")
            return
        }
        
        // Possibilité de réduire le son ici en paramétrant AL_GAIN.
        alSourcePlay(sources.sources[source])
        source = (source + 1) % Int(sources.numberOfSources)
        
        error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur \(error) Erreur lors de la lecture du son \(sound).")
            return
        }
    }
    
    public func play(streamFrom URL: NSURL) {
        do {
            player = try AVAudioPlayer(contentsOfURL: URL)
            player!.numberOfLoops = -1
            player!.play()
        } catch {
            print("Erreur au chargement du stream '\(URL)': \(error)")
        }
    }
    
    public func playOnce(streamFrom URL: NSURL, completionBlock: () -> Void) {
        let delegate = AudioPlayerDelegate(audio: self, completion: completionBlock)
        self.audioPlayerDelegate = delegate
        do {
            player = try AVAudioPlayer(contentsOfURL: URL)
            player!.numberOfLoops = 0
            player!.delegate = delegate
            player!.play()
        } catch {
            print("Erreur au chargement du stream '\(URL)': \(error)")
        }
    }
    
    public func stopStream() {
        player?.stop()
        player = nil
        audioPlayerDelegate = nil
    }
    
    // MARK: - OpenAL
    
    public func load(sound: Sound) {
        if let URL = NSBundle.mainBundle().URLForResource(sound.resource, withExtension: sound.ext), let audioData = audioDataFor(URL) {
            data[sound.rawValue] = audioData
            
            var error = alGetError()
            if error != AL_NO_ERROR {
                print("Erreur OpenAL \(error) au chargement du son \(sound).")
            }
            
            alBufferDataStaticProc(ALint(buffers.buffers[sound.rawValue]), audioData.format, audioData.data, audioData.size, audioData.frequence)
            
            error = alGetError()
            if error != AL_NO_ERROR {
                print("Erreur OpenAL \(error) à l'attribution du son \(sound) au buffer.")
            }
        } else {
            print("Son \(sound) non chargé.")
        }
    }
    
    private func audioDataFor(URL: NSURL) -> AudioData? {
        // Ouverture du fichier.
        var fileReference: ExtAudioFileRef = nil
        var status = ExtAudioFileOpenURL(URL as CFURL, &fileReference)
        
        if status != noErr || fileReference == nil {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileOpenURL FAILED, Error = \(status)")
            return nil
        }
        
        // Identification du format du fichier.
        var format = AudioStreamBasicDescription()
        var size = UInt32(sizeof(AudioStreamBasicDescription))
        status = ExtAudioFileGetProperty(fileReference, kExtAudioFileProperty_FileDataFormat, &size, &format)
        
        if status != noErr {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = \(status)")
            ExtAudioFileDispose(fileReference)
            return nil
        }
        
        if format.mChannelsPerFrame > 2 {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', format non supporté car le nombre de pistes est supérieur à stéréo.")
            ExtAudioFileDispose(fileReference)
            return nil
        }
        
        // Set the client format to 16 bit signed integer (native-endian) data
        // Maintain the channel count and sample rate of the original source format
        var outputFormat = AudioStreamBasicDescription()
        outputFormat.mSampleRate = format.mSampleRate
        outputFormat.mChannelsPerFrame = format.mChannelsPerFrame
        
        outputFormat.mFormatID = kAudioFormatLinearPCM
        outputFormat.mBytesPerPacket = 2 * format.mChannelsPerFrame
        outputFormat.mFramesPerPacket = 1
        outputFormat.mBytesPerFrame = 2 * format.mChannelsPerFrame
        outputFormat.mBitsPerChannel = 16
        outputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger
        
        // Set the desired client (output) data format
        size = UInt32(sizeof(AudioStreamBasicDescription))
        status = ExtAudioFileSetProperty(fileReference, kExtAudioFileProperty_ClientDataFormat, size, &outputFormat)
        
        if status != noErr {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = \(status)")
            ExtAudioFileDispose(fileReference)
            return nil
        }
        
        // Identification du nombre total de frames.
        var fileLengthInFrames: Int64 = 0
        size = UInt32(sizeof(Int64))
        status = ExtAudioFileGetProperty(fileReference, kExtAudioFileProperty_FileLengthFrames, &size, &fileLengthInFrames)
        
        if status != noErr {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = \(status)")
            ExtAudioFileDispose(fileReference)
            return nil
        }
        
        // Lecture du son en mémoire.
        let dataSize = UInt32(fileLengthInFrames * Int64(outputFormat.mBytesPerFrame))
        let data = malloc(Int(dataSize))//UnsafeMutablePointer<Void>.alloc(Int(dataSize))
        
        var dataBuffer = AudioBufferList()
        dataBuffer.mNumberBuffers = 1
        dataBuffer.mBuffers.mDataByteSize = dataSize
        dataBuffer.mBuffers.mNumberChannels = outputFormat.mChannelsPerFrame
        dataBuffer.mBuffers.mData = data
        
        // mNumberBuffers: 1, mBuffers: AudioBuffer(mNumberChannels: outputFormat.mChannelsPerFrame, mDataByteSize: dataSize, mData: data))
        
        size = UInt32(fileLengthInFrames)
        status = ExtAudioFileRead(fileReference, &size, &dataBuffer)
        
        var audioData: AudioData?
        if status == noErr {
            audioData = AudioData(data: data, size: ALsizei(dataSize), format: outputFormat.mChannelsPerFrame > 1 ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16, frequence: ALsizei(outputFormat.mSampleRate))
        } else {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileRead FAILED, Error = \(status)")
            free(data)
            audioData = nil
        }
        
        ExtAudioFileDispose(fileReference)
        return audioData
    }
    
}

class AudioDevice {
    
    typealias ALCdevice = COpaquePointer
    let device: ALCdevice
    
    init?() {
        self.device = alcOpenDevice(nil)
        if device == nil {
            return nil
        }
    }
    
    deinit {
        alcCloseDevice(device)
    }
    
}

class AudioContext {
    
    typealias ALCcontext = COpaquePointer
    let device: AudioDevice
    let context: ALCcontext
    
    init?(device: AudioDevice) {
        self.device = device
        
        var attributes: ALCint = 0
        self.context = alcCreateContext(device.device, &attributes)
        
        if context == nil {
            return nil
        }
        
        alcMakeContextCurrent(context)
    }
    
    deinit {
        alcDestroyContext(context)
    }
    
}

class AudioSources {
    
    let context: AudioContext
    let numberOfSources: ALsizei
    let sources: UnsafeMutablePointer<ALuint>
    
    init?(context: AudioContext, numberOfSources: Int) {
        self.context = context
        self.numberOfSources = ALsizei(numberOfSources)
        
        sources = UnsafeMutablePointer.alloc(numberOfSources)
        alGenSources(self.numberOfSources, sources)
        
        if alGetError() != AL_NO_ERROR {
            return nil
        }
    }
    
    deinit {
        alDeleteSources(self.numberOfSources, sources)
    }
    
}

class AudioBuffers {
    
    let context: AudioContext
    let numberOfBuffers: ALsizei
    let buffers: UnsafeMutablePointer<ALuint>
    
    init?(context: AudioContext, numberOfBuffers: Int) {
        self.context = context
        self.numberOfBuffers = ALsizei(numberOfBuffers)
        
        buffers = UnsafeMutablePointer.alloc(numberOfBuffers)
        alGenSources(self.numberOfBuffers, buffers)
        
        if alGetError() != AL_NO_ERROR {
            return nil
        }
    }
    
    deinit {
        alDeleteBuffers(numberOfBuffers, buffers)
    }
    
}

class AudioData {
    
    var data: UnsafeMutablePointer<Void>
    var size: ALsizei
    var format: ALenum
    var frequence: ALsizei
    
    init() {
        data = nil
        size = 0
        format = 0
        frequence = 0
    }
    
    init(data: UnsafeMutablePointer<Void>, size: ALsizei, format: ALenum, frequence: ALsizei) {
        self.data = data
        self.size = size
        self.format = format
        self.frequence = frequence
    }
    
    deinit {
        if data != nil {
            data.destroy()
            data = nil
        }
    }
    
}

class AudioPlayerDelegate : NSObject, AVAudioPlayerDelegate {
    
    let audio: Audio
    let completion: () -> Void
    
    init(audio: Audio, completion: () -> Void) {
        self.audio = audio
        self.completion = completion
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        completion()
        audio.stopStream()
    }
    
}
