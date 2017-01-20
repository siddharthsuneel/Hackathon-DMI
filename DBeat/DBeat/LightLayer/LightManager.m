//
//  LightManager.m
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import "LightManager.h"
#import "UIAlertController+Blocks.h"

@interface LightManager()<HMAccessoryBrowserDelegate,HMHomeManagerDelegate, HMHomeDelegate, HMAccessoryDelegate>

@property (strong, nonatomic) NSMutableDictionary *bridgesFoundDict;

@property (strong, nonatomic) PHHueSDK *phHueSDK;
@property (nonatomic, strong) PHBridgeSearching *bridgeSearch;
@property (nonatomic, strong) PHBridgeResourcesCache *bridgeResourcesCache;
@property (nonatomic, strong) PHNotificationManager *notificationManager;
@property (nonatomic, strong) PHBridgeSendAPI *bridgeSendAPI;
@property (nonatomic, strong) HMAccessoryBrowser *accessoryBrowser;

@end

@implementation LightManager

#pragma mark - Singleton
+ (instancetype)sharedManager {
    static LightManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initialisation];
    });
    return sharedInstance;
}

- (void)initialisation {
    self.bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
    self.phHueSDK = [[PHHueSDK alloc] init];
    [self.phHueSDK startUpSDK];
    [self.phHueSDK enableLogging:YES];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadConnectedBridgeValues) userInfo:nil repeats:YES];
    [self enableLocalHeartbeat];
    [self registerPHHueSDKNotifications];
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
}

- (void) registerPHHueSDKNotifications {
    self.notificationManager = [PHNotificationManager defaultManager];
    
    [self.notificationManager registerObject:self withSelector:@selector(checkConnectionState) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [self.notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    [self.notificationManager registerObject:self withSelector:@selector(authenticationSuccess) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION];
    [self.notificationManager registerObject:self withSelector:@selector(authenticationFailed) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION];
    [self.notificationManager registerObject:self withSelector:@selector(noLocalBridge) forNotification:PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION];
    [self.notificationManager registerObject:self withSelector:@selector(buttonNotPressed) forNotification:PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION];
}

- (void) enableLocalHeartbeat {
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if (cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil) {
        
        //TODO: show connecting loader...
        
        // Enable heartbeat with interval of 10 seconds
        [self.phHueSDK enableLocalConnection];
    } else {
        // Automaticly start searching for bridges
        [self searchForBridgeLocal];
    }
}

- (void) disableLocalHeartbeat {
    [self.phHueSDK disableLocalConnection];
}

- (void)searchForBridgeLocal {
    
    // Stop heartbeats
    [self disableLocalHeartbeat];
    
    // TODO: Show search screen loader...
    
    // Start search

    self.bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAddressSearch:YES];
    [self.bridgeSearch startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {
        
        if (bridgesFound.count > 0) {
            
            self.bridgesFoundDict = (NSMutableDictionary *)bridgesFound;
            NSString *macAddress = bridgesFound.allKeys[0];
            NSString *ipAddress = bridgesFound.allValues[0];
            
            NSLog(@"Bridge Mac Address: %@, & ipAddress: %@",macAddress, ipAddress);
            
            [self.phHueSDK setBridgeToUseWithId:macAddress ipAddress:ipAddress];
            [self startAuthentication];
        }else {
            [self noBridgeFoundAction];
        }
        
    }];
}

- (void) startAuthentication {
    [self showAlertPopUpWithTitle:@"" message:@"Push authentication button on bridge."];
    [self.phHueSDK startPushlinkAuthentication];
}

- (void) noBridgeFoundAction {
    [self showAlertPopUpWithTitle:@"" message:@"Bridge not found."];
}

- (void) loadConnectedBridgeValues {
    if (self.phHueSDK != nil) {
        self.bridgeResourcesCache = [PHBridgeResourcesReader readBridgeResourcesCache];
        if (self.bridgeResourcesCache == nil) {
            
            [self searchForBridgeLocal];
        }else {
            if ([self.bridgeResourcesCache bridgeConfiguration] != nil && [self.bridgeResourcesCache bridgeConfiguration].ipaddress) {
                
                if (self.bridgeResourcesCache.lights != nil) {
                    // TODO: load lights in dictionary....
                }
            }
        }
    }
}

#pragma mark - Notification Methods

- (void) checkConnectionState {
    if ([self.phHueSDK localConnected] == false) {
        NSLog(@"Not connected at all");
    }else {
        NSLog(@"One of the connections is made");
    }
}

- (void) authenticationSuccess {
    
    [self showAlertPopUpWithTitle:@"" message:@"Authentication success."];
    
    // Deregister for all notifications
    [self.notificationManager deregisterObjectForAllNotifications:self];
    
    self.bridgeResourcesCache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if (self.bridgeResourcesCache == nil){
        
        [self searchForBridgeLocal];
    }else {
        NSLog(@"Available Lights: %@", self.bridgeResourcesCache.lights);
    }
}

- (void) authenticationFailed {
    
    // TODO: Show try again alert
    [self showAlertPopUpWithTitle:@"Oops !!" message:@"Authentication failed. Try again."];
}

- (void) noLocalConnection {
    //[self showAlertPopUpWithTitle:@"" message:@"Connection with Bridge Lost."];
}

- (void) noLocalBridge {
    [self showAlertPopUpWithTitle:@"" message:@"Local Bridge Not Found."];
}

- (void) buttonNotPressed {
    [self showAlertPopUpWithTitle:@"Time out" message:@"Push link button not pressed."];
}

- (void)showAlertPopUpWithTitle:(NSString*)title message:(NSString*)message {
    UIViewController *viewController = [[[UIApplication sharedApplication].delegate window] rootViewController];
    
    [UIAlertController showAlertInViewController:viewController withTitle:title message:message cancelButtonTitle:@"Ok" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
    }];
}

#pragma mark - Color Methods

+ (UIColor*) randomColor {
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

+ (CGPoint)calculateXY:(UIColor *)color {
    CGColorRef cgColor = [color CGColor];
    
    const CGFloat *components = CGColorGetComponents(cgColor);
    long numberOfComponents = CGColorGetNumberOfComponents(cgColor);
    
    // Default to white
    CGFloat red = 1.0f;
    CGFloat green = 1.0f;
    CGFloat blue = 1.0f;
    
    if (numberOfComponents == 4) {
        // Full color
        red = components[0];
        green = components[1];
        blue = components[2];
    }
    else if (numberOfComponents == 2) {
        // Greyscale color
        red = green = blue = components[0];
    }
    
    // Apply gamma correction
    float r = (red   > 0.04045f) ? pow((red   + 0.055f) / (1.0f + 0.055f), 2.4f) : (red   / 12.92f);
    float g = (green > 0.04045f) ? pow((green + 0.055f) / (1.0f + 0.055f), 2.4f) : (green / 12.92f);
    float b = (blue  > 0.04045f) ? pow((blue  + 0.055f) / (1.0f + 0.055f), 2.4f) : (blue  / 12.92f);
    
    // Wide gamut conversion D65
    float X = r * 0.664511f + g * 0.154324f + b * 0.162028f;
    float Y = r * 0.283881f + g * 0.668433f + b * 0.047685f;
    float Z = r * 0.000088f + g * 0.072310f + b * 0.986039f;
    
    float cx = X / (X + Y + Z);
    float cy = Y / (X + Y + Z);
    
    if (isnan(cx)) {
        cx = 0.0f;
    }
    
    if (isnan(cy)) {
        cy = 0.0f;
    }
    
    return CGPointMake(cx, cy);
}

#pragma mark -Light service calls

- (void) updateLightWithIdentifier:(NSString *)lightId state:(PHLightState*)lightState {    
    [self.bridgeSendAPI updateLightStateForId:lightId withLightState:lightState completionHandler:^(NSArray *errors) {
        
        if (errors) {
            //TODO: show error popup...
        }
    }];
}

@end
