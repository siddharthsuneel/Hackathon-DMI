//
//  AudioPlayer.m
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import "AudioPlayer.h"
#import "Constants.h"
#import "BeatObserver.h"


#define kTimerInterval 0.1


@interface AudioPlayer ()

@end

@implementation AudioPlayer
{
    BOOL _isPlaying;
    NSTimer *_timerObj;
}

#pragma mark - Singleton

//+ (instancetype)sharedManager {
//    static AudioPlayer *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//    });
//    return sharedMyManager;
//}
//
//+ (id)allocWithZone:(NSZone *)zone
//{
//    static AudioPlayer *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [super allocWithZone:zone];
//    });
//    return sharedInstance;
//}

- (id)init {
    if (self = [super init]) {
        [self configureAudioSession];
    }
    return self;
}


#pragma mark - Public Method

- (void) startTimer {
    [self stopTimer];
    
    _timerObj = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(updateBeats) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    if ([_timerObj isValid]) {
        [_timerObj invalidate];
        _timerObj = nil;
    }
}

#pragma mark - Music control

- (void)playPause {
    if (_isPlaying) {
        // Pause audio here
        [_audioPlayer pause];
    }
    else {
        // Play audio here
        [_audioPlayer play];
    }
    _isPlaying = !_isPlaying;
    [self startTimer];
}


- (void) stop {
    [_audioPlayer stop];
    [self stopTimer];
}


- (void)playURL:(NSURL *)url withVolume:(float)vol
                                              enableRate:(BOOL)rateflag
                                                    loopNumber:(NSInteger)no
                                                          rate:(float)rateValue
                                                    bgView:(VisualizerView *)bgv
{
    if (_isPlaying) {
        [self playPause]; // Pause the previous audio player
    }
    
    // Add audioPlayer configurations here
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    //self.audioPlayer.volume = vol;
    self.audioPlayer.enableRate = rateflag;
    
    self.audioPlayer.rate = rateValue;
    
    if(no > 0)
    {
        [_audioPlayer setNumberOfLoops:no];
    }
    else
    {
        [_audioPlayer setNumberOfLoops:-1];
    }
    
    [_audioPlayer setMeteringEnabled:YES];
    
    [[BeatObserver sharedManager] setAudioPlayer:self.audioPlayer];
    
    [self playPause];
    
    [bgv setAudioPlayer:_audioPlayer];
}






- (void)configureAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
}


- (void) updateBeats {
    float scale = [[BeatObserver sharedManager] getScale];
    [self postNotification:scale];
}


#pragma mark - Notification

- (void) postNotification:(float)scale {
    [[NSNotificationCenter defaultCenter] postNotificationName:AudioBeatNotificationKey object:@(scale) userInfo:nil];
}

@end
