//
//  LoginViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 6/5/13.
//  Copyright (c) 2013 Amadou Crookes. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

#import "ViewController.h"


@interface LoginViewController ()

@end

const int LOGO_WIDTH   = 260;
const int LOGO_HEIGHT  = 80;
const int LOGIN_WIDTH  = 280;
const int LOGIN_HEIGHT = 50;

@implementation LoginViewController

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
    
    FBLoginView *loginview =[[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
    
    
    loginview.frame = CGRectMake(50, 425, 225, 80);

    loginview.delegate = self;
    
    [self.view addSubview:loginview];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginView delegate


- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // Upon login, transition to the main UI by pushing it onto the navigation stack.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.hidden = YES;
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

/*
- (void)updateView:(BOOL)animated {

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"session token: %@", appDelegate.session.accessTokenData.accessToken);

    if (appDelegate.session.isOpen) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.hidden = YES;
            ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
            [self.navigationController pushViewController:vc animated:animated];
        });
    } else {
        NSLog(@"couldnt push to main view");
    }
}
*/


@end
