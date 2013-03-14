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
#import <QuartzCore/QuartzCore.h>

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)

@interface ViewController ()

@property float currentAngle;

@end

@implementation ViewController

@synthesize tickURLRef;
@synthesize tickObject;


- (void)viewDidLoad
{
    

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
    
    [super viewDidLoad];
    self.hourLabel.hidden = true;
    self.hourSymbol.hidden = true;
    self.minuteSymbol.hidden = true;
    self.minLabel.hidden = true;

    self.hourIsShowing = 0;
    
    
    //set up slider!
    self.slider.maximumValue = 3.0;
    self.slider.minimumValue = 1.0;
    [self.slider setValue:floorf(2) animated:NO];
    
   
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"sliderbackground.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    UIImage *sliderRightTrackImage = [[UIImage imageNamed: @"sliderbackground.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [self.slider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [self.slider setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderIcon.png"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderIcon.png"] forState:UIControlStateHighlighted];

    


    
    // for setting up ticking sound
	CFBundleRef mainBundle = CFBundleGetMainBundle ();
    tickURLRef  =	CFBundleCopyResourceURL (
												 mainBundle,
												 CFSTR ("tick"),
												 CFSTR ("wav"),
												 NULL
												 );
	
	AudioServicesCreateSystemSoundID (
									  tickURLRef,
									  &tickObject
									  );


    self.view.backgroundColor = [ChipmunkUtils chipmunkColor];
    [self scrolledToHour:0 Minute:0];
    [self.timeScrollView setupTimeScroll];
    self.timeScrollView.timeDelegate = self;
    self.rotatingTimeSelect.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didStopScrolling{
    
    CALayer *currentLayer = (CALayer *)[self.circleImage.layer presentationLayer];
    self.currentAngle = [(NSNumber *)[currentLayer valueForKeyPath:@"transform.rotation"] floatValue];

    CGAffineTransform rot = CGAffineTransformMakeRotation(self.currentAngle);
    self.circleImage.transform = rot;
    
    [self.circleImage.layer removeAllAnimations];
    
    
}

- (void)didBeginScrolling:(int)direction{
    
    CALayer *currentLayer = (CALayer *)[self.circleImage.layer presentationLayer];
    self.currentAngle = [(NSNumber *)[currentLayer valueForKeyPath:@"transform.rotation"] floatValue];
    
    CGAffineTransform rot = CGAffineTransformMakeRotation(self.currentAngle);
    self.circleImage.transform = rot;
    if(direction == 1)
    {
        
        CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fillMode = kCAFillModeForwards;
        fullRotation.fromValue = [NSNumber numberWithFloat:self.currentAngle];
        fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180+self.currentAngle)];
        fullRotation.duration = 1.5;
        fullRotation.repeatCount = 10000;
        [self.circleImage.layer addAnimation:fullRotation forKey:@"360"];
        
    }
    if(direction == 0){
        CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fillMode = kCAFillModeForwards;
        fullRotation.fromValue = [NSNumber numberWithFloat:((360*M_PI)/180+self.currentAngle)];
        fullRotation.toValue = [NSNumber numberWithFloat:self.currentAngle];
        fullRotation.duration = 1.5;
        fullRotation.repeatCount = 10000;
        [self.circleImage.layer addAnimation:fullRotation forKey:@"360"];
        
    }
  
}

- (void)scrolledToHour:(int)hour Minute:(int)minute
{    
    self.hourLabel.text = [NSString stringWithFormat:@"%d",hour];
    self.minLabel.text = [NSString stringWithFormat:@"%d",minute];
}

- (void)rotatedToHour:(int)hour Minute:(int)minute
{
    if(self.glowing == 0)
    {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    [self.minLabel.layer addAnimation:pulseAnimation forKey:nil];
    [self.hourLabel.layer addAnimation:pulseAnimation forKey:nil];
        self.glowing = 1;
    }
    [self.freeTime setHidden:YES];
    self.minuteSymbol.hidden = false;
    self.minLabel.hidden = false;
    if(![self.minLabel.text isEqualToString:[NSString stringWithFormat:@"%d",minute]])
    {
           
        self.hourLabel.text = [NSString stringWithFormat:@"%d",hour];
        self.minLabel.text = [NSString stringWithFormat:@"%d",minute];
        [self moveHourLabel:hour Minute:minute];
        //AudioServicesPlaySystemSound (tickObject); // plays sound
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
    //NSLog(@"here");
    

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

        self.hourLabel.hidden = true;
        self.hourSymbol.hidden = true;
        
        
        self.hourIsShowing = 0;


    }
    if(hour > 0 && self.hourIsShowing == 0)
    {
        self.hourLabel.hidden = false;
        self.hourSymbol.hidden = false;
        
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

- (IBAction)getActivitiesTable:(id)sender
{
    unsigned int minutes = [self getTotalMinutes];
    if(minutes > 0) {
        ActivityTableViewController* atvc = [self.storyboard instantiateViewControllerWithIdentifier:@"activityTable"];
        atvc.minutes = minutes;
        [self.navigationController pushViewController:atvc animated:YES];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Time?" message:@"Please add time by spinning the circle" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    self.glowing = 0;

}


//-(void)setTickURLRef:(CFURLRef)tickURLRef
//{
  //  _tickURLRef = tickURLRef;
//}

- (IBAction)sliderTouch:(id)sender {
    
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


- (IBAction)goOnline:(id)sender {
    [self slideToOnline];
}

- (IBAction)goBoth:(id)sender {
    [self slideToBoth];
}

- (IBAction)goOutside:(id)sender {
    [self slideToOutside];

}


-(void)slideToOnline{
    
    NSArray *fontArr = [UIFont fontNamesForFamilyName:@"Proxima Nova"];
    NSString *proxReg = [fontArr objectAtIndex:0];
    NSString *proxBold = [fontArr objectAtIndex:1];

    [self.slider setValue:floorf(self.slider.minimumValue) animated:YES];
    
    [self.insideLabel setFont:[UIFont fontWithName:proxBold size:23]];
    [self.outsideLabel setFont:[UIFont fontWithName:proxReg size:17]];
    [self.bothLabel setFont:[UIFont fontWithName:proxReg size:17]];
    
    [self.view sendSubviewToBack:self.onlineButton];
    [self.view bringSubviewToFront:self.bothButton];
    [self.view bringSubviewToFront:self.outsideButton];

}
-(void)slideToBoth{
    
    NSArray *fontArr = [UIFont fontNamesForFamilyName:@"Proxima Nova"];
    NSString *proxReg = [fontArr objectAtIndex:0];
    NSString *proxBold = [fontArr objectAtIndex:1];
    
    [self.slider setValue:floorf(2) animated:YES];
    [self.insideLabel setFont:[UIFont fontWithName:proxReg size:17]];
    [self.outsideLabel setFont:[UIFont fontWithName:proxReg size:17]];
    [self.bothLabel setFont:[UIFont fontWithName:proxBold size:23]];
    
    [self.view bringSubviewToFront:self.onlineButton];
    [self.view sendSubviewToBack:self.bothButton];
    [self.view bringSubviewToFront:self.outsideButton];
}
-(void)slideToOutside{
    
    NSArray *fontArr = [UIFont fontNamesForFamilyName:@"Proxima Nova"];
    NSString *proxReg = [fontArr objectAtIndex:0];
    NSString *proxBold = [fontArr objectAtIndex:1];
    
    [self.slider setValue:floorf(self.slider.maximumValue) animated:YES];
    [self.insideLabel setFont:[UIFont fontWithName:proxReg size:17]];
    [self.outsideLabel setFont:[UIFont fontWithName:proxBold size:23]];
    [self.bothLabel setFont:[UIFont fontWithName:proxReg size:17]];
    
    [self.view bringSubviewToFront:self.onlineButton];
    [self.view bringSubviewToFront:self.bothButton];
    [self.view sendSubviewToBack:self.outsideButton];
}

-(void) glowTime{
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    [self.minLabel.layer addAnimation:pulseAnimation forKey:nil];
    [self.minuteSymbol.layer addAnimation:pulseAnimation forKey:nil];
    [self.hourSymbol.layer addAnimation:pulseAnimation forKey:nil];
    [self.hourLabel.layer addAnimation:pulseAnimation forKey:nil];

}

-(void) stopGlowing
{
    [self.minuteSymbol.layer removeAllAnimations];
    [self.minLabel.layer removeAllAnimations];
    [self.hourLabel.layer removeAllAnimations];
    [self.hourSymbol.layer removeAllAnimations];

    
}
@end

