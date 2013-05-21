//
//  ScrollableWebView.h
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollableWebView : UIWebView
// the distance from the superview's top that this should begin scrolling
@property (nonatomic) int scrollOffset;
// the location that the webview should begin at
// must be greater than the offset
@property (nonatomic) int webViewStartY;

+ (ScrollableWebView*)webViewOffset:(int)offset webStart:(int)start superSize:(CGSize)superSize;
    
@end
