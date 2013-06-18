//
//  ViewController.m
//  Chipmunk
//
//  Created by Gabe Jacobs on 2/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ViewController.h"
#import "ChipmunkUtils.h"
#import "ActivityTableViewController.h"
#import "ActivitySelectionController.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)

typedef enum SliderLocation {
    SliderLocationInside = 0,
    SliderLocationBoth,
    SliderLocationOutside
} SliderLocation;


@interface ViewController ()

@property float currentAngle;

@end

@implementation ViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //SET UP LABELS
    NSArray *fontArr = [UIFont fontNamesForFamilyName:@"Proxima Nova"];
    NSString *proxReg = [fontArr objectAtIndex:0];
    NSString *proxBold = [fontArr objectAtIndex:1];
    [self.hourLabel setFont:[UIFont fontWithName:proxReg size:self.hourLabel.font.pointSize]];
    [self.minLabel setFont:[UIFont fontWithName:proxReg size:self.minLabel.font.pointSize]];
    [self.minuteSymbol setFont:[UIFont fontWithName:proxReg size:self.minuteSymbol.font.pointSize]];
    [self.hourSymbol setFont:[UIFont fontWithName:proxReg size:self.hourSymbol.font.pointSize]];
    [self.insideLabel setFont:[UIFont fontWithName:proxReg size:self.insideLabel.   font.pointSize]];
    [self.outsideLabel setFont:[UIFont fontWithName:proxReg size:self.outsideLabel.font.pointSize]];
     [self.bothLabel setFont:[UIFont fontWithName:proxBold size:23]];
    
    self.minLabel.hidden     = NO;
    self.minuteSymbol.hidden = NO;
    self.hourLabel.hidden    = YES;
    self.hourLabel.hidden    = YES;
    
    self.hourIsShowing = 0;
    
    
    //set up slider!
    self.slider.maximumValue = 3.0;
    self.slider.minimumValue = 1.0;
    [self.slider setValue:floorf(2) animated:NO];
    
   
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"sliderbackground.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    UIImage *sliderRightTrackImage = [[UIImage imageNamed: @"sliderbackground.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [self.slider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [self.slider setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"buttonslider.png"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"buttonslider.png"] forState:UIControlStateHighlighted];

    self.view.backgroundColor = [UIColor clearColor];
    self.circle.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    
    if(FBSession.activeSession.state != FBSessionStateCreatedTokenLoaded) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"] animated:NO completion:nil];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotatedToHour:(int)hour Minutes:(int)minute
{

    [self.freeTime setHidden:YES];
    if(![self.minLabel.text isEqualToString:[NSString stringWithFormat:@"%d",minute]]) {
        self.hourLabel.text = [NSString stringWithFormat:@"%d",hour];
        self.minLabel.text = [NSString stringWithFormat:@"%d",minute];
        [self moveHourLabel:hour Minute:minute];
        //AudioServicesPlaySystemSound (tickObject); // plays sound
    }
}

- (void)selectedTime:(unsigned int)mins {
    if(mins > 0) {
        ActivityTableViewController* atvc = [ActivityTableViewController activityTableWithMinutes:mins
                                                                                  currentLocation:[ChipmunkUtils getCurrentLocation]
                                                                                       wantOnline:0
                                                                                      wantOutside:0];
        [ChipmunkUtils stopUpdatingLocation]; // stop updating
        [self.navigationController pushViewController:atvc animated:YES];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Time?" message:@"Please add time by spinning the circle" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (unsigned int)getTotalMinutes
{
    int hours = [self.hourLabel.text intValue];
    int minutes = [self.minLabel.text intValue];
    return (hours * 60) + minutes;
}

- (void)moveHourLabel:(int)hour Minute:(int)minute;
{

    if(hour == 0 && self.hourIsShowing == 1)
    {
      
        CGRect hLabelFrame = self.hourLabel.frame;
        hLabelFrame.origin.x = hLabelFrame.origin.x+35; // new x coordinate
        hLabelFrame.origin.y = hLabelFrame.origin.y; // new y coordinate
        CGRect hSymbolFrame = self.hourSymbol.frame;
        hSymbolFrame.origin.x = hSymbolFrame.origin.x+35; // new x coordinate
        hSymbolFrame.origin.y = hSymbolFrame.origin.y; // new y coordinate
    
        
        //not sure how to do this (above) after fade animation. Fade overides this as it is now
        
        CGRect mLabelFrame = self.minLabel.frame;
        mLabelFrame.origin.x = mLabelFrame.origin.x-32; // new x coordinate
        mLabelFrame.origin.y = mLabelFrame.origin.y; // new y coordinate
        CGRect mSymbolFrame = self.minuteSymbol.frame;
        mSymbolFrame.origin.x = mSymbolFrame.origin.x-32; // new x coordinate
        mSymbolFrame.origin.y = mSymbolFrame.origin.y; // new y coordinate
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: .4];
        self.hourLabel.frame = hLabelFrame;
        self.hourSymbol.frame = hSymbolFrame;
        self.minLabel.frame = mLabelFrame;
        self.minuteSymbol.frame = mSymbolFrame;
        
        [UIView commitAnimations];
        

        CATransition *labelAnimation = [CATransition animation];
        labelAnimation.type = kCATransitionFade;
        labelAnimation.duration = .25;
        CATransition *symbolAnimation = [CATransition animation];
        symbolAnimation.type = kCATransitionFade;
        symbolAnimation.duration = .7;
        [self.hourLabel.layer addAnimation:labelAnimation forKey:nil];
        [self.hourSymbol.layer addAnimation:symbolAnimation forKey:nil];

        self.hourLabel.hidden  = YES;
        self.hourSymbol.hidden = YES;
        
        
        self.hourIsShowing = 0;


    }
    if(hour > 0 && self.hourIsShowing == 0)
    {
        self.hourLabel.hidden  = YES;
        self.hourSymbol.hidden = YES;
        
        CGRect hLabelFrame = self.hourLabel.frame;
        hLabelFrame.origin.x = hLabelFrame.origin.x-35; // new x coordinate
        hLabelFrame.origin.y = hLabelFrame.origin.y; // new y coordinate
        CGRect hSymbolFrame = self.hourSymbol.frame;
        hSymbolFrame.origin.x = hSymbolFrame.origin.x-35; // new x coordinate
        hSymbolFrame.origin.y = hSymbolFrame.origin.y; // new y coordinate
        CGRect mLabelFrame = self.minLabel.frame;
        mLabelFrame.origin.x = mLabelFrame.origin.x+32; // new x coordinate
        mLabelFrame.origin.y = mLabelFrame.origin.y; // new y coordinate
        CGRect mSymbolFrame = self.minuteSymbol.frame;
        mSymbolFrame.origin.x = mSymbolFrame.origin.x+32; // new x coordinate
        mSymbolFrame.origin.y = mSymbolFrame.origin.y; // new y coordinate
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: .4];
        self.hourLabel.frame = hLabelFrame;
        self.hourSymbol.frame = hSymbolFrame;
        self.minLabel.frame = mLabelFrame;
        self.minuteSymbol.frame = mSymbolFrame;

        [UIView commitAnimations];
        
        
        
        self.hourIsShowing = 1;

    }
}


- (IBAction)getActivitiesController:(id)sender {
    unsigned int totalMins = [self getTotalMinutes];

    if(totalMins > 0) {
        ActivityTableViewController* atvc = [ActivityTableViewController activityTableWithMinutes:totalMins
                                                                                  currentLocation:[ChipmunkUtils getCurrentLocation]
                                                                                       wantOnline:0
                                                                                      wantOutside:0];
        [ChipmunkUtils stopUpdatingLocation]; // stop updating
        [self.navigationController pushViewController:atvc animated:YES];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Time?" message:@"Please add time by spinning the circle" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)sliderTouch:(id)sender {
    
    NSLog(@"%f", self.slider.value);
    if(self.slider.value > 2.4)
    {
        [self slideToOutside];
    }
    else if(self.slider.value < 1.6)
    {
        [self slideToOnline];
    }
    else
    {
        [self slideToBoth];
    }
    
}
- (IBAction)checkHalf:(id)sender {
    
    NSArray *fontArr = [UIFont fontNamesForFamilyName:@"Proxima Nova"];
    NSString *proxReg = [fontArr objectAtIndex:0];
    NSString *proxBold = [fontArr objectAtIndex:1];
    
    
    if(self.slider.value > 2.4)
    {
        [self.insideLabel setFont:[UIFont fontWithName:proxReg size:17]];
        [self.outsideLabel setFont:[UIFont fontWithName:proxBold size:23]];
        [self.bothLabel setFont:[UIFont fontWithName:proxReg size:17]];
    }
    else if(self.slider.value < 1.6)
    {
        [self.insideLabel setFont:[UIFont fontWithName:proxBold size:23]];
        [self.outsideLabel setFont:[UIFont fontWithName:proxReg size:17]];
        [self.bothLabel setFont:[UIFont fontWithName:proxReg size:17]];
    }
    else
    {
        [self.insideLabel setFont:[UIFont fontWithName:proxReg size:17]];
        [self.outsideLabel setFont:[UIFont fontWithName:proxReg size:17]];
        [self.bothLabel setFont:[UIFont fontWithName:proxBold size:23]];
    }
}


- (IBAction)goOnline:(id)sender {
    [self slideToOnline];
}

- (IBAction)goBoth:(id)sender {
    [self slideToBoth];
}

- (IBAction)goOutside:(id)sender {
    [self slideToOutside];

}

// slideTo* functions are al exactly the same
// create one function that all of these call with args

-(void)slideToOnline {
    [self slideToLocation:self.insideLabel
              secondLabel:self.outsideLabel
               thirdLabel:self.bothLabel];
    
}

-(void)slideToBoth{
    [self slideToLocation:self.bothLabel
              secondLabel:self.outsideLabel
               thirdLabel:self.insideLabel];
}

-(void)slideToOutside{
    [self slideToLocation:self.outsideLabel
              secondLabel:self.bothLabel
               thirdLabel:self.insideLabel];
}


- (void)slideToLocation:(UILabel*)selected secondLabel:(UILabel*)second thirdLabel:(UILabel*)third {
    
    NSArray *fontArr = [UIFont fontNamesForFamilyName:@"Proxima Nova"];
    NSString *proxReg = [fontArr objectAtIndex:0];
    NSString *proxBold = [fontArr objectAtIndex:1];
    float sliderValue;
    SliderLocation loc = SliderLocationBoth;
    if(selected == self.bothLabel) {
        sliderValue = 2.0;
    } else if(selected == self.insideLabel) {
        loc = SliderLocationInside;
        sliderValue = self.slider.minimumValue;
    } else {
        loc = SliderLocationOutside;
        sliderValue = self.slider.maximumValue;
    }
    
    // bring the buttons forward or move them back
    NSArray* buttons = [NSArray arrayWithObjects:self.onlineButton, self.bothButton, self.outsideButton, nil];
    for(int i = 0; i < buttons.count; i++) {
        if(loc == i) {
            [self.view sendSubviewToBack:buttons[i]];
        } else {
            [self.view bringSubviewToFront:buttons[i]];
        }
    }
    NSLog(@"SliderValue: %f", sliderValue);
    [self.slider setValue:floorf(sliderValue) animated:YES];
    [selected    setFont:[UIFont fontWithName:proxBold size:23]];
    [second      setFont:[UIFont fontWithName:proxReg size:17]];
    [third       setFont:[UIFont fontWithName:proxReg size:17]];
}


-(void)glowTime{
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    [self.minLabel.layer addAnimation:pulseAnimation forKey:@"glow"];
    //[self.minuteSymbol.layer addAnimation:pulseAnimation forKey:@"glow"];
   // [self.hourSymbol.layer addAnimation:pulseAnimation forKey:@"glow"];
    [self.hourLabel.layer addAnimation:pulseAnimation forKey:@"glow"];

}

-(void) stopGlowing
{
    //[self.minuteSymbol.layer removeAnimationForKey:@"glow"];
    [self.minLabel.layer removeAnimationForKey:@"glow"];
    [self.hourLabel.layer removeAnimationForKey:@"glow"];
    //C[self.hourSymbol.layer removeAnimationForKey:@"glow"];

    
}
@end

