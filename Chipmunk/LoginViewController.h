//
//  LoginViewController.h
//  Chipmunk
//
//  Created by Amadou Crookes on 6/5/13.
//  Copyright (c) 2013 Amadou Crookes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController<FBLoginViewDelegate>

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error;


@end
