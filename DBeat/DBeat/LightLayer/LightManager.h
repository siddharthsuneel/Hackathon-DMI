//
//  LightManager.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HueSDK_iOS/HueSDK.h>

@interface LightManager : NSObject

+ (instancetype)sharedManager;
- (void) enableLocalHeartbeat;

@end
