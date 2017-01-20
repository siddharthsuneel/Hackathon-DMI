//
//  AppDelegate.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <HueSDK_iOS/HueSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PHHueSDK *phHueSDK;

@end

