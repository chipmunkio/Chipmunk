//
//  ActivityTableViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 4/12/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "ActivityTableViewCell.h"
#import "DatabaseManager.h"
#import "ActivitySelectionController.h"
#import "ChipmunkUtils.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ItemViewController.h"
#import "FlatNavigationBar.h"

const unsigned int MAX_LOAD_ATTEMPTS = 6; // if they try to load x times stop from trying to get more

@interface ActivityTableViewController ()

@property (nonatomic) unsigned int minutes;
@property (nonatomic) unsigned int online;
@property (nonatomic) unsigned int outside;
@property (nonatomic, strong) NSDate* initialLoad;
@property (nonatomic) unsigned int loadAttempts; //the times trying to load more data from the server
@property (nonatomic) BOOL isLoading;

@end

@implementation ActivityTableViewController

@synthesize tableView     = _tableView;
@synthesize dataSource    = _dataSource;
@synthesize dbManager     = _dbManager;
@synthesize imgDataSource = _imgDataSource;
@synthesize imagesDownloaded = _imagesDownloaded;
@synthesize downloadedItems  = _downloadedItems;
@synthesize minutes = _minutes;
@synthesize online  = _online;
@synthesize outside = _outside;
@synthesize initialLoad = _initialLoad;
@synthesize isLoading = _isLoading;
@synthesize loadAttempts = _loadAttempts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (ActivityTableViewController*)activityTableWithMinutes:(unsigned int)mins
                                         currentLocation:(CLLocation*)geo
                                              wantOnline:(unsigned int)online
                                             wantOutside:(unsigned int)outside {
    
    ActivityTableViewController* atvc = [[ActivityTableViewController alloc] init];
    atvc.minutes = mins;
    atvc.outside = outside;
    atvc.online  = online;
    atvc.initialLoad = [NSDate date];
    atvc.imagesDownloaded = 0;
    atvc.loadAttempts = 0;
    // as soon as the table is created begin loading the data
    [atvc loadData];
    
    return atvc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
	// Do any additional setup after loading the view.
}

- (void)setupUI {
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setupTableView];
    
    FlatNavigationBar* navbar = [[FlatNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [ChipmunkUtils screenWidth], 44)];
    navbar.color = [ChipmunkUtils chipmunkColor];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:navbar.frame];
    indicator.tag = 7;
    [navbar addSubview:indicator];
    [indicator startAnimating];
    
    //[ChipmunkUtils roundView:navbar withCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) andRadius:10.0];
    [self.view addSubview:navbar];
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 38, 38)];
    back.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backbutton.png"]];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)goBack {
    [ChipmunkUtils startUpdatingLocation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)setupTableView {
    self.tableView.hidden = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    CGRect frame = CGRectMake(0, 44, 320, 524);
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.frame = frame;
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    //[ChipmunkUtils roundView:self.view withCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) andRadius:10];
    UIView* gradientView = [[UIView alloc] initWithFrame:self.tableView.frame];
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.frame;
    UIColor* clearBlack = [UIColor colorWithWhite:0 alpha:0.4];
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)clearBlack.CGColor];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [self.view insertSubview:gradientView belowSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator   = NO;
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//*********************************************************
//*********************************************************
#pragma mark - Database Stuff
//*********************************************************
//*********************************************************

// really shouldnt be called activities 
- (void)receivedActivities:(NSArray *)activities {
    unsigned int newActivities = 0;
    // should notify the user that there are new objects to look at if they are not already at the end?
    unsigned int offset = self.dataSource.count;
    for(NSDictionary* item in activities) {
        if(![self.downloadedItems containsObject:item[@"id"]]) {
            [self.dataSource addObject:item];
            [self.downloadedItems addObject:item[@"id"]];
            newActivities += 1;
        }
    }
    if(newActivities == 0) {
        self.loadAttempts += 1;
        if(self.loadAttempts == MAX_LOAD_ATTEMPTS - 1 && self.minutes > 1) {
            NSLog(@"changing minutes YOLO");
            self.minutes -= 1;
        }
    } else {
        self.loadAttempts = 0;
    }
    [self downloadContentFromOffset:offset];
    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[self.view viewWithTag:7];
    [indicator stopAnimating];
    [self.tableView reloadData];
}

- (void)loadData {
    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[self.view viewWithTag:7];
    [indicator startAnimating];
    int mins = (int)(self.minutes + [self.initialLoad timeIntervalSinceNow]/60);//time interval returns a negative time (Seconds)
    if(mins < 0) mins = 0;
    NSLog(@"MINS: %i", mins);
    [self.dbManager getActivities:mins
                  currentLocation:[ChipmunkUtils getCurrentLocation]
                       wantOnline:self.online
                      wantOutside:self.outside];
}

// downloads the other content needed for the cell such as image text etc....
- (void)downloadContentFromOffset:(unsigned int)offset {
    
    // fill the array with null so that if an image hasnt been loaded yet we can show
    // a default pic by looking for this value
    for(int i = offset; i < self.dataSource.count; i++) {
        [self.imgDataSource addObject:[NSNull null]];
    }
    int size = self.dataSource.count;
    
    dispatch_queue_t queue = dispatch_queue_create("download.content.spare", nil);
    dispatch_async(queue, ^{
        BOOL isRetina = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRetina"];
        NSString* imgType = isRetina ? @"retina" : @"regular";
        for(int i = offset; i < size; i++) {
            NSDictionary* item = self.dataSource[i];
            NSData* imgData;
            if([item[@"image"] isMemberOfClass:[NSNull class]]) {
                imgData = nil;
            } else {
                imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item[@"image"][imgType]]];
            }
            if(imgData) {
                self.imgDataSource[i] = imgData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            self.imagesDownloaded++;
        }
    });
}



//*********************************************************
//*********************************************************
#pragma mark - Table Delegate/DataSource
//*********************************************************
//*********************************************************

// use this to reload any part of the UI

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // give the view the item
    NSMutableDictionary* item = [self.dataSource[indexPath.row] mutableCopy];
    item[@"imageData"] = self.imgDataSource[indexPath.row];
    ItemViewController* ivc = [ItemViewController item:item];
    [self.navigationController pushViewController:ivc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // should create a custom cellview
    ActivityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if(cell == nil) {
        cell = [ActivityTableViewCell activityCell];
    }
    UIImage* image;
    if(self.imagesDownloaded < indexPath.row + 1) {
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:cell.imageview.frame];
        indicator.tag = 9;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [cell.imageview addSubview:indicator];
        [indicator startAnimating];
    } else {
        UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[cell viewWithTag:9];
        [indicator stopAnimating];
    }
    if(![self.imgDataSource[indexPath.row] isMemberOfClass:[NSNull class]]) {
        image = [UIImage imageWithData:self.imgDataSource[indexPath.row]];
    } else {
        image = nil;
    }
    cell.imageview.image = image;
    [cell addTextToCell:self.dataSource[indexPath.row][@"name"]];
   
    if(indexPath.row == self.dataSource.count - 1 && self.loadAttempts <= MAX_LOAD_ATTEMPTS) {
        NSLog(@"GETTING MORE------------------------");
        [self loadData];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UIScreen mainScreen] bounds].size.width;
}




//*********************************************************
//*********************************************************
#pragma mark - Setters & Getters
//*********************************************************
//*********************************************************

- (NSMutableArray*)dataSource {
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray*)imgDataSource {
    if(!_imgDataSource) {
        _imgDataSource = [NSMutableArray array];
    }
    return _imgDataSource;
}


- (DatabaseManager*)dbManager {
    
    if(!_dbManager) {
        _dbManager = [[DatabaseManager alloc] init];
        _dbManager.delegate = self;
    }
    return _dbManager;
}

- (NSMutableSet*)downloadedItems {
    if(!_downloadedItems) {
        _downloadedItems = [NSMutableSet set];
    }
    return _downloadedItems;
}



@end
