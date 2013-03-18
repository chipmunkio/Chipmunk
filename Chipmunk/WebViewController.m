//
//  WebViewController.m
//  Chipmunk
//
//  Created by Gabe Jacobs on 3/4/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "WebViewController.h"
#import <MessageUI/MessageUI.h>
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
  
    self.startedLoading = 0;
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

    if(self.startedLoading > 3)
    {

        UIActivityIndicatorView *av = (UIActivityIndicatorView *)[self.webView viewWithTag:1];
        [av stopAnimating];
        [av removeFromSuperview];
        
    }
}


-( void)webViewDidStartLoad:(UIWebView *)webView {

    if(self.startedLoading == 0)
    {
        UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [av setColor:[UIColor grayColor]];
        av.frame=CGRectMake(145, 200, 40.0, 40.0);
        av.tag  = 1;
        [self.webView addSubview:av];
        [av startAnimating];
    }
    self.startedLoading++;
}


- (IBAction)shareLink:(id)sender {
    

        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setSubject:@"A link from Spare"];
        NSString *emailURL = self.urlStr;
        [mailView setMessageBody:emailURL isHTML:NO];
    [self.navigationController presentViewController:mailView animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
