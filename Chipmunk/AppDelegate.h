//
//  AppDelegate.h
//  Chipmunk
//
//  Created by Gabe Jacobs on 2/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager* locationManager;

@end
