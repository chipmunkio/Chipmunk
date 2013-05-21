//
//  ItemViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ItemViewController.h"
#import "ArticleViewController.h"


@interface ItemViewController ()

@end

@implementation ItemViewController

@synthesize item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (ItemViewController*)item:(NSDictionary*)item {
    ItemViewController* ivc;
    NSString* type = item[@"item_type"];
    if([type isEqualToString:@"Link"]) {
        ivc = [ArticleViewController controllerItem:item];
    } // then add an if statement for every new type of item we need
    
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 38, 38)];
    back.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backbutton.png"]];
    [back addTarget:ivc.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* share = [[UIButton alloc] initWithFrame:CGRectMake([ChipmunkUtils screenWidth] - 45, 5, 40, 40)];
    share.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share"]];
    [share addTarget:ivc action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    [ivc.view addSubview:back];
    [ivc.view addSubview:share]; // maybe add this button to every class so they can share their data correctly
    
    return ivc;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*********************************************************
//*********************************************************
#pragma mark - Subclass Responsibility
//*********************************************************
//*********************************************************

// show options for sharing this item
- (void)share {
    assert(false);
}

// loads the data -> may be called before the view has been loaded
// if needs the view call [self loadView] in this function
- (void)loadData {
    assert(false);
}








@end
