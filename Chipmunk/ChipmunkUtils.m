//
//  ChipmunkUtils.m
//  Chipmunk
//
//  Created by Amadou Crookes on 2/23/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ChipmunkUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChipmunkUtils

+ (UIColor*)chipmunkColor {
    return [UIColor colorWithRed:63.0/255.0 green:169.0/255.0 blue:245.0/255.0 alpha:1.0];
}
+ (UIColor*)tableColor {
    return [UIColor colorWithRed:228.0/255.0 green:229.0/255.0 blue:230.0/255.0 alpha:1.0];
}

+ (CLLocation*)getCurrentLocation {
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    return del.locationManager.location;
}

+ (CGFloat)screenWidth {
    return [ChipmunkUtils screenSize].width;
}

+ (CGFloat)screenHeight {
    return [ChipmunkUtils screenSize].height;
}

+ (CGSize)screenSize {
    return [[UIScreen mainScreen] bounds].size;
}


+ (void)roundView:(UIView*)view withCorners:(UIRectCorner)corners andRadius:(CGFloat)radius {
    
    CALayer *capa = view.layer;
    
    //Round
    CGRect bounds = capa.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
}

+ (void)addShadowToView:(UIView*)view {
    CALayer *layer = view.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
}

@end
