//
//  ItemViewController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController

@property (nonatomic, strong) NSDictionary* item;


+ (ItemViewController*)item:(NSDictionary*)item;

@end
