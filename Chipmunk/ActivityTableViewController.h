//
//  ActivityTableViewController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 4/12/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface ActivityTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DatabaseManagerDelegate>

@property (nonatomic, strong) UITableView* tableView;
// is mutable so that new items can be added if the user scrolls to the end
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray* imgDataSource;
@property (nonatomic, strong) DatabaseManager* dbManager;
@property (nonatomic) unsigned long imagesDownloaded;


+ (ActivityTableViewController*)activityTableWithMinutes:(unsigned int)mins
                                         currentLocation:(CLLocation*)geo
                                              wantOnline:(unsigned int)online
                                             wantOutside:(unsigned int)outside;
    





@end
