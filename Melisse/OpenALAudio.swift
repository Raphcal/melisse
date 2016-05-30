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
    
    let sources: AudioSources
    var source = 0
    
    let sounds: [Sound]
    let buffers: AudioBuffers
    
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
        if let URL = NSBundle.mainBundle().URLForResource(sound.resource, withExtension: sound.ext) {
            storeAudioFor(sound, at: URL)
        } else {
            print("Son \(sound) non chargé.")
        }
    }
    
    private func storeAudioFor(sound: Sound, at URL: NSURL) {
        var fileId: AudioFileID = nil
        var status = AudioFileOpenURL(URL as CFURL, .ReadPermission, 0, &fileId)
        if status != noErr {
            print("Erreur \(status) à l'ouverture du fichier \(URL).")
            return
        }
        
        var dataSize: UInt64 = 0
        var size: UInt32 = UInt32(sizeof(UInt64))
        status = AudioFileGetProperty(fileId, kAudioFilePropertyAudioDataByteCount, &size, &dataSize)
        if status != noErr {
            print("Erreur \(status) à la lecture de la taille du fichier \(URL).")
            return
        }
        
        var numberOfBytes = UInt32(dataSize)
        let data = UnsafeMutablePointer<Void>.alloc(Int(dataSize))
        status = AudioFileReadBytes(fileId, false, 0, &numberOfBytes, data)
        if status != noErr {
            print("Erreur \(status) à la lecture du contenu du fichier \(URL).")
            return
        }
        
        status = AudioFileClose(fileId)
        if status != noErr {
            print("Erreur \(status) à la fermeture du contenu du fichier \(URL).")
            return
        }
        
        alBufferData(buffers.buffers[sound.rawValue], AL_FORMAT_STEREO16, data, ALsizei(dataSize), 44100)
        data.destroy()
        
        let error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur OpenAL \(error) à l'attribution du son \(sound) au buffer.")
        }
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
        alGenBuffers(self.numberOfBuffers, buffers)
        
        if alGetError() != AL_NO_ERROR {
            return nil
        }
    }
    
    deinit {
        alDeleteBuffers(numberOfBuffers, buffers)
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
