//
//  ScrollableWebView.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ScrollableWebView.h"

@interface ScrollableWebView ()

@property (nonatomic) CGPoint touchBegan;
@property (nonatomic, strong) UIView* progressBar;
@end



@implementation ScrollableWebView

@synthesize scrollOffset = _scrollOffset;
@synthesize webViewStartY = _webViewStartY;
@synthesize touchBegan = _touchBegan;
@synthesize progressBar = _progressBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// the offset from the top where the web should actually start scrolling
// the start position (y coordinate) of the webview on the super view. must be greater than offset
// the size of the intended superview
+ (ScrollableWebView*)webViewOffset:(int)offset webStart:(int)start superSize:(CGSize)superSize {
    
    assert(offset < start);
    ScrollableWebView* wv = [[ScrollableWebView alloc] init];
    CGRect frame = CGRectMake(0, start, superSize.width, superSize.height - offset);
    wv.frame = frame;
    wv.scrollOffset = offset;
    wv.webViewStartY = start;
    wv.scrollView.scrollEnabled = NO;
    wv.scrollView.userInteractionEnabled = NO;
    UIView* greyBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ChipmunkUtils screenWidth], 6)];
    greyBar.backgroundColor = [UIColor darkGrayColor];
    wv.progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 6)];
    wv.progressBar.backgroundColor = [ChipmunkUtils chipmunkColor];
    [wv addSubview:greyBar];
    [wv addSubview:wv.progressBar];
    
    return wv;
}

//*********************************************************
//*********************************************************
#pragma mark - Touch Event Handling
//*********************************************************
//*********************************************************

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchBegan = [[touches anyObject] locationInView:self];
    [self.scrollView touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    CGRect newFrame = self.frame;
    int distance = loc.y - self.touchBegan.y;
    newFrame.origin.y += distance;
    
    
    // change this code to look at the new position it WOULD move to
    // not the spot that it is currently at
    if (newFrame.origin.y > self.scrollOffset && self.scrollView.contentOffset.y <= 0) {
        if (newFrame.origin.y <= self.webViewStartY)
            self.frame = newFrame;
        NSLog(@"continue moving the view around");
    } else {
        if(self.frame.origin.y > self.scrollOffset) {
            NSLog(@"it just switched!!!!!");
            newFrame.origin.y = self.scrollOffset;
            self.frame = newFrame;
            distance = 0;
        }
        CGPoint offset = self.scrollView.contentOffset;
        offset.y -= distance;
        offset.y = (offset.y < 0) ? 0 : offset.y;
        offset.y = (offset.y > self.scrollView.contentSize.height - self.frame.size.height) ? self.scrollView.contentSize.height - self.frame.size.height : offset.y;
        self.scrollView.contentOffset = offset;
        self.touchBegan = [[touches anyObject] locationInView:self];
        CGFloat blueWidth = ((offset.y)/(self.scrollView.contentSize.height - self.frame.size.height))*[ChipmunkUtils screenWidth];
        self.progressBar.frame = CGRectMake(0, 0, blueWidth, 6);
    } 
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // add some feature to snap the view to where it should be
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}



@end
