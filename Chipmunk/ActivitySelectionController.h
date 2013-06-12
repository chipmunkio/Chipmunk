//
//  ActivitySelectionController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 3/20/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "DatabaseManager.h"
#import "UIImage+StackBlur.h"
#import "UIImage+Gaussian.h"

#import <UIKit/UIKit.h>

@interface ActivitySelectionController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextActivityButton;
@property (strong, nonatomic) UIImageView *imageView;
// this will have to change once venues are an option as venues will not always have webcontent
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIScrollView* scrollView;

@property (strong, nonatomic) DatabaseManager* dbManager;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (weak, nonatomic) IBOutlet UIButton *bottomBar;
@property (strong, nonatomic) NSMutableArray* imgDataSource;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) int mins;
@property (nonatomic) int hours;
@property (nonatomic) int seconds;
@property (weak, nonatomic) IBOutlet UIImageView *timerImage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *progressBarGrey;
@property (weak, nonatomic) IBOutlet UIView *progressBarBlue;

@property (nonatomic,strong) NSDictionary* item;



- (void)getActivites:(unsigned int)totalMins;

@end
