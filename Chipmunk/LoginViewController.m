//
//  LoginViewController.m
//  Chipmunk
//
//  Created by Amadou Crookes on 6/5/13.
//  Copyright (c) 2013 Amadou Crookes. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    int frameX = ([ChipmunkUtils screenWidth] - LOGO_WIDTH)/2;
    UIImageView* logo = [[UIImageView alloc] initWithFrame:CGRectMake(frameX, 60, LOGO_WIDTH, LOGO_HEIGHT)];
    logo.backgroundColor = [UIColor whiteColor];
    logo.image = nil;
    [self.view addSubview:logo];
    
    int frameY = [ChipmunkUtils screenHeight] - LOGIN_HEIGHT - 60;
    frameX = ([ChipmunkUtils screenWidth] - LOGIN_WIDTH)/2;
    UIButton* fbLogin = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, LOGIN_WIDTH, LOGIN_HEIGHT)];
    [fbLogin addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    fbLogin.titleLabel.text = @"Facebook Login";
    fbLogin.titleLabel.textColor = [UIColor whiteColor];
    fbLogin.backgroundColor = [UIColor blueColor];
    fbLogin.tintColor = [UIColor blueColor];
    [self.view addSubview:fbLogin];
    NSLog(@"Sessoin toekn: %@", [FBSession activeSession].accessTokenData.accessToken);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginWithFacebook {
    [FBSession openActiveSessionWithAllowLoginUI:YES];
    NSLog(@"after open session");
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (!session.accessTokenData.accessToken) {
            NSLog(@"error: %@", error);
            NSLog(@"session should be null: %@", [FBSession activeSession].accessTokenData.accessToken);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"couldnt login in to facebook" message:@"try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}



@end
