//
//  ActivityViewController.m
//  Chipmunk
//
//  Created by Gabe Jacobs on 3/14/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "ChipmunkUtils.h"
#import "ActivityCell.h"
#import "DatabaseManager.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "ActivityViewController.h"

@interface ActivityViewController () <DatabaseManagerDelegate>

@property (nonatomic, strong) DatabaseManager* dbManager;

@end

@implementation ActivityViewController

@synthesize dataSource = _dataSource;
@synthesize minutes;
@synthesize outside;
@synthesize online;


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
    NSLog(@"activity view controller did load");
    self.view.backgroundColor = [ChipmunkUtils tableColor];
    
    self.dbManager.delegate = self;
    NSLog(@"minutes: %i", self.minutes);
    NSLog(@"online: %i", self.online);
    NSLog(@"outside: %i", self.outside);

    [self.dbManager getActivities:self.minutes currentLocation:nil wantOnline:self.online wantOutside:self.outside];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//*************************************************************
//*************************************************************
#pragma mark - Connection stuff
//*************************************************************
//*************************************************************

- (void)recievedActivities:(NSArray *)activities
{
    NSMutableArray* allActivities = [NSMutableArray arrayWithArray:self.dataSource];
    [allActivities addObjectsFromArray:activities];
    self.dataSource = [NSArray arrayWithArray:allActivities];
    NSLog(@"activities: %@", self.dataSource);
}



//*************************************************************
//*************************************************************
#pragma mark - Getters/Setters
//*************************************************************
//*************************************************************

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    //[self.table reloadData];
}

- (DatabaseManager*)dbManager
{
    if(!_dbManager) {
        _dbManager = [[DatabaseManager alloc] init];
    }
    return _dbManager;
}

- (IBAction)popView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadWebView:(int)index {
    
}

@end

