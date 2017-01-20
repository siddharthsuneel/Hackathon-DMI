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

@interface ViewController ()
{
    IBOutlet UISlider *mySlider;
    
    float songRate;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    songRate = 0;
    
    [super viewDidLoad];
    
    [mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLight:) name:AudioBeatNotificationKey object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMusicButtonClicked:(id)sender {
 
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"Not_Afraid" withExtension:@"mp3"];
    
    [audioPlayer playURL:audioFileURL
              withVolume:1.0
              enableRate:YES
              loopNumber:0
                    rate:songRate];
}

- (IBAction)stopMusicButtonClicked:(id)sender {
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    [audioPlayer stop];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    songRate = sender.value;
    
    NSLog(@"slider value = %f", sender.value);
}

#pragma mark - observer:

- (void) updateLight:(NSNotification*)notificationObj
{
    NSLog(@"notification value : %@",notificationObj.object);
}

@end
