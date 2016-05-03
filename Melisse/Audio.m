//
//  Audio.m
//  MeltedIce
//
//  Created by Raphaël Calabro on 17/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//
//  Original source from Puzzle by Raphaël Calabro on 14/04/13.
//

#import "Audio.h"

#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>

#define SOURCES 2

@interface OpenALAudio () {

    ALCcontext *_context;
    ALCdevice *_device;

    ALuint _sources[SOURCES];
    ALuint _source;
    ALuint _buffers[SoundCount];
    ALvoid *_data[SoundCount];
    
    AVAudioPlayer *_player;
    void(^_completionBlock)();
    
}

@end

@implementation OpenALAudio

- (id)init {
    self = [super init];
    if(self) {
        _device = alcOpenDevice(NULL);
        if(_device != NULL) {
            _context = alcCreateContext(_device, 0);
            if(_context != NULL) {
                alcMakeContextCurrent(_context);
                
                alGenBuffers(SoundCount, _buffers);
                ALenum error = alGetError();
                if(error != AL_NO_ERROR) {
                    NSLog(@"Erreur OpenAL %x pendant le chargement des buffers.", error);
                    return nil;
                }
                
                alGenSources(SOURCES, _sources);
                _source = 0;
                error = alGetError();
                if(error != AL_NO_ERROR) {
                    NSLog(@"Erreur OpenAL %x pendant le chargement des sources.", error);
                    return nil;
                }
                
                [self loadAllSounds];
            }
        }
    }
    return self;
}

- (void)dealloc {
    alDeleteSources(SOURCES, _sources);
    alDeleteBuffers(SoundCount, _buffers);
    
    alcDestroyContext(_context);
    alcCloseDevice(_device);
}

- (void)loadAllSounds {
    [self loadSound:SoundBubble1 fromResource:@"bulle1" withExtension:@"aif"];
    [self loadSound:SoundBubble2 fromResource:@"bulle2" withExtension:@"aif"];
    [self loadSound:SoundBubble3 fromResource:@"bulle3" withExtension:@"aif"];
    [self loadSound:SoundDie fromResource:@"Die"];
    [self loadSound:SoundExplosion fromResource:@"Explosion"];
    [self loadSound:SoundHit fromResource:@"hit" withExtension:@"aif"];
    [self loadSound:SoundJump fromResource:@"Jump"];
    [self loadSound:SoundSplash fromResource:@"Splash"];
    [self loadSound:SoundTreasure fromResource:@"Treasure"];
}

- (void)loadSound:(Sound)sound fromResource:(NSString * _Nonnull)name {
    [self loadSound:sound fromResource:name withExtension:@"wav"];
}

- (void)loadSound:(Sound)sound fromResource:(NSString * _Nonnull)name withExtension:(NSString * _Nonnull)ext {
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
    
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
    }
}

- (void)playSound:(Sound)sound {
    alSourceStop(_sources[_source]);
    alSourcei(_sources[_source], AL_BUFFER, _buffers[sound]);
    
    ALenum error = alGetError();
    if(error == AL_NO_ERROR) {
        // Possibilité de réduire le son ici en paramétrant AL_GAIN.
        alSourcePlay(_sources[_source]);
        
        _source = (_source + 1) % SOURCES;
        
        error = alGetError();
        if(error != AL_NO_ERROR) {
            NSLog(@"Erreur lors de la lecture du son %ld.", (long)sound);
        }
    } else {
        NSLog(@"Erreur %x lors de l'attachement du buffer %ld à la source.", error, (long)sound);
    }
}

- (void)playStreamAtURL:(NSURL * _Nonnull)url {
    [self stopStream];
    
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error == nil) {
        _player.numberOfLoops = -1;
        [_player play];
    } else {
        _player = nil;
        NSLog(@"Erreur au chargement du stream '%@' : %@", url, error);
    }
}

- (void)playOnceStreamAtURL:(NSURL * _Nonnull)url withCompletionBlock:(void (^)())block {
    [self stopStream];
    
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _completionBlock = block;
    
    if (error == nil) {
        _player.numberOfLoops = 0;
        _player.delegate = self;
        [_player play];
    } else {
        _player = nil;
        NSLog(@"Erreur au chargement du stream '%@' : %@", url, error);
    }
}

- (void)stopStream {
    if (_player != nil) {
        [_player stop];
        _player = nil;
        _completionBlock = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _completionBlock();
    [self stopStream];
}

#pragma mark - Code tiré de "MyOpenALSupport.m" du projet exemple oalTouch

typedef ALvoid	AL_APIENTRY	(*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

ALvoid alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq)
{
    static	alBufferDataStaticProcPtr	proc = NULL;
    
    if (proc == NULL) {
        proc = (alBufferDataStaticProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alBufferDataStatic");
    }
    
    if (proc) {
        proc(bid, format, data, size, freq);
    }
    
    return;
}

void* MyGetOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate)
{
    OSStatus						err = noErr;
    SInt64							theFileLengthInFrames = 0;
    AudioStreamBasicDescription		theFileFormat;
    UInt32							thePropertySize = sizeof(theFileFormat);
    ExtAudioFileRef					extRef = NULL;
    void*							theData = NULL;
    AudioStreamBasicDescription		theOutputFormat;
    
    // Open a file with ExtAudioFileOpen()
    err = ExtAudioFileOpenURL(inFileURL, &extRef);
    if(err) { printf("MyGetOpenALAudioData: ExtAudioFileOpenURL FAILED, Error = %d\n", (int)err); goto Exit; }
    
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

@end
