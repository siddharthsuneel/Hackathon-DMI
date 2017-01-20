//
//  BeatObserver.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BeatObserver : NSObject
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

+ (instancetype)sharedManager;
- (float) getScale;
@end
