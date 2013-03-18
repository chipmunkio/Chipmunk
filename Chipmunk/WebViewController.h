//
//  WebViewController.h
//  Chipmunk
//
//  Created by Gabe Jacobs on 3/4/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic) NSString* urlStr;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backtoActivies:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *barTitle;
- (IBAction)shareLink:(id)sender;
@property (nonatomic) int startedLoading;


@end
