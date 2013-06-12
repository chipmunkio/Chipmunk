//
//  SpareViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "SpareViewController.h"

@interface SpareViewController ()

@end

@implementation SpareViewController

// if all view controllers should have a certain appearance customize that here
// all view controllers should subclass this class
- (void)viewDidLoad {
    [super viewDidLoad];
    [ChipmunkUtils roundView:self.view withCorners:UIRectCornerAllCorners andRadius:5.0f];
}

@end