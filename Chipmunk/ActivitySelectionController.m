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
#import "UIImage+Gaussian.h"

@interface ActivitySelectionController () <UIAlertViewDelegate>

@property (nonatomic) BOOL contentIsShown;

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
    [self setupUI];
    [self loadData];
}

// should add the image and webview to the view
// later on also add the navigation bar stuff here as well
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    // the image is always put behind it so the webview can slide on top of it
    [self addSlidingWebView];
    [self addImageView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:self.bottomBar aboveSubview:self.webView];
    [self.view insertSubview:self.progressBarBlue aboveSubview:self.webView];
    [self.view insertSubview:self.progressBarGrey aboveSubview:self.webView];
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 38, 38)];
    back.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backbutton.png"]];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* share = [[UIButton alloc] initWithFrame:CGRectMake([ChipmunkUtils screenWidth] - 45, 5, 40, 40)];
    share.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share"]];
    [self.view addSubview:share];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
}

// right now just save to Pocket,
// should show options for how to share/save
- (void)share {
    [ChipmunkUtils saveURLToPocket:self.item[@"url"]];
}

// added sliding to name because addWebView is already a function
- (void)addSlidingWebView {
    // 64 is the size of the status bar and the navigation bar
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 220, 320, [ChipmunkUtils screenHeight] - 64)];
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

- (void)addImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    [self.view insertSubview:self.imageView belowSubview:self.webView];
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
    
    CGFloat viewHeight = [ChipmunkUtils screenHeight] - 64;
    CGRect newFrame;
    CGRect newProgressGreyFrame;
    CGRect newProgressBlueFrame;
    CGFloat imgDeltaY = 80;
    
    if(self.contentIsShown) { 
        [self.bottomBar setImage:[UIImage imageNamed:@"2ndpagebottombarup.png"] forState:UIControlStateNormal];
        newFrame = CGRectMake(0, 220, 320, viewHeight);
        newProgressGreyFrame = CGRectMake(0, 220, 320, 6);
        newProgressBlueFrame = CGRectMake(0, 220, (self.progressBarBlue.bounds.size.width), 6);

    } else {
        imgDeltaY = -imgDeltaY;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Get some details about the view
    CGSize size = [scrollView frame].size;
    CGPoint offset = [scrollView contentOffset];
    CGSize contentSize = [scrollView contentSize];
    CGFloat blueWidth = ((offset.y + size.height)/(contentSize.height))*320;
    self.progressBarBlue.frame = CGRectMake(0, 44, blueWidth, 6);
}

@end
