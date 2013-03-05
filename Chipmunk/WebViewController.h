//
//  WebViewController.h
//  Chipmunk
//
//  Created by Gabe Jacobs on 3/4/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic) NSString* urlStr;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backtoActivies:(id)sender;

@end
