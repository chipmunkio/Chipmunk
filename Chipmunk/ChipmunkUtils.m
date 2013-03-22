//
//  ChipmunkUtils.m
//  Chipmunk
//
//  Created by Amadou Crookes on 2/23/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ChipmunkUtils.h"

@implementation ChipmunkUtils

+ (UIColor*)chipmunkColor {
    return [UIColor colorWithRed:88.0/255.0 green:151.0/255.0 blue:60.0/255.0 alpha:1.0];
}
+ (UIColor*)tableColor {
    return [UIColor colorWithRed:228.0/255.0 green:229.0/255.0 blue:230.0/255.0 alpha:1.0];
}

+ (CLLocation*)getCurrentLocation {
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    return del.locationManager.location;
}


@end
