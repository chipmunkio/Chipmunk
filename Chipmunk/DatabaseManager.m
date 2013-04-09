//
//  DatabaseManager.m
//  Chipmunk
//
//  Created by Amadou Crookes on 2/24/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "DatabaseManager.h"
#import "FSNConnection.h"


@interface DatabaseManager ()

@end

@implementation DatabaseManager

// start a connection and return the data to the delegate
- (void)getActivities:(unsigned int)time currentLocation:(CLLocation*)geo wantOnline:(unsigned int)online wantOutside:(unsigned int)outside
{
    FSNConnection* connection = [FSNConnection withUrl:[NSURL URLWithString:@"http://chipmunk.io/api/items/query"] method:FSNRequestMethodGET headers:[NSDictionary dictionary] parameters:[NSDictionary dictionaryWithObjectsAndKeys:@(time),@"minutes",@"-79.32,103.81",@"geo",@(online),@"online",@(outside),@"outside", nil]
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
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } progressBlock:^(FSNConnection *c) {
        
    }];
    
    [connection start];
}


@end
