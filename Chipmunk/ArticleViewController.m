//
//  ArticleViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ArticleViewController.h"
#import "ScrollableWebView.h"
#import "UIImage+Gaussian.h"
#import "UIImage+StackBlur.h"

const int AVC_IMG_HEIGHT = 220;

@interface ArticleViewController ()

@property (nonatomic, strong) ScrollableWebView* webView;
@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation ArticleViewController

@synthesize webView = _webView;
@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (ArticleViewController*)controllerItem:(NSDictionary*)item {
    ArticleViewController* vc = [[ArticleViewController alloc] init];
    vc.item = item;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)share {
    [ChipmunkUtils saveURLToPocket:self.item[@"original_url"]];
}

- (void)setupUI {
    [self addImageView];
    //define 64 somewhere
    self.webView = [ScrollableWebView webViewOffset:60 webStart:AVC_IMG_HEIGHT superSize:self.view.frame.size];
    self.webView.delegate = self;
    
    UIActivityIndicatorView* av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [av setColor:[UIColor grayColor]];
    av.frame = CGRectMake(145, 100, 40, 40);
    av.tag = 1;
    [self.webView addSubview:av];
    
    
    
    
    [self.view addSubview:self.webView];
}

- (void)addImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ChipmunkUtils screenWidth], AVC_IMG_HEIGHT)];
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

- (void)loadData {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.item[@"url"]]
                                               cachePolicy:NSURLCacheStorageAllowed
                                           timeoutInterval:300]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
