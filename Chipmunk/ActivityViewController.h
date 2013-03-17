//
//  AcvtivityViewController.h
//  Chipmunk
//
//  Created by Gabe Jacobs on 3/14/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController

@property (nonatomic, strong) NSArray* dataSource;
@property (nonatomic) unsigned int minutes;
@property (nonatomic) unsigned int online;
@property (nonatomic) unsigned int outside;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
