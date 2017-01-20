//
//  AudioPlayer.m
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import "AudioPlayer.h"


@interface AudioPlayer ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation AudioPlayer
{
    BOOL _isPlaying;
}

#pragma mark - Singleton
+ (instancetype)sharedManager {
    static AudioPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static AudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark - Public Method

#pragma mark - Music control

- (void)playPause {
    if (_isPlaying) {
        // Pause audio here
        [_audioPlayer pause];
        
//        [_toolBar setItems:_playItems];  // toggle play/pause button
    }
    else {
        // Play audio here
        [_audioPlayer play];
        
//        [_toolBar setItems:_pauseItems]; // toggle play/pause button
    }
    _isPlaying = !_isPlaying;
}

- (void)playURL:(NSURL *)url {
    if (_isPlaying) {
        [self playPause]; // Pause the previous audio player
    }
    
    // Add audioPlayer configurations here
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setMeteringEnabled:YES];
//    [_visualizer setAudioPlayer:_audioPlayer];
    
    [self playPause];   // Play
}


@end
