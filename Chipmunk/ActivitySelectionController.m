//
//  ActivitySelectionController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 3/20/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ActivitySelectionController.h"
#import "ChipmunkUtils.h"


@interface ActivitySelectionController ()

@property (nonatomic) BOOL contentIsShown;
@property (weak, nonatomic) IBOutlet UIButton *nextArrow;

@end


@implementation ActivitySelectionController

@synthesize dbManager = _dbManager;
@synthesize dataSource = _dataSource;

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
    self.seconds = 60;
    NSString *time = [NSString stringWithFormat:@"%i:%i", self.hours, self.mins];
    if(self.mins == 0)
    {
        time = [NSString stringWithFormat:@"%i:%i0", self.hours, self.mins];
    }
    else if(self.mins < 10 && self.mins > 0)
    {
        time = [NSString stringWithFormat:@"%i:0%i", self.hours, self.mins];
    }
    [self.timerLabel setText:[NSString stringWithFormat:@"%@", time]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target:self selector:@selector(updateTimer) userInfo:nil repeats: YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateTimerImage) userInfo:nil repeats: YES];

    [self addIndicatorToWebView];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.scrollEnabled = NO;
	// Do any additional setup after loading the view.
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
    CGFloat newAlpha = 0;
    if(self.contentIsShown) {
        newAlpha = 1;
        [self.bottomBar setImage:[UIImage imageNamed:@"2ndpagebottombarup.png"] forState:UIControlStateNormal];
        newFrame = CGRectMake(0, 262, 320, viewHeight);
    } else {
        newAlpha = 0;
        [self.bottomBar setImage:[UIImage imageNamed:@"2ndpagebottombar.png"] forState:UIControlStateNormal];
        newFrame = CGRectMake(0, 44, 320, viewHeight);
    }
    self.contentIsShown = !self.contentIsShown;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.webView.frame = newFrame;
        self.nextArrow.alpha = newAlpha;
    }];
    
    self.webView.scrollView.scrollEnabled = self.contentIsShown;
}


- (void)getActivites:(unsigned int)totalMins
{
    self.hours = totalMins/60;
    self.mins  = totalMins - (self.hours * 60);
    [self.dbManager getActivities:totalMins currentLocation:[ChipmunkUtils getCurrentLocation] wantOnline:0 wantOutside:0];
}

- (void)recievedActivities:(NSArray *)activities {
    self.dataSource = [activities mutableCopy];
    if(self.dataSource.count == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"Nothing was found..." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        return;
        [self.navigationController popViewControllerAnimated:YES];
    }
    for(id thing in self.dataSource) {
        [self.imgDataSource addObject:[NSNull null]];
    }
    
    // begin loading the images and the web content to fill the data
    [self downloadContentForItems];
    [self updateUI];
}

- (void)downloadContentForItems {
    dispatch_queue_t queue = dispatch_queue_create("download.content.spare", nil);
    dispatch_async(queue, ^{
        for(int i = 0; i < self.dataSource.count; i++) {
            NSDictionary* item = self.dataSource[i];
            NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item[@"img_url"]]];
            
            self.imgDataSource[i] = imgData;
            if(i == 0) {
                [self updateUI];
            }
        }
    });
    
    
}


- (DatabaseManager*)dbManager {
    if(!_dbManager) {
        _dbManager = [[DatabaseManager alloc] init];
        _dbManager.delegate = self;
    }
    return _dbManager;
}

- (NSMutableArray*)imgDataSource {
    if(!_imgDataSource) {
        _imgDataSource = [[NSMutableArray alloc] init];
    }
    return _imgDataSource;
}

    // take whatever is at the front and display it
    - (void)updateUI {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.dataSource count] > 0) {
                if(self.imgDataSource.count > 0 && self.imgDataSource[0] != [NSNull null]) {
                    //[av stopAnimating];
                    self.imageView.image = [UIImage imageWithData:self.imgDataSource[0]];
            }
        }
    });
    if(self.dataSource.count > 0) {
        NSDictionary* item = self.dataSource[0];
        [self.webView stopLoading];
        if([item[@"item_type"] isEqualToString:@"Link"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item[@"url"]] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:300]];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateTimer{
    
    self.mins--;
    self.seconds = 60;
    NSString *time = [NSString stringWithFormat:@"%i:%i", self.hours, self.mins];
    if(self.mins < 0 && self.hours > 0)
    {
        self.hours--;
        self.mins = 59;
    }
    else if(self.mins == 0)
    {
        time = [NSString stringWithFormat:@"%i:%i0", self.hours, self.mins];
    }
    else if(self.mins < 10 && self.mins > 0)
    {
        time = [NSString stringWithFormat:@"%i:0%i", self.hours, self.mins];
    }
    else if( self.mins == 0 && self.hours == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Free time spent!" message:@"You have spent all your free time! We hope you used it wisely!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [self.timer invalidate];
        self.timer = nil;
    }
    else{
        time = [NSString stringWithFormat:@"%i:%i", self.hours, self.mins];
    }
    [self.timerLabel setText:[NSString stringWithFormat:@"%@", time]];


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


@end
