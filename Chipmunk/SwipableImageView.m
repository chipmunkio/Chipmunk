//
//  SwipableImageView.m
//  Chipmunk
//
//  Created by Amadou Crookes on 4/2/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "SwipableImageView.h"

@interface SwipableImageView ()

@property (nonatomic) CGPoint beganTouchLocation;

@end

@implementation SwipableImageView

@synthesize delegate = _delegate;
@synthesize beganTouchLocation = _beganTouchLocation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//*********************************************************
//*********************************************************
#pragma mark - Touch Events
//*********************************************************
//*********************************************************


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    self.beganTouchLocation = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    int pageMiddle = 160; // DELME -- do not hard code this value
    int middleX = self.center.x;
    int newX = middleX + location.x - self.beganTouchLocation.x;
    if(pageMiddle >= newX) {
        self.center = CGPointMake(newX, self.center.y);
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.center.x <= 0) {
        [self.delegate animateSwipeImageOffScreen];
    } else {
        int screenWidth = 320; // all iphones are currently 320 -- still get the width from a function
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(screenWidth/2, self.center.y);
        }];
    }
    
}



@end
