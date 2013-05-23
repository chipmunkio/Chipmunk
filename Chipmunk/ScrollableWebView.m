//
//  ScrollableWebView.m
//  Chipmunk
//
//  Created by Amadou Crookes on 5/21/13.
//  Copyright (c) 2013 Gabe Jacobs. All rights reserved.
//

#import "ScrollableWebView.h"

const int PROGRESS_BAR_HEIGHT = 6;

@interface ScrollableWebView () <UIScrollViewDelegate>

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
    wv.scrollView.delegate = wv;
    wv.scrollView.showsVerticalScrollIndicator = NO; //this is shown by the progress bar
    
    UIView* greyBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ChipmunkUtils screenWidth], PROGRESS_BAR_HEIGHT)];
    greyBar.backgroundColor = [UIColor darkGrayColor];
    wv.progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, PROGRESS_BAR_HEIGHT)];
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
    } else {
        if(self.frame.origin.y > self.scrollOffset) {
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
        CGFloat denominator = self.scrollView.contentSize.height - self.frame.size.height;
        denominator = (denominator == 0) ? 1 : denominator;
        CGFloat blueWidth = (offset.y/denominator) * self.frame.size.width;
        self.progressBar.frame = CGRectMake(0, 0, blueWidth, PROGRESS_BAR_HEIGHT);
    } 
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.frame.origin.y <= self.scrollOffset) {
        self.scrollView.scrollEnabled = YES;
        self.scrollView.userInteractionEnabled = YES;
    } else if (self.frame.origin.y < self.webViewStartY) {
        float moveableDistance = self.webViewStartY - self.scrollOffset;
        float newY = (self.frame.origin.y - self.scrollOffset < moveableDistance/2) ? self.scrollOffset : self.webViewStartY;
        [UIView animateWithDuration:0.35 animations:^{
            CGRect newFrame = self.frame;
            newFrame.origin.y = newY;
            self.frame = newFrame;
        }];
    }
    
}

//*********************************************************
//*********************************************************
#pragma mark - ScrollView Delegate
//*********************************************************
//*********************************************************


// move to using the actual scrollview after the lift their finger and the webview has been moved a little bit
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView.contentOffset.y <= 0 || self.frame.origin.y > self.scrollOffset) {
        CGRect frame = self.frame;
        frame.origin.y -= scrollView.contentOffset.y;
        if (frame.origin.y > self.webViewStartY)
            frame.origin.y = self.webViewStartY;
        else if (frame.origin.y < self.scrollOffset)
            frame.origin.y = self.scrollOffset;
        self.frame = frame;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    
    CGFloat denominator = scrollView.contentSize.height - scrollView.frame.size.height;
    denominator = (denominator == 0) ? 1 : denominator;
    CGFloat blueWidth = (scrollView.contentOffset.y / denominator) * self.frame.size.width;
    self.progressBar.frame = CGRectMake(0, 0, blueWidth, PROGRESS_BAR_HEIGHT);

}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.scrollView.scrollEnabled = NO;
    self.scrollView.userInteractionEnabled = NO;
}

// calling touches ended in the below two functions will force the view to scroll to the correct position
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate && self.scrollView.contentOffset.y <= 0) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.userInteractionEnabled = NO;
        [self touchesEnded:nil withEvent:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.scrollView.contentOffset.y <= 0) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.userInteractionEnabled = NO;
        [self touchesEnded:nil withEvent:nil];
    }
}



@end
