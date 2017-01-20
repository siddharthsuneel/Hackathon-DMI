//
//  AudioPlayer.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VisualizerView.h"


@interface AudioPlayer : NSObject
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

//+ (instancetype) sharedManager;

- (void)playURL:(NSURL *)url withVolume:(float)vol
     enableRate:(BOOL)rateflag
     loopNumber:(NSInteger)no
           rate:(float)rateValue
         bgView:(VisualizerView *)bgv;

- (void) stop;
- (void) playPause;
@end
