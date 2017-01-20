//
//  AudioPlayer.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayer : NSObject
+ (instancetype) sharedManager;

- (void)playURL:(NSURL *)url withVolume:(float)vol
     enableRate:(BOOL)rateflag
     loopNumber:(NSInteger)no
           rate:(float)rateValue;

- (void) stop;

@end
