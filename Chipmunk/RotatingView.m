//
//  RotatingView.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/16/13.
//  Copyright (c) 2013 Amadou Crookes. All rights reserved.
//

#import "RotatingView.h"
#import "RotatingImageView.h"
#import <QuartzCore/QuartzCore.h>

#define radiansToDegrees(radians) (radians * 180 / M_PI)
#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

// the distance from the outer most circle to the outer edge of the dynamic circle
const int RADIUS_DELTA = 10;
// the thickness of the part that moves
const int DYNAMIC_WIDTH = 40;

@interface RotatingView ()

@property (nonatomic) CGPoint beganTouchLocation;
@property (nonatomic) float deltaAngle;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic, strong) RotatingImageView* rotate;

@end

@implementation RotatingView

@synthesize beganTouchLocation = _beganTouchLocation;
@synthesize deltaAngle = _deltaAngle;
@synthesize startTransform = _startTransform;
@synthesize currentAngle = _currentAngle;
@synthesize rotate = _rotate;

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
#pragma mark - Drawing
//*********************************************************
//*********************************************************

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    [self drawStaticCircles:context];
    [self drawDynamicCircles:context];
    
}

// boring stuff that doesnt change
- (void)drawStaticCircles:(CGContextRef)context {
    [[UIColor blackColor] setStroke]; //draw this circle as white
    [[UIColor redColor] setFill];
    
    //center of this view
    float viewCenterX = self.bounds.size.width/2;
    float viewCenterY = self.bounds.size.height/2;
    CGContextAddArc(context, viewCenterX, viewCenterY, self.bounds.size.width/2, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
}


- (void)drawDynamicCircles:(CGContextRef)context {
    float radiusDynamic = self.bounds.size.width/2 - RADIUS_DELTA;
    float viewCenterX   = self.bounds.size.width/2;
    float viewCenterY   = self.bounds.size.height/2;
    
    // draw the time that has passed
    [[UIColor purpleColor] set];
    CGContextMoveToPoint(context, viewCenterX, viewCenterY);
    CGContextAddArc(context, viewCenterX, viewCenterY, radiusDynamic, 0, self.currentAngle, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw the remaining area
    [[UIColor greenColor] set];
    CGContextMoveToPoint(context, viewCenterX, viewCenterY);
    CGContextAddArc(context, viewCenterX, viewCenterY, radiusDynamic, self.currentAngle, 2*M_PI, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw the inner black circle
    [[UIColor blackColor] set];
    CGContextAddArc(context, viewCenterX, viewCenterY, radiusDynamic - DYNAMIC_WIDTH, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // calculate the center of the knob based on the angle and the radius
    
    CGContextDrawPath(context, kCGPathFillStroke);
}



//*********************************************************
//*********************************************************
#pragma mark - Touch Events
//*********************************************************
//*********************************************************

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.rotate touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.rotate touchesMoved:touches withEvent:event];
    CALayer* layer = [self.rotate.layer presentationLayer];
    float angle = [[layer valueForKeyPath:@"transform.rotation"] floatValue];
    angle = radiansToDegrees(angle);
    if(angle < 0) {
        angle += 360;
    }
    NSLog(@"ANGLE: %f", angle);
    self.currentAngle = degreesToRadians(angle);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}



//*********************************************************
//*********************************************************
#pragma mark - Calculations
//*********************************************************
//*********************************************************

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

- (void)timeBasedOnRotations {
//    unsigned int totalMins = [self totalMinutes];
//    [self.delegate rotatedToHour:totalMins/60 Minute:totalMins - ((totalMins/60)*60)];
}

- (unsigned int)totalMinutes {
    // get the time based on the current angle
    unsigned int totalMins = 10;
    return totalMins;
}

//*********************************************************
//*********************************************************
#pragma mark - Setters & Getters
//*********************************************************
//*********************************************************

- (void)setCurrentAngle:(float)currentAngle {
    _currentAngle = currentAngle;
    [self setNeedsDisplay]; //everytime the angle changes redraw the circle
}

- (UIView*)rotate {
    if(!_rotate) {
        _rotate = [[RotatingImageView alloc] initWithFrame:self.frame];
        _rotate.alpha = 0;
        [self.superview insertSubview:_rotate belowSubview:self];
    }
    return _rotate;
}

- (float)currentAngle {
    return _currentAngle;
}

@end
