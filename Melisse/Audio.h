//
//  Audio.h
//  MeltedIce
//
//  Created by Raphaël Calabro on 17/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#pragma mark Sound

typedef NS_ENUM(NSInteger, Sound) {
    SoundCount
};

#pragma mark - Protocol Audio

/// Définition d'un lecteur de son.
@protocol Audio

/// Chargement d'un son.
- (void)loadSound:(Sound)sound fromResource:(NSString * _Nonnull)name;

/// Lecture du son demandé.
- (void)playSound:(Sound)sound;

/// Lecture en boucle d'une musique de fond.
- (void)playStreamAtURL:(NSURL * _Nonnull)url;

/// Lecture d'une musique de fond et exécution d'un 
- (void)playOnceStreamAtURL:(NSURL * _Nonnull)url withCompletionBlock:(void (^ _Nonnull)()) block;

/// Arrêt de la musique de fond en cours de lecture.
- (void)stopStream;

@end

#pragma mark - Interface OpenAL

/// Lecteur de son utilisant OpenAL.
@interface OpenALAudio : NSObject <Audio, AVAudioPlayerDelegate>

@end
