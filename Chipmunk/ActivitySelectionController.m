//
//  ActivitySelectionController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 3/20/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ActivitySelectionController.h"
#import "ChipmunkUtils.h"
#import <QuartzCore/QuartzCore.h>


@interface ActivitySelectionController () <UIAlertViewDelegate>

@property (nonatomic) BOOL contentIsShown;
@property (weak, nonatomic) IBOutlet UIButton *nextArrow;

@end


@implementation ActivitySelectionController

@synthesize imageView = _imageView;
@synthesize webView = _webView;
@synthesize dbManager = _dbManager;
@synthesize dataSource = _dataSource;
@synthesize item = _item;

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
    self.barUp = 1;
    [self setupUI];
    [self updateUI];
	// Do any additional setup after loading the view.
}

// should add the image and webview to the view
// later on also add the navigation bar stuff here as well
- (void)setupUI {
    // must add webview first
    // the image is always put behind it so the webview can slide on top of it
    [self addSlidingWebView];
    [self addSwipeImageView];
    [self.view insertSubview:self.bottomBar aboveSubview:self.webView];
    [self.view insertSubview:self.progressBarBlue aboveSubview:self.webView];
    [self.view insertSubview:self.progressBarGrey aboveSubview:self.webView];
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 38, 38)];
    back.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backbutton.png"]];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

// added sliding to name because addWebView is already a function
- (void)addSlidingWebView {
    
    // the numbers for the frame are the same number as when we used the storyboard
    // DELME -- for 3.5 inch screen should change this
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 220, 320, 504)];
    [self.view addSubview:self.webView];
    [self addIndicatorToWebView];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.scrollEnabled = NO;
    
    UISwipeGestureRecognizer* gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWebView:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.webView addGestureRecognizer:gesture];
    
}

- (void)addSwipeImageViewWithFrame:(CGRect)frame {
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    [self.view insertSubview:self.imageView belowSubview:self.webView];
    self.imageView.userInteractionEnabled = YES;

}

- (void)addSwipeImageView {
    [self addSwipeImageViewWithFrame:CGRectMake(0, 0/*navbar height*/, 320, 220)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Delgation functions

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // show activity indicator
    UIActivityIndicatorView* av = (UIActivityIndicatorView*)[self.webView viewWithTag:1];
    [av startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIActivityIndicatorView* av = (UIActivityIndicatorView*)[self.webView viewWithTag:1];
    [av stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIActivityIndicatorView* av = (UIActivityIndicatorView*)[self.webView viewWithTag:1];
    [av stopAnimating];
    //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was an error loading the website" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
}


// IBActions
- (IBAction)getNextActivity:(id)sender {
    // just have this here to check that the current location updates and is correct
    //NSLog(@"Current Location: %@", [ChipmunkUtils getCurrentLocation]);
    if(self.dataSource != nil && self.dataSource.count > 0) {
        if(self.contentIsShown) {
            [self toggleFullActivity:nil];
        }
        [self.dataSource removeObjectAtIndex:0];
        [self.imgDataSource removeObjectAtIndex:0];
        // make the webview blank again while it loads the next article
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60]];
        [self updateUI];
    }
}


- (IBAction)toggleFullActivity:(id)sender {
    // move the [web,map] view up so it covers the whole screen
    // DELME - this is hardcoded for the iPhone 5, MAKE DYNAMIC
    // also change the height when it is not full
    
    CGFloat viewHeight = 504;
    CGRect newFrame;
    CGRect newProgressGreyFrame;
    CGRect newProgressBlueFrame;

    CGFloat newAlpha = 0;
    if(self.contentIsShown) {
        newAlpha = 1;
        [self.bottomBar setImage:[UIImage imageNamed:@"2ndpagebottombarup.png"] forState:UIControlStateNormal];
        newFrame = CGRectMake(0, 220, 320, viewHeight);
        newProgressGreyFrame = CGRectMake(0, 220, 320, 6);
        newProgressBlueFrame = CGRectMake(0, 220, (self.progressBarBlue.bounds.size.width), 6);

    } else {
        newAlpha = 0;
        [self.bottomBar setImage:[UIImage imageNamed:@"2ndpagebottombar.png"] forState:UIControlStateNormal];
        newFrame = CGRectMake(0, 44, 320, viewHeight);
        newProgressGreyFrame = CGRectMake(0, 44, 320, 6);
        newProgressBlueFrame = CGRectMake(0, 44, (self.progressBarBlue.bounds.size.width), 6);


    }
    self.contentIsShown = !self.contentIsShown;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.webView.frame = newFrame;
        self.progressBarGrey.frame = newProgressGreyFrame;
        self.progressBarBlue.frame = newProgressBlueFrame;

        self.nextArrow.alpha = newAlpha;
    }];
    
    self.webView.scrollView.scrollEnabled = self.contentIsShown;
}

// swipe image delegate functions

- (void)animateSwipeImageOffScreen {
    
    int screenWidth = 320;
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.center = CGPointMake(-(screenWidth/2), self.imageView.center.y);
    } completion:^(BOOL finished) {
        [self addSwipeImageViewWithFrame:CGRectMake(150, 144, 20, 20)];
        [self getNextActivity:nil];
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.frame = CGRectMake(0, 0/*navbar height*/, 320, 220);
        }];
    }];
}


- (void)getActivites:(unsigned int)totalMins
{
    self.hours = totalMins / 60;
    self.mins  = totalMins - (self.hours * 60);
    [self.dbManager getActivities:totalMins currentLocation:[ChipmunkUtils getCurrentLocation] wantOnline:0 wantOutside:0];
}

- (void)receivedActivities:(NSArray *)activities {
    self.dataSource = [activities mutableCopy];
    if(self.dataSource.count == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"Nothing was found..." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
    for(id thing in self.dataSource) {
        [self.imgDataSource addObject:[NSNull null]];
    }
    
    // begin loading the images and the web content to fill the data
    [self updateUI];
}



    // take whatever is at the front and display it
- (void)updateUI {
    if(self.item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.item && ![self.item[@"imageData"] isMemberOfClass:[NSNull class]])
                self.imageView.image = [[UIImage imageWithData:self.item[@"imageData"]] stackBlur:7.0];
        });
        [self.webView stopLoading];
        if([self.item[@"item_type"] isEqualToString:@"Link"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.item[@"url"]] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:300]];
        } else {
            // do stuff for the venue
        }
    }
}


- (void)addIndicatorToWebView {
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [av setColor:[UIColor grayColor]];
    av.frame = CGRectMake(145, 100, 40.0, 40.0);
    av.tag  = 1;
    [self.webView addSubview:av];
    //[av startAnimating];
}

- (IBAction)swipeWebView:(id)sender {
    if(!self.contentIsShown)
        [self toggleFullActivity:nil];
}

- (IBAction)back:(id)sender {
    [self.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)updateTimerImage{
    
    self.seconds--;
    if(self.seconds >= 55 && self.seconds < 60)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer.png"]];
        
    }
    if(self.seconds >= 50 && self.seconds < 55)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer1.png"]];

    }
    else if(self.seconds >= 45 && self.seconds < 50)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer2.png"]];
        
    }
    else if(self.seconds >= 40 && self.seconds < 45)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer3.png"]];
        
    }
    else if(self.seconds >= 35 && self.seconds < 40)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer4.png"]];
        
    }
    else if(self.seconds >= 30 && self.seconds < 35)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer5.png"]];
        
    }
    else if(self.seconds >= 25 && self.seconds < 30)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer6.png"]];
        
    }
    else if(self.seconds >= 20 && self.seconds < 25)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer7.png"]];
        
    }
    else if(self.seconds >= 15 && self.seconds < 20)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer8.png"]];
        
    }
    else if(self.seconds >= 10 && self.seconds < 15)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer9.png"]];
        
    }
    else if(self.seconds >= 5 && self.seconds < 10)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer10.png"]];
        
    }
    else if(self.seconds >= 0 && self.seconds < 5)
    {
        [self.timerImage setImage:[UIImage imageNamed:@"timer11.png"]];
    }

}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get some details about the view
    CGSize size = [scrollView frame].size;
    CGPoint offset = [scrollView contentOffset];
    CGSize contentSize = [scrollView contentSize];
    CGFloat blueWidth = ((offset.y + size.height)/(contentSize.height))*320;
    self.progressBarBlue.frame = CGRectMake(0, 44, blueWidth, 6);


}

@end
