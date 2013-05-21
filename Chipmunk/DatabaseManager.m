//
//  DatabaseManager.m
//  Chipmunk
//
//  Created by Amadou Crookes on 2/24/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "DatabaseManager.h"
#import "FSNConnection.h"
#import <FacebookSDK/FacebookSDK.h>

@interface DatabaseManager ()

@end

@implementation DatabaseManager

// start a connection and return the data to the delegate
- (void)getActivities:(unsigned int)time currentLocation:(CLLocation*)geo wantOnline:(unsigned int)online wantOutside:(unsigned int)outside
{
    NSDictionary* params = @{
                             @"minutes"  : @(time),
                             @"geo"      : @"-79.32,103.81",
                             @"online"   : @(online),
                             @"outside"  : @(outside),
                             // make this a dictionary of tokens so they are all bundled together
                             @"fb_token" : [FBSession activeSession].accessTokenData.accessToken
                            };
    NSLog(@"Params: %@", params);
    FSNConnection* connection = [FSNConnection withUrl:[NSURL URLWithString:@"http://chipmunk.io/api/items/query"]
                                                method:FSNRequestMethodGET
                                               headers:[NSDictionary dictionary]
                                            parameters:params
                                            parseBlock:^id(FSNConnection *c, NSError *__autoreleasing *error) {
        return [c.responseData dictionaryFromJSONWithError:error];
    } completionBlock:^(FSNConnection *c) {
        NSError* error;
        if(c.responseData) {
            NSArray* response = [NSJSONSerialization JSONObjectWithData:c.responseData options:0 error:&error];
            // remove the item key from each object and return an array of those new objects
            NSArray* items = [response valueForKey:@"item"];
            [self.delegate receivedActivities:items];
        } else {
            [self.delegate receivedActivities:[NSArray array]];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } progressBlock:^(FSNConnection *c) {
        
    }];
    
    [connection start];
}
                                           

+ (NSDictionary*)getTokens {
    return @{@"fb" : @"accessToken"};
}





@end
