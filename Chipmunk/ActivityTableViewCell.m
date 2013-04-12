//
//  ActivityTableViewCell.m
//  Chipmunk
//
//  Created by Amadou Crookes on 4/12/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityTableViewCell

@synthesize imageview = _imageview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// will create a cell for the given item and will rotate it so it shows it the table correctly
+ (ActivityTableViewCell*)activityCell:(NSDictionary*)item {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    CGRect frame = CGRectMake(0, 0, 320, screenHeight);
    ActivityTableViewCell* atvc = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    // check the item type. if involves geo add a map instead of an image
    int deltaX = 20;
    int deltaY = 80;
    atvc.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(deltaX, deltaY, screenWidth - (2 * deltaX), screenHeight - (2 * deltaY) - 20)];//remove 20 for the status bar
    [atvc addSubview:atvc.imageview];
    atvc.transform = CGAffineTransformMakeRotation(M_PI_2);
    atvc.frame = frame;
    
    atvc.imageview.backgroundColor = [UIColor blackColor];
    [ActivityTableViewCell roundImageViewCorners:atvc.imageview];
    
    atvc.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return atvc;
}

+ (void)roundImageViewCorners:(UIImageView*)imageView {
    
    CALayer *capa = imageView.layer;
    
    //Round
    CGRect bounds = capa.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerAllCorners)
                                                         cornerRadii:CGSizeMake(20.0, 20.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end














