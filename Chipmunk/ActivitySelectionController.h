//
//  ActivitySelectionController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 3/20/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "DatabaseManager.h"
#import <UIKit/UIKit.h>

@interface ActivitySelectionController : UIViewController <UIWebViewDelegate, DatabaseManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextActivityButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// this will have to change once venues are an option as venues will not always have webcontent
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) DatabaseManager* dbManager;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) NSMutableArray* imgDataSource;

- (void)getActivites:(unsigned int)mins; // should add more parameters for in vs outside

@end
