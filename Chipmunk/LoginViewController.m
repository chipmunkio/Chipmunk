//
//  LoginViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 6/5/13.
//  Copyright (c) 2013 Amadou Crookes. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
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
    [self updateView];

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                //[self updateView];

            }];
        }
    } else {
        [self updateView];
    }


	// Do any additional setup after loading the view.
   // self.view.backgroundColor = [UIColor purpleColor];
    int frameX = ([ChipmunkUtils screenWidth] - LOGO_WIDTH)/2;    
    frameX = ([ChipmunkUtils screenWidth] - LOGIN_WIDTH)/2;
    NSLog(@"Sessoin toekn: %@", [FBSession activeSession].accessTokenData.accessToken);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginWithFacebook:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            if (session.isOpen && !error) {
                [self updateView];
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error authorizing with Facebook" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                NSLog(@"Error: %@", error);
            }
        }];
    }
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        NSLog(@"WE GET HERE");
        
        // THIS PART BELOW ISNT WORKING. IT SHOULD BE GETTING CALLED WHEN THE FACEBOOK VIEW IS DONE, BUT I AM NOT 100% SURE.
        
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"fuck!");
    }
}




@end
