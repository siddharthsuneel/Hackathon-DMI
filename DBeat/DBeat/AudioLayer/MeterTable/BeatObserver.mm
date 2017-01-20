//
//  BeatObserver.m
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import "BeatObserver.h"
#import "MeterTable.h"

@implementation BeatObserver {
    MeterTable meterTable;
}


#pragma mark - Singleton
+ (instancetype)sharedManager {
    static BeatObserver *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static BeatObserver *sharedInstance = nil;
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

#pragma mark - Public

- (float) getScale
{
    float scale = 0.5;
    if (_audioPlayer.playing )
    {
        [_audioPlayer updateMeters];
        
        float power = 0.0f;
        for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
            power += [_audioPlayer averagePowerForChannel:i];
        }
        power /= [_audioPlayer numberOfChannels];
        
        float level = meterTable.ValueAt(power);
        scale = level * 5;
    }
    return scale;
}
@end
