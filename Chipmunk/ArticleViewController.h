//
//  ArticleViewController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//
const int IMG_HEIGHT = 220;

#import "ItemViewController.h"

@interface ArticleViewController : ItemViewController


+ (ArticleViewController*)controllerItem:(NSDictionary*)item;

@end
