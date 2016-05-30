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
    
    let sources: AudioSources
    var source = 0
    
    let sounds: [Sound]
    let buffers: AudioBuffers
    
    var player: AVAudioPlayer?
    var audioPlayerDelegate: AudioPlayerDelegate?
    
    public init?(sounds: [Sound], numberOfSources: Int = 2) {
        self.sounds = sounds
        let device = AudioDevice()
        let context = AudioContext(device: device)
        if let sources = AudioSources(context: context, numberOfSources: numberOfSources), let buffers = AudioBuffers(context: context, numberOfBuffers: sounds.count) {
            self.sources = sources
            self.buffers = buffers
        } else {
            return nil
        }

        for sound in sounds {
            load(sound)
        }
    }
    
    public func play(sound: Sound) {
        alSourceStop(sources.sources[source])
        alSourcei(sources.sources[source], AL_BUFFER, ALint(buffers.buffers[sound.rawValue]))
        
        var error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur \(error) lors de l'attachement du buffer \(sound) à la source \(source).")
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
        if let URL = NSBundle.mainBundle().URLForResource(sound.resource, withExtension: sound.ext) {
            bufferize(sound, at: URL)
        } else {
            print("Son \(sound) non trouvé.")
        }
    }
    
    private func bufferize(sound: Sound, at URL: NSURL) {
        // Ouverture du fichier.
        var fileReference: ExtAudioFileRef = nil
        var status = ExtAudioFileOpenURL(URL as CFURL, &fileReference)
        
        if status != noErr || fileReference == nil {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileOpenURL FAILED, Error = \(status)")
            return
        }
        
        // Identification du format du fichier.
        var format = AudioStreamBasicDescription()
        var size = UInt32(sizeof(AudioStreamBasicDescription))
        status = ExtAudioFileGetProperty(fileReference, kExtAudioFileProperty_FileDataFormat, &size, &format)
        
        if status != noErr {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = \(status)")
            ExtAudioFileDispose(fileReference)
            return
        }
        
        if format.mChannelsPerFrame > 2 {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', format non supporté car le nombre de pistes est supérieur à stéréo.")
            ExtAudioFileDispose(fileReference)
            return
        }
        
        // Définition du format de sortie du son en 16 bit signé (endian natif).
        // Conservation du nombre de pistes (mono ou stéréo) et de la fréquence.
        var outputFormat = AudioStreamBasicDescription()
        outputFormat.mSampleRate = format.mSampleRate
        outputFormat.mChannelsPerFrame = format.mChannelsPerFrame
        
        outputFormat.mFormatID = kAudioFormatLinearPCM
        outputFormat.mBytesPerPacket = 2 * format.mChannelsPerFrame
        outputFormat.mFramesPerPacket = 1
        outputFormat.mBytesPerFrame = 2 * format.mChannelsPerFrame
        outputFormat.mBitsPerChannel = 16
        outputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger
        
        status = ExtAudioFileSetProperty(fileReference, kExtAudioFileProperty_ClientDataFormat, size, &outputFormat)
        
        if status != noErr {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = \(status)")
            ExtAudioFileDispose(fileReference)
            return
        }
        
        // Identification du nombre total de frames.
        var fileLengthInFrames: Int64 = 0
        size = UInt32(sizeof(Int64))
        status = ExtAudioFileGetProperty(fileReference, kExtAudioFileProperty_FileLengthFrames, &size, &fileLengthInFrames)
        
        if status != noErr {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = \(status)")
            ExtAudioFileDispose(fileReference)
            return
        }
        
        // Lecture du son en mémoire.
        let dataSize = UInt32(fileLengthInFrames * Int64(outputFormat.mBytesPerFrame))
        let data = UnsafeMutablePointer<Void>.alloc(Int(dataSize))
        
        var dataBuffer = AudioBufferList(mNumberBuffers: 1, mBuffers: AudioBuffer(mNumberChannels: outputFormat.mChannelsPerFrame, mDataByteSize: dataSize, mData: data))
        
        size = UInt32(fileLengthInFrames)
        status = ExtAudioFileRead(fileReference, &size, &dataBuffer)
        
        if status == noErr {
            alBufferData(buffers.buffers[sound.rawValue], outputFormat.mChannelsPerFrame > 1 ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16, data, ALsizei(dataSize), ALsizei(outputFormat.mSampleRate))
            
            let error = alGetError()
            if error != AL_NO_ERROR {
                print("Erreur de placement dans le buffer pour le son '\(sound)'.")
            }
            
        } else {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileRead FAILED, Error = \(status)")
        }
        
        data.destroy()
        ExtAudioFileDispose(fileReference)
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
    let device: AudioDevice?
    let context: ALCcontext
    
    init?(device: AudioDevice?) {
        self.device = device
        if let device = device {
            var attributes: ALCint = 0
            self.context = alcCreateContext(device.device, &attributes)
        } else {
            self.context = nil
        }
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
    
    let context: AudioContext?
    let numberOfSources: ALsizei
    let sources: UnsafeMutablePointer<ALuint>
    
    init?(context: AudioContext?, numberOfSources: Int) {
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
        sources.destroy()
    }
    
}

class AudioBuffers {
    
    let context: AudioContext?
    let numberOfBuffers: ALsizei
    let buffers: UnsafeMutablePointer<ALuint>
    
    init?(context: AudioContext?, numberOfBuffers: Int) {
        self.context = context
        self.numberOfBuffers = ALsizei(numberOfBuffers)
        
        buffers = UnsafeMutablePointer.alloc(numberOfBuffers)
        alGenBuffers(self.numberOfBuffers, buffers)
        
        if alGetError() != AL_NO_ERROR {
            return nil
        }
    }
    
    deinit {
        alDeleteBuffers(numberOfBuffers, buffers)
        buffers.destroy()
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
