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
    
    let numberOfSources: ALsizei = 2
    let sources: UnsafeMutablePointer<ALuint>
    var source = 0
    
    let sounds: [Sound]
    let buffers: UnsafeMutablePointer<ALuint>
    
    var data = [AudioData]()
    
    var player: AVAudioPlayer?
    var completion: (() -> Void)?
    
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
            return nil
        }
        alcMakeContextCurrent(context)
        
        sources = UnsafeMutablePointer.alloc(Int(numberOfSources))
        alGenSources(numberOfSources, sources)
        
        var error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur OpenAL \(error) pendant le chargement des sources.")
            sources.destroy()
            return nil
        }
        
        buffers = UnsafeMutablePointer.alloc(sounds.count)
        alGenBuffers(ALsizei(sounds.count), buffers)
        
        error = alGetError()
        if error != AL_NO_ERROR {
            print("Erreur OpenAL \(error) pendant le chargement des buffers.")
            sources.destroy()
            buffers.destroy()
            return nil
        }
        
        for sound in sounds {
            
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
        // TODO: Implémenter la méthode.
    }
    
    public func play(streamFrom URL: NSURL) {
        // TODO: Implémenter la méthode.
    }
    
    public func playOnce(streamFrom URL: NSURL, completionBlock: () -> Void) {
        // TODO: Implémenter la méthode.
    }
    
    public func stopStream() {
        // TODO: Implémenter la méthode.
    }
    
    public func load(sound: Sound) {
        if let URL = NSBundle.mainBundle().URLForResource(sound.resource, withExtension: sound.ext) {
            data[sound.rawValue] = audioDataFor(URL)
        }
        
        
        /*NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
        
        if(url != nil) {
            ALenum format = 0;
            ALsizei size = 0;
            ALsizei freq = 0;
            _data[sound] = MyGetOpenALAudioData((__bridge CFURLRef)(url), &size, &format, &freq);
            
            ALenum error = alGetError();
            if(error != AL_NO_ERROR) {
                NSLog(@"Erreur %x pendant le chargement du fichier '%@' (url %@) pour le son %ld.", error, name, url, (long)sound);
                return;
            }
            
            alBufferDataStaticProc(_buffers[sound], format, _data[sound], size, freq);
            error = alGetError();
            if(error != AL_NO_ERROR) {
                NSLog(@"Erreur %x pendant la création du buffer pour le son %ld.", error, (long)sound);
            }
        } else {
            NSLog(@"Fichier '%@.%@' non trouvé lors du chargement du son %ld.", name, ext, (long)sound);
        }*/
    }
    
    private func audioDataFor(URL: NSURL) -> AudioData {
        var fileRef = ExtAudioFileRef(nilLiteral: ())
        var status = ExtAudioFileOpenURL(URL as CFURL, &fileRef)
        
        if status != 0 {
            print("Erreur lors de l'ouverture du son à l'URL '\(URL)', ExtAudioFileOpenURL FAILED, Error = \(status)")
        }
        
        /*
         // Get the audio data format
         err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &theFileFormat);
         if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %d\n", (int)err); goto Exit; }
         if (theFileFormat.mChannelsPerFrame > 2)  { printf("MyGetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n"); goto Exit;}
         
         // Set the client format to 16 bit signed integer (native-endian) data
         // Maintain the channel count and sample rate of the original source format
         theOutputFormat.mSampleRate = theFileFormat.mSampleRate;
         theOutputFormat.mChannelsPerFrame = theFileFormat.mChannelsPerFrame;
         
         theOutputFormat.mFormatID = kAudioFormatLinearPCM;
         theOutputFormat.mBytesPerPacket = 2 * theOutputFormat.mChannelsPerFrame;
         theOutputFormat.mFramesPerPacket = 1;
         theOutputFormat.mBytesPerFrame = 2 * theOutputFormat.mChannelsPerFrame;
         theOutputFormat.mBitsPerChannel = 16;
         theOutputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
         
         // Set the desired client (output) data format
         err = ExtAudioFileSetProperty(extRef, kExtAudioFileProperty_ClientDataFormat, sizeof(theOutputFormat), &theOutputFormat);
         if(err) { printf("MyGetOpenALAudioData: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %d\n", (int)err); goto Exit; }
         
         // Get the total frame count
         thePropertySize = sizeof(theFileLengthInFrames);
         err = ExtAudioFileGetProperty(extRef, kExtAudioFileProperty_FileLengthFrames, &thePropertySize, &theFileLengthInFrames);
         if(err) { printf("MyGetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %d\n", (int)err); goto Exit; }
         
         // Read all the data into memory
         UInt32		dataSize = (UInt32) (theFileLengthInFrames * theOutputFormat.mBytesPerFrame);
         theData = malloc(dataSize);
         if (theData)
         {
         AudioBufferList		theDataBuffer;
         theDataBuffer.mNumberBuffers = 1;
         theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
         theDataBuffer.mBuffers[0].mNumberChannels = theOutputFormat.mChannelsPerFrame;
         theDataBuffer.mBuffers[0].mData = theData;
         
         // Read the data into an AudioBufferList
         err = ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
         if(err == noErr)
         {
         // success
         *outDataSize = (ALsizei)dataSize;
         *outDataFormat = (theOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
         *outSampleRate = (ALsizei)theOutputFormat.mSampleRate;
         }
         else
         {
         // failure
         free (theData);
         theData = NULL; // make sure to return NULL
         printf("MyGetOpenALAudioData: ExtAudioFileRead FAILED, Error = %d\n", (int)err); goto Exit;
         }
         }
         
         Exit:
         // Dispose the ExtAudioFileRef, it is no longer needed
         if (extRef) ExtAudioFileDispose(extRef);
         return theData;
         }
        */
        
        // TODO: Écrire la méthode.
        return AudioData(data: UnsafeMutablePointer(), size: 0, format: 0, frequence: 0)
    }
    
}

struct AudioData {
    var data: UnsafeMutablePointer<Void>
    var size: ALsizei
    var format: ALenum
    var frequence: ALsizei
}
