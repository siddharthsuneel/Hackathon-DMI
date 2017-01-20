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

@property (strong, nonatomic) VisualizerView *visualizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    songRate = 1;
    
    [super viewDidLoad];
    
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

- (IBAction)stopMusicButtonClicked:(id)sender
{
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    [audioPlayer stop];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    songRate = sender.value;
    
    NSLog(@"slider value = %f", sender.value);
}


- (void) openMediaLibraryButtonClicked {
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    [picker setAllowsPickingMultipleItems: NO];
    [self presentViewController:picker animated:YES completion:NULL];

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
    [self setTitle:title];
    
    // get a URL reference to the selected item
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    // pass the URL to playURL:, defined earlier in this file
    AudioPlayer *audioPlayer = [AudioPlayer sharedManager];
    
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
    NSLog(@"notification value : %@",notificationObj.object);
}

@end
