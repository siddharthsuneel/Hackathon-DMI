//
//  ViewController.m
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayer.h"


@interface ViewController ()
{
    IBOutlet UISlider *mySlider;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMusicButtonClicked:(id)sender {
 
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"Not_Afraid" withExtension:@"mp3"];
    [audioPlayer playURL:audioFileURL];
}

- (IBAction)stopMusicButtonClicked:(id)sender {
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    [audioPlayer stop];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"slider value = %f", sender.value);
}

@end
