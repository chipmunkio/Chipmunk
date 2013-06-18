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
#import <FacebookSDK/FacebookSDK.h>
#import "ScrollableWebView.h"


// the width is that of the screen
const int ASC_IMG_HEIGHT = 220;


@interface ActivitySelectionController () <UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL contentIsShown;

@end


@implementation ActivitySelectionController

@synthesize imageView = _imageView;
@synthesize webView = _webView;
@synthesize dbManager = _dbManager;
@synthesize dataSource = _dataSource;
@synthesize item = _item;
@synthesize scrollView = _scrollView;

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
    [self setupUI];
    [self loadData];
}

// should add the image and webview to the view
// later on also add the navigation bar stuff here as well
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    // the image is always put behind it so the webview can slide on top of it
//    [self addSlidingWebView];
    [self addImageView];
    [self addScrollView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.progressBarGrey.frame = CGRectMake(0, 0, [ChipmunkUtils screenWidth], 6);
    self.progressBarBlue.frame = CGRectMake(0, 0, 0, 6);
    [self.webView addSubview:self.progressBarGrey];
    [self.webView addSubview:self.progressBarBlue];
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 38, 38)];
    back.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backbutton.png"]];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

// right now just save to Pocket,
// should show options for how to share/save
- (void)share {
    [ChipmunkUtils saveURLToPocket:self.item[@"url"]];
}

// added sliding to name because addWebView is already a function
- (void)addSlidingWebView {
    // 64 is the size of the status bar and the navigation bar
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 220, [ChipmunkUtils screenWidth], [ChipmunkUtils screenHeight] - 64)];
    [self.view addSubview:self.webView];
    [self addIndicatorToWebView];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.delegate = self;
    
    UISwipeGestureRecognizer* gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWebView:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.webView addGestureRecognizer:gesture];
    
}

- (void)addScrollView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ASC_IMG_HEIGHT, [ChipmunkUtils screenWidth], [ChipmunkUtils screenHeight] - 64)];
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.scrollEnabled =NO;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.bounces = NO;
    
    // create the progress indicator here
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [ChipmunkUtils screenWidth], [ChipmunkUtils screenHeight])];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake([ChipmunkUtils screenWidth], [ChipmunkUtils screenHeight] - 44 + ASC_IMG_HEIGHT);
    [self.scrollView addSubview:self.webView];
    self.scrollView.bounces = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)addImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ChipmunkUtils screenWidth], ASC_IMG_HEIGHT)];
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    if(self.item) {
        if(self.item && ![self.item[@"imageData"] isMemberOfClass:[NSNull class]]) {
            UIImage *unBlurred = [[UIImage imageWithData:self.item[@"imageData"]] normalize];
            UIImage *blurred = [unBlurred stackBlur:9.0];
            self.imageView.image = blurred;
        }
    }
}

// add things here when there are more than just articles
- (void)loadData {
    if([self.item[@"item_type"] isEqualToString:@"Link"] && self.item[@"url"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.item[@"url"]] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:300]];
    } else {
        // do stuff for the venue
    }
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


- (IBAction)toggleFullActivity:(id)sender {
    // move the [web,map] view up so it covers the whole screen
    // DELME - this is hardcoded for the iPhone 5, MAKE DYNAMIC
    // also change the height when it is not full
    
    CGPoint offset = self.webView.scrollView.contentOffset;
    [self.webView.scrollView setContentOffset:offset animated:NO];
    
    CGRect newProgressBlueFrame = CGRectMake(0, 0, (self.progressBarBlue.bounds.size.width), 6);
    CGFloat imgDeltaY = 80;
    
    self.contentIsShown = !self.contentIsShown;
    [UIView animateWithDuration:0.4 animations:^{
        self.progressBarBlue.frame = newProgressBlueFrame;
        self.imageView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y + imgDeltaY);
    }];
    
    self.webView.scrollView.scrollEnabled = self.contentIsShown;
}


- (void)getActivites:(unsigned int)totalMins {
    self.hours = totalMins / 60;
    self.mins  = totalMins - (self.hours * 60);
    [self.dbManager getActivities:totalMins currentLocation:[ChipmunkUtils getCurrentLocation] wantOnline:0 wantOutside:0];
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
    // the only time an alert shows up is when there were no items returned for the query
    [self.navigationController popViewControllerAnimated:YES];
}


//*********************************************************
//*********************************************************
#pragma mark - ScrollView Delegate
//*********************************************************
//*********************************************************


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView == self.webView.scrollView) {
        // Get some details about the view
        CGSize size = [scrollView frame].size;
        CGPoint offset = [scrollView contentOffset];
        CGSize contentSize = [scrollView contentSize];
        CGFloat blueWidth = ((offset.y)/(contentSize.height - size.height))*320;
        self.progressBarBlue.frame = CGRectMake(0, 0, blueWidth, 6);
        NSLog(@"OFFSET: %f", scrollView.contentOffset.y);
        if(self.webView.scrollView.contentOffset.y <= 0) {
            NSLog(@"ScrollView is at the bottom");
            
        }
    } else {
        NSLog(@"Main OFFSET: %f", scrollView.contentOffset.y);
        NSLog(@"HEIGHT: %f", scrollView.frame.size.height);
        // at the bottom
        BOOL webScrollEnabled = (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height);
        self.webView.scrollView.scrollEnabled = webScrollEnabled;
        self.webView.userInteractionEnabled   = webScrollEnabled;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView == self.scrollView && !decelerate) {
        
    }
    
    
}

@end
