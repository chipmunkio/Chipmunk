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
const int DYNAMIC_WIDTH = 20;
const int MINUTES_IN_ROTATION = 121;

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

// point represents the top left corner of the view as usual
- (RotatingView*)rotatingView:(float)radius Point:(CGPoint)pnt Delegate:(id <RotatingViewDelegate>)del {
    
    RotatingView* rv = [[RotatingView alloc] initWithFrame:CGRectMake(pnt.x, pnt.y, radius*2, radius*2)];
    rv.delegate = del;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedTime:)];
    tap.numberOfTapsRequired = 1;
    [rv addGestureRecognizer:tap];
    return rv;
}

- (IBAction)selectedTime:(UITapGestureRecognizer*)tap {
    CGPoint loc = [tap locationInView:self];
    
    float viewCenterX   = self.bounds.size.width/2;
    float viewCenterY   = self.bounds.size.height/2;
    
    // the distance of this point from the center
    float dist = sqrt(pow((viewCenterX - loc.x),2) + pow((viewCenterY - loc.y), 2));
    // minus 5 to give some extra space by the knob
    if(dist <= self.bounds.size.width/2 - RADIUS_DELTA - DYNAMIC_WIDTH - 5) {
        NSLog(@"SELECTED");
        [self sendTimeToDelegateBasedOnAngle];
    }
    
    
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
    [[ChipmunkUtils chipmunkColor] setStroke];
    [[UIColor clearColor] setFill];
    //center of this view
    float viewCenterX = self.bounds.size.width/2;
    float viewCenterY = self.bounds.size.height/2;
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, viewCenterX, viewCenterY, self.bounds.size.width/2-1.0, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
}


- (void)drawDynamicCircles:(CGContextRef)context {
    float radiusDynamic = self.bounds.size.width/2 - RADIUS_DELTA;
    float viewCenterX   = self.bounds.size.width/2;
    float viewCenterY   = self.bounds.size.height/2;
    float offset = -M_PI/2;
    
    // draw the time that has passed
    [[ChipmunkUtils chipmunkColor] set];
    CGContextMoveToPoint(context, viewCenterX, viewCenterY);
    CGContextAddArc(context, viewCenterX, viewCenterY, radiusDynamic, 0 + offset, self.currentAngle + offset, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw the remaining area
    [[UIColor colorWithRed:123.0/255.0 green:229.0/255.0 blue:255.0/255.0 alpha:1.0] set];
    CGContextMoveToPoint(context, viewCenterX, viewCenterY);
    CGContextAddArc(context, viewCenterX, viewCenterY, radiusDynamic, self.currentAngle + offset, 2*M_PI + offset, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // calculate the center of the knob based on the angle and the radius
    float knobDist = self.bounds.size.width/2 - RADIUS_DELTA - DYNAMIC_WIDTH/2;
    float knobX = viewCenterX + knobDist * cos(self.currentAngle - M_PI/2);
    float knobY = viewCenterY + knobDist * sin(self.currentAngle - M_PI/2);
    float knobRadius = RADIUS_DELTA + DYNAMIC_WIDTH/2;
    
    // draw the white border around the knob
    [[UIColor whiteColor] set];
    CGContextAddArc(context, knobX, knobY, knobRadius - 3, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw the inner black circle
    [[UIColor blackColor] set];
    CGContextAddArc(context, viewCenterX, viewCenterY, radiusDynamic - DYNAMIC_WIDTH, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw the actual knob
    [[ChipmunkUtils chipmunkColor] set];
    CGContextAddArc(context, knobX, knobY, knobRadius - 4, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
}



//*********************************************************
//*********************************************************
#pragma mark - Touch Events
//*********************************************************
//*********************************************************

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // restrict this so they must click near the knob
    
    // find knob center using current angle
    // decided how close they must be to the knob
    // make sure this touch is within that radius of the center of the knob same way deciding if the gesture is valid
    
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
    self.currentAngle = degreesToRadians(angle);
    [self sendTimeToDelegateBasedOnAngle];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
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

- (void)sendTimeToDelegateBasedOnAngle {
    unsigned int mins = [self totalMinutes];
    [self.delegate selectedHours:mins/60 Minutes:mins%60];
}

- (unsigned int)totalMinutes {
    // get the time based on the current angle
    float angle = radiansToDegrees(self.currentAngle);
    int mins  = MINUTES_IN_ROTATION * (angle/360);
    return mins;
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
