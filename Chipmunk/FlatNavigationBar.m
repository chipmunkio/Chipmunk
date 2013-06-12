//
//  FlatNavigationBar.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "FlatNavigationBar.h"

@implementation FlatNavigationBar

@synthesize color = _color;

- (void)drawRect:(CGRect)rect {
    if (!self.color)
        self.color = [UIColor blackColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.color set];
    CGContextFillRect(context, rect);
    self.tintColor = self.color;
}

@end
