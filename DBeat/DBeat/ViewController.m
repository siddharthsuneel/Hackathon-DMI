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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [audioPlayer playURL:audioFileURL];
}

- (IBAction)stopMusicButtonClicked:(id)sender {
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    [audioPlayer stop];
}


#pragma mark - observer
- (void) updateLight:(NSNotification*)notificationObj {
    NSLog(@"notification value : %@",notificationObj.object);
}
@end
