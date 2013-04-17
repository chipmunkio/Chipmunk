//
//  ActivityTableViewCell.h
//  Chipmunk
//
//  Created by Amadou Crookes on 4/12/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell


@property (nonatomic,strong) UIImageView* imageview;
@property (nonatomic,strong) UILabel* label;


+ (ActivityTableViewCell*)activityCell;
- (void)addTextToCell:(NSString*)text;
    
@end
