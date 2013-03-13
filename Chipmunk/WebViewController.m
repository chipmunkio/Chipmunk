//
//  WebViewController.m
//  Chipmunk
//
//  Created by Gabe Jacobs on 3/4/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "WebViewController.h"
#import "ActivityTableViewController.h"


@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backtoActivies:(id)sender {
    

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // check if internet is available and present the appropriate error message
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    // stop showing that stuff is happening because the page is loaded
}


-( void)webViewDidStartLoad:(UIWebView *)webView {
    // show the user that something is happening
}


@end
