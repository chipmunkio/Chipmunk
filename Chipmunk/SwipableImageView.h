//
//  SwipableImageView.h
//  Chipmunk
//
//  Created by Amadou Crookes on 4/2/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SwipingImageDelegate <NSObject>

// should create another swipeview to display if doesnt already exist
- (void)animateSwipeImageOffScreen; 

@end

@interface SwipableImageView : UIImageView

@property (nonatomic, strong) id <SwipingImageDelegate> delegate;

@end
