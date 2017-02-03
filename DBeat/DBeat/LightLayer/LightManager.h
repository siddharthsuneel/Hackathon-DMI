//
//  LightManager.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HueSDK_iOS/HueSDK.h>

@protocol ConnectionDelegate <NSObject>

- (void) connnectionDidUpdate;

@end


@import HomeKit;

@interface LightManager : NSObject

+ (instancetype)sharedManager;
- (void) enableLocalHeartbeat;
- (void)initialisation;
- (void) updateLightWithIdentifier:(NSString *)lightId state:(PHLightState*)lightState;
+ (UIColor*) randomColor;
+ (CGPoint)calculateXY:(UIColor *)color;
- (void)searchForBridgeLocal;
@property (nonatomic, weak) id <ConnectionDelegate> delegate;

@property (strong, nonatomic) NSMutableDictionary *bridgesFoundDict;

@property (strong, nonatomic) PHHueSDK *phHueSDK;
@property (nonatomic, strong) PHBridgeSearching *bridgeSearch;
@property (nonatomic, strong) PHBridgeResourcesCache *bridgeResourcesCache;
@property (nonatomic, strong) PHNotificationManager *notificationManager;
@property (nonatomic, strong) PHBridgeSendAPI *bridgeSendAPI;
@property (nonatomic, strong) HMAccessoryBrowser *accessoryBrowser;

@end
