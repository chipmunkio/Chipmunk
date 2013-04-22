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

@interface ActivityTableViewController () 

@end

@implementation ActivityTableViewController

@synthesize tableView     = _tableView;
@synthesize dataSource    = _dataSource;
@synthesize dbManager     = _dbManager;
@synthesize imgDataSource = _imgDataSource;
@synthesize imagesDownloaded = _imagesDownloaded;

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
    atvc.imagesDownloaded = 0;
    // as soon as the table is created begin loading the data
    [atvc.dbManager getActivities:mins currentLocation:geo wantOnline:online wantOutside:outside];
    return atvc;    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupUI];
	// Do any additional setup after loading the view.
}

- (void)setupUI {
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setupTableView];
    
    UINavigationBar* navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navbar setTintColor:[ChipmunkUtils chipmunkColor]];
    [navbar setBackgroundColor:[UIColor blackColor]];
    [ChipmunkUtils roundView:navbar withCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) andRadius:10.0];
    [self.view addSubview:navbar];
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 38, 38)];
    back.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backbutton.png"]];
    [self.view addSubview:back];
    [back addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
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
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
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

- (void)receivedActivities:(NSArray *)activities {
    // should notify the user that there are new objects to look at if they are not already at the end?
    NSLog(@"GOT THAT DATAAAAAAAAAAAAAAAA!!!!!!!!!!!!!!!");
    unsigned int offset = self.dataSource.count;
    [self.dataSource addObjectsFromArray:activities];
    [self downloadContentFromOffset:offset];
    [self.tableView reloadData];
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
    ActivitySelectionController* selection = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"selectionController"];
    
    // give the view the item
    NSMutableDictionary* item = [self.dataSource[indexPath.row] mutableCopy];
    item[@"imageData"] = self.imgDataSource[indexPath.row];
    selection.item = item;
    [self.navigationController pushViewController:selection animated:YES];
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




@end
