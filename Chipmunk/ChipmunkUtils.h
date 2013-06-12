//
//  ChipmunkUtils.h
//  Chipmunk
//
//  Created by Amadou Crookes on 2/23/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ChipmunkUtils : NSObject

+ (UIColor*)chipmunkColor;
+ (UIColor*)tableColor;
+ (CLLocation*)getCurrentLocation;
+ (void)roundView:(UIView*)view withCorners:(UIRectCorner)corners andRadius:(CGFloat)radius;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGSize)screenSize;
+ (void)addShadowToView:(UIView*)view;
+ (void)saveURLToPocket:(NSString*)url;
+ (void)stopUpdatingLocation;
+ (void)startUpdatingLocation;
    
    
@end
