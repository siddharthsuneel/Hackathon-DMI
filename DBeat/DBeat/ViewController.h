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

- (IBAction)playMusicButtonClicked:(id)sender;
- (IBAction)stopMusicButtonClicked:(id)sender;
@end

