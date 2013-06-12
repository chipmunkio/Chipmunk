//
//  AppDelegate.m
//  Chipmunk
//
//  Created by Gabe Jacobs on 2/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "PocketAPI.h"

@implementation AppDelegate

@synthesize locationManager = _locationManager;
@synthesize session = _session;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // testflight integration
    [TestFlight takeOff:@"04c914dd-7506-4f2f-90c6-1b1291085c3e"];
    [[PocketAPI sharedAPI] setConsumerKey:@"14352-f8f00b94a11818a11812cb6d"];
    [Crashlytics startWithAPIKey:@"091a4baa8905651db15d358449cc69ef24a9d492"];
    NSLog(@"hi");
    
    // Override point for customization after application launch.
    [self.locationManager startUpdatingLocation];
    
    // store if the phone is retina or not
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    [[NSUserDefaults standardUserDefaults] setBool:(result.height > 480) forKey:@"isRetina"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tree2.png"]];
    
    return YES;
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // the pocket API is the only url we need to handle so only return true for that
    if([[[url absoluteString] lowercaseString] rangeOfString:@"facebook"].length > 0)
        return [FBSession.activeSession handleOpenURL:url];
    return [[PocketAPI sharedAPI] handleOpenURL:url];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:self.session];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.session close];

}

- (CLLocationManager*)locationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}

@end
