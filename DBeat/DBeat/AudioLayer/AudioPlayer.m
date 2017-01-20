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
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation AudioPlayer
{
    BOOL _isPlaying;
    NSTimer *_timerObj;
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


- (void)playURL:(NSURL *)url {
    if (_isPlaying) {
        [self playPause]; // Pause the previous audio player
    }
    
    // Add audioPlayer configurations here
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audioPlayer setNumberOfLoops:-1];
    [_audioPlayer setMeteringEnabled:YES];
    
    [[BeatObserver sharedManager] setAudioPlayer:self.audioPlayer];
    
    [self playPause];   // Play
}



#pragma mark - Media Picker Delegate

/*
 * This method is called when the user chooses something from the media picker screen. It dismisses the media picker screen
 * and plays the selected song.
 */
//- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection {
//    
//    // remove the media picker screen
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    
//    // grab the first selection (media picker is capable of returning more than one selected item,
//    // but this app only deals with one song at a time)
//    MPMediaItem *item = [[collection items] objectAtIndex:0];
//    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
//    [_navBar.topItem setTitle:title];
//    
//    // get a URL reference to the selected item
//    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
//    
//    // pass the URL to playURL:, defined earlier in this file
//    [self playURL:url];
//}

/*
 * This method is called when the user cancels out of the media picker. It just dismisses the media picker screen.
 */
//- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker {
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

//- (void)configureAudioPlayer {
//    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"Not_Afraid" withExtension:@"mp3"];
//    NSError *error;
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
//    if (error) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    [_audioPlayer setNumberOfLoops:-1];
//    [_audioPlayer setMeteringEnabled:YES];
//    [_visualizer setAudioPlayer:_audioPlayer];
//}



- (void)configureAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
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
