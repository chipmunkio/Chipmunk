//
//  ChipmunkUtils.m
//  Chipmunk
//
//  Created by Amadou Crookes on 2/23/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ChipmunkUtils.h"
#import "PocketAPI.h"
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
    
    CGSize size = view.frame.size;
    CGRect ovalRect = CGRectMake(0.0f, size.height + 5, size.width - 10, 15);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    layer.shadowPath = path.CGPath;
}

+ (void)saveURLToPocket:(NSString*)url {
    // force them to login before trying to save anything to pocket
    if(![PocketAPI sharedAPI].loggedIn) {
        [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error) {
            if(!error && api.loggedIn) {
                [self saveURLToPocket:url];
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not login to Pocket" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        return;
    }
    
    
    [[PocketAPI sharedAPI] saveURL:[NSURL URLWithString:url] handler:^(PocketAPI *api, NSURL *url, NSError *error) {
        if(error) {
            NSLog(@"Pocket Error: %@", error);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save to Pocket" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"Saved the url to pocket");
        }
    }];
}

+ (void)logoutPocket {
    [[PocketAPI sharedAPI] logout];
}




@end
