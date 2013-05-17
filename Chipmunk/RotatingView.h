//
//  RotatingView.h
//  Chipmunk
//
//  Created by Amadou Crookes on 5/16/13.
//  Copyright (c) 2013 Amadou Crookes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RotatingViewDelegate <NSObject>

- (void)selectedHours:(unsigned int)hours Minutes:(unsigned int)mins;

@end

@interface RotatingView : UIView

@property (nonatomic, strong) id <RotatingViewDelegate> delegate;
@property (nonatomic) float currentAngle;
    
@end
