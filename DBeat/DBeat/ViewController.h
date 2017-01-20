//
//  ViewController.h
//  DBeat
//
//  Created by Yogesh on 20/01/17.
//  Copyright © 2017 DMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *firstTrackName;
@property (nonatomic, weak) IBOutlet UILabel *seocndTrackName;

- (IBAction)playFirstMusicButtonClicked:(id)sender;
- (IBAction)firstSliderValueChanged:(UISlider *)sender;
- (IBAction)stopFirstMusicButtonClicked:(id)sender;

- (IBAction)playSecondMusicButtonClicked:(id)sender;
- (IBAction)secondSliderValueChanged:(UISlider *)sender;
- (IBAction)stopSecondMusicButtonClicked:(id)sender;
@end

