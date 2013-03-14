//
//  ViewController.h
//  Chipmunk
//
//  Created by Gabe Jacobs on 2/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatingImageView.h"
#import "DatabaseManager.h"
#include <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController <RotatingImageDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet RotatingImageView *rotatingTimeSelect;
@property (weak, nonatomic) IBOutlet UILabel *hourSymbol;
@property (weak, nonatomic) IBOutlet UILabel *minuteSymbol;
@property (nonatomic) int hourIsShowing;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *outsideLabel;
@property (weak, nonatomic) IBOutlet UILabel *bothLabel;
@property (weak, nonatomic) IBOutlet UILabel *insideLabel;
@property (weak, nonatomic) IBOutlet UIImageView *freeTime;
- (IBAction)goOnline:(id)sender;
- (IBAction)goOutside:(id)sender;
- (IBAction)goBoth:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *onlineButton;
@property (weak, nonatomic) IBOutlet UIButton *bothButton;
@property (weak, nonatomic) IBOutlet UIButton *outsideButton;

// for sound
//@property (nonatomic) CFURLRef tickURLRef;
//@property (nonatomic) SystemSoundID	tickObject;
@property (nonatomic) int	glowing;

//- (IBAction)launchActiviesView:(id)sender;


@end
