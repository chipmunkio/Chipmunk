//
//  ArticleViewController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ItemViewController.h"

@interface ArticleViewController : ItemViewController <UIWebViewDelegate>


+ (ArticleViewController*)controllerItem:(NSDictionary*)item;

@end
