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
    
    typealias ALCcontext = COpaquePointer
    typealias ALCdevice = COpaquePointer
    
    let context: ALCcontext
    let device: ALCdevice
    let alBufferDataStaticProc: alBufferDataStaticProcPtr
    
    let numberOfSources: ALsizei = 2
    let sources: UnsafeMutablePointer<ALuint>
    var source = 0
    
    let sounds: [Sound]
    let buffers: UnsafeMutablePointer<ALuint>
    
    var data = [AudioData]()
    
    var player: AVAudioPlayer?
    var audioPlayerDelegate: AudioPlayerDelegate?
    
    public init?(sounds: [Sound]) {
        self.sounds = sounds
        
        device = alcOpenDevice(nil)
        if device == nil {
            print("Erreur OpenAL, erreur lors de l'ouverture du device.")
            return nil
        }
        
        context = alcCreateContext(device, nil)
        if context == nil {
            print("Erreur OpenAL, erreur lors de la création du context.")
            alcCloseDevice(device)
            return nil
        }
        alcMakeContextCurrent(context)
        
        let proc = alcGetProcAddress(nil, "alBufferDataStatic")
        if proc == nil {
            print("Erreur OpenAL lors de la recherche de la fonction 'alBufferDataStatic'.")
            alcDestroyContext(context)
            alcCloseDevice(device)
            return nil
        }
        alBufferDataStaticProc = unsafeBitCast(proc, alBufferDataStaticProcPtr.self)
        
        sources = UnsafeMutablePointer.alloc(Int(numberOfSources))
        alGenSources(numberOfSources, sources)
        
        var error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur OpenAL \(error) pendant le chargement des sources.")
            sources.destroy()
            alcDestroyContext(context)
            alcCloseDevice(device)
            return nil
        }
        
        buffers = UnsafeMutablePointer.alloc(sounds.count)
        alGenBuffers(ALsizei(sounds.count), buffers)
        
        error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur OpenAL \(error) pendant le chargement des buffers.")
            alDeleteSources(numberOfSources, sources)
            sources.destroy()
            buffers.destroy()
            alcDestroyContext(context)
            alcCloseDevice(device)
            return nil
        }
        
        for sound in sounds {
            load(sound)
        }
    }
    
    deinit {
        alDeleteSources(numberOfSources, sources)
        alDeleteBuffers(ALsizei(sounds.count), buffers)
        
        alcDestroyContext(context)
        alcCloseDevice(device)
        
        sources.destroy()
        buffers.destroy()
    }
    
    public func play(sound: Sound) {
        alSourceStop(sources[source])
        alSourcei(sources[source], AL_BUFFER, ALint(buffers[sound.rawValue]))
        
        var error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur \(error) lors de l'attachement du buffer \(sound.rawValue) à la source.")
            return
        }
        
        // Possibilité de réduire le son ici en paramétrant AL_GAIN.
        alSourcePlay(sources[source])
        source = (source + 1) % Int(numberOfSources)
        
        error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur \(error) Erreur lors de la lecture du son \(sound.rawValue).")
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
            
            alBufferDataStaticProc(ALint(buffers[sound.rawValue]), audioData.format, audioData.data, audioData.size, audioData.frequence)
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
        let data = UnsafeMutablePointer<Void>.alloc(Int(dataSize))
        
        var dataBuffer = AudioBufferList(mNumberBuffers: 1, mBuffers: AudioBuffer(mNumberChannels: outputFormat.mChannelsPerFrame, mDataByteSize: dataSize, mData: data))
        dataBuffer.mNumberBuffers = 1
        
        size = UInt32(fileLengthInFrames)
        status = ExtAudioFileRead(fileReference, &size, &dataBuffer)
        
        if status == noErr {
            return AudioData(data: data, size: ALsizei(dataSize), format: outputFormat.mChannelsPerFrame > 1 ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16, frequence: ALsizei(outputFormat.mSampleRate))
        } else {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileRead FAILED, Error = \(status)")
            free(data)
            ExtAudioFileDispose(fileReference)
            return nil
        }
    }
    
}

struct AudioData {
    var data: UnsafeMutablePointer<Void>
    var size: ALsizei
    var format: ALenum
    var frequence: ALsizei
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
