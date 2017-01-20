//
//  ViewController.m
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayer.h"
#import "Constants.h"
#import "LightManager.h"

@interface ViewController ()
{
    IBOutlet UISlider *mySlider;
    
    float songRate;
}

@property (strong, nonatomic) VisualizerView *visualizer;
@property (strong, nonatomic) AudioPlayer *firstAudioPlayer;
@property (strong, nonatomic) AudioPlayer *secondAudioPlayer;
@property (strong, nonatomic) AudioPlayer *activeAudioPlayer;

@property (strong, nonatomic) MPMediaPickerController *mediaPicker;
@end

@implementation ViewController

- (void)viewDidLoad
{
    songRate = 1;
    
    [super viewDidLoad];
    
    self.firstAudioPlayer = [[AudioPlayer alloc] init];
    self.secondAudioPlayer = [[AudioPlayer alloc] init];
    
    self.visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_visualizer];
    [self.view sendSubviewToBack:_visualizer];
    
    [mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLight:) name:AudioBeatNotificationKey object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMusicButtonClicked:(id)sender {
 
//    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
//    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"Not_Afraid" withExtension:@"mp3"];
//    
//    [audioPlayer playURL:audioFileURL
//              withVolume:1.0
//              enableRate:YES
//              loopNumber:0
//                    rate:songRate
//     bgView:self.visualizer];
    [self openMediaLibraryButtonClicked];
}



#pragma mark - First Track
- (IBAction)playFirstMusicButtonClicked:(id)sender {
    self.activeAudioPlayer = self.firstAudioPlayer;
    //[self openMediaLibraryButtonClicked];
    
        NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"Get Low" withExtension:@"mp3"];
        [self.firstAudioPlayer playURL:audioFileURL
                  withVolume:1.0
                  enableRate:YES
                  loopNumber:0
                        rate:songRate
         bgView:self.visualizer];
}

- (IBAction)firstSliderValueChanged:(UISlider *)sender {
    self.firstAudioPlayer.audioPlayer.volume = [(UISlider*)sender value];
}

- (IBAction)stopFirstMusicButtonClicked:(id)sender {
    [self.firstAudioPlayer playPause];
    [self turnoffBulb];
    
}


#pragma mark - Second Track
- (IBAction)playSecondMusicButtonClicked:(id)sender {
    self.activeAudioPlayer = self.secondAudioPlayer;
    //[self openMediaLibraryButtonClicked];
    
    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"Dangerous" withExtension:@"mp3"];
    [self.secondAudioPlayer playURL:audioFileURL
                        withVolume:1.0
                        enableRate:YES
                        loopNumber:0
                              rate:songRate
                            bgView:self.visualizer];

}

- (IBAction)secondSliderValueChanged:(UISlider *)sender {
    self.secondAudioPlayer.audioPlayer.volume = [(UISlider*)sender value];
}

- (IBAction)stopSecondMusicButtonClicked:(id)sender {
    [self.secondAudioPlayer playPause];
    [self turnoffBulb];
}



- (IBAction)sliderValueChanged:(UISlider *)sender
{
    //songRate = sender.value;
    
    NSLog(@"slider value = %f", sender.value);
}


- (void) openMediaLibraryButtonClicked {
    if (self.mediaPicker == nil) {
        MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        [picker setDelegate:self];
        [picker setAllowsPickingMultipleItems: NO];
        self.mediaPicker = picker;
    }
    [self presentViewController:self.mediaPicker animated:YES completion:NULL];
}


#pragma mark - Media Picker Delegate

/*
 * This method is called when the user chooses something from the media picker screen. It dismisses the media picker screen
 * and plays the selected song.
 */
- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) collection {
    
    // remove the media picker screen
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // grab the first selection (media picker is capable of returning more than one selected item,
    // but this app only deals with one song at a time)
    MPMediaItem *item = [[collection items] objectAtIndex:0];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    
    if (self.activeAudioPlayer == self.firstAudioPlayer) {
        self.firstTrackName.text = title;
    }else {
        self.seocndTrackName.text = title;
    }
    
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    // pass the URL to playURL:, defined earlier in this file
    AudioPlayer *audioPlayer = self.activeAudioPlayer;
    
    [audioPlayer playURL:url
              withVolume:1.0
              enableRate:YES
              loopNumber:-1
                    rate:songRate
                  bgView:self.visualizer];
}

/*
 * This method is called when the user cancels out of the media picker. It just dismisses the media picker screen.
 */
- (void)mediaPickerDidCancel:(MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - observer:

- (void) updateLight:(NSNotification*)notificationObj
{
    //NSLog(@"notification value : %@",notificationObj.object);
    NSDictionary *userInfo = notificationObj.userInfo;
    CGFloat scaleValue = 0.5;
    AudioPlayer *audioPlayer = [userInfo objectForKey:NotificationValue_Player];
    
    if (self.firstAudioPlayer.audioPlayer.volume < self.secondAudioPlayer.audioPlayer.volume) {
        if (audioPlayer == self.secondAudioPlayer) {
            scaleValue = [[userInfo objectForKey:NotificationValue_Scale] floatValue];
        }
    }else {
        if (audioPlayer == self.firstAudioPlayer) {
            scaleValue = [[userInfo objectForKey:NotificationValue_Scale] floatValue];
        }
    }
    
    NSLog(@"scale value : %f",scaleValue);
    
    if (scaleValue > 2.0) {
        scaleValue += scaleValue * 0.9;
        if (scaleValue >= 5) {
            scaleValue = 5;
        }
    }else {
        scaleValue -= scaleValue * 0.1;
        if (scaleValue < 0.4) {
            scaleValue = 0.0;
        }
    }
    
    NSLog(@"new scale value : %f",scaleValue);

    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    UIColor *colorObj = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    CGPoint point = [LightManager calculateXY:colorObj];
    
    PHLightState *newLightState = [[PHLightState alloc] init];
    newLightState.brightness = [NSNumber numberWithInt:(scaleValue * 50)];
    newLightState.x = @(point.x);
    newLightState.y = @(point.y);
    newLightState.on = (scaleValue <= 0.4)?[NSNumber numberWithBool:false]:[NSNumber numberWithBool:true];
    
    if (self.activeAudioPlayer == self.secondAudioPlayer) {
        newLightState.transitionTime = [NSNumber numberWithInteger:0];
    }
    
    static int count = 0;
    switch (count) {
        case 0:
            [self updateLight1:newLightState];
            break;
        case 1:
            [self updateLight2:newLightState];
            break;
        case 2:
            [self updateLight3:newLightState];
            break;
        default:
            [self updateLight1:newLightState];
            [self updateLight2:newLightState];
            [self updateLight3:newLightState];
            break;
    }
    
    count++;
    if (count > 2) {
        count = 0;
    }
    
    
}

- (void) updateLight1:(PHLightState*)lightState {
    
    [[LightManager sharedManager] updateLightWithIdentifier:@"1" state:lightState];
}

- (void) updateLight2:(PHLightState*)lightState {
    
    [[LightManager sharedManager] updateLightWithIdentifier:@"2" state:lightState];
}

- (void) updateLight3:(PHLightState*)lightState {
    
    [[LightManager sharedManager] updateLightWithIdentifier:@"3" state:lightState];
}

- (void) turnoffBulb {
    PHLightState *newLightState = [[PHLightState alloc] init];
    newLightState.on = [NSNumber numberWithBool:false];
    [self updateLight1:newLightState];
    [self updateLight2:newLightState];
    [self updateLight3:newLightState];
}
@end
