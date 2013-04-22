//
//  ActivityTableViewCell.m
//  Chipmunk
//
//  Created by Amadou Crookes on 4/12/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "ChipmunkUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityTableViewCell

@synthesize imageview = _imageview;
@synthesize label = _label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// will create a cell for the given item and will rotate it so it shows it the table correctly
+ (ActivityTableViewCell*)activityCell {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    CGRect frame = CGRectMake(0, 0, 320, screenHeight - 44);
    ActivityTableViewCell* atvc = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    // check the item type. if involves geo add a map instead of an image
    int deltaX = 20;
    int deltaY = 80;
    int imgX = deltaX;
    int imgY = (3*deltaY)/4;
    int imgWidth = screenWidth - (2 * deltaX);
    int imgHeight = screenHeight - (2 * deltaY) - 20;
    UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    [ChipmunkUtils addShadowToView:shadowView];
    atvc.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
    
    atvc.transform = CGAffineTransformMakeRotation(M_PI_2);
    atvc.frame = frame;
    
    atvc.imageview.backgroundColor = [UIColor blackColor];
    
    atvc.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // need to add label fonts and whatnot to make the text look good
    // should edit code in the below function to change the frame of
    // the label so it sits at the bottom
    atvc.label = [[UILabel alloc] initWithFrame:atvc.imageview.frame];
    [atvc.label setBackgroundColor:[UIColor clearColor]];
    atvc.label.center = CGPointMake(atvc.imageview.frame.size.width/2, (atvc.label.frame.size.height)/2);
    atvc.label.numberOfLines = 0;
    
    atvc.label.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30];
    atvc.label.textColor = [UIColor whiteColor];
    atvc.label.shadowColor = [UIColor blackColor];
    atvc.label.shadowOffset = CGSizeMake(0.0, 1.0);
    atvc.label.layer.shouldRasterize = YES;
    

    atvc.label.textAlignment = NSTextAlignmentLeft;
    
    [shadowView addSubview:atvc.imageview];
    [atvc.imageview addSubview:atvc.label];
    [atvc addSubview:shadowView];


    [ChipmunkUtils roundView:atvc.imageview withCorners:UIRectCornerAllCorners andRadius:20.0];
//    [ChipmunkUtils addShadowToView:atvc.imageview];
    
    return atvc;
}

- (void)addTextToCell:(NSString*)text {
    self.label.text = text;

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














