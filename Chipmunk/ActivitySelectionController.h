//
//  ActivitySelectionController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 3/20/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "DatabaseManager.h"
#import "SwipableImageView.h"
#import <UIKit/UIKit.h>

@interface ActivitySelectionController : UIViewController <UIWebViewDelegate, DatabaseManagerDelegate, SwipingImageDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextActivityButton;
@property (strong, nonatomic) IBOutlet SwipableImageView *imageView;
// this will have to change once venues are an option as venues will not always have webcontent
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) DatabaseManager* dbManager;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (weak, nonatomic) IBOutlet UIButton *bottomBar;
@property (strong, nonatomic) NSMutableArray* imgDataSource;
@property (nonatomic) int barUp;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) int mins;
@property (nonatomic) int hours;
@property (nonatomic) int seconds;
@property (weak, nonatomic) IBOutlet UIImageView *timerImage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;




- (void)getActivites:(unsigned int)totalMins;

@end
