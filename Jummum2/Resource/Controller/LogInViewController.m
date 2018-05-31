//
//  LogInViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 17/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LogInViewController.h"
#import "TermsOfServiceViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


#import "LogIn.h"
#import "UserAccount.h"
#import "Utility.h"
#import "FacebookComment.h"


@interface LogInViewController ()
{
    FBSDKLoginButton *_loginButton;
    BOOL _faceBookLogIn;
    BOOL _appLogIn;
    BOOL _rememberMe;
    NSString *_username;
    NSMutableArray *allComments;
}
@end

@implementation LogInViewController
@synthesize txtEmail;
@synthesize txtPassword;
@synthesize btnRememberMe;
@synthesize btnLogIn;


- (IBAction)rememberMe:(id)sender
{
    _rememberMe = !_rememberMe;
    if(_rememberMe)
    {
        [btnRememberMe setTitle:@"■ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
    }
    else
    {
        [btnRememberMe setTitle:@"□ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
    }
}

- (IBAction)logIn:(id)sender
{

    txtEmail.text = [Utility trimString:txtEmail.text];
    txtPassword.text = [Utility trimString:txtPassword.text];
    [Utility setModifiedUser:txtEmail.text];
    
    
    UserAccount *userAccount = [[UserAccount alloc]init];
    userAccount.username = txtEmail.text;
    userAccount.password = [Utility hashTextSHA256:txtPassword.text];
    
    
    LogIn *logIn = [[LogIn alloc]initWithUsername:userAccount.username status:1 deviceToken:[Utility deviceToken]];
    [self.homeModel insertItems:dbUserAccountValidate withData:@[userAccount,logIn] actionScreen:@"validate userAccount"];
    [self loadingOverlayView];
    
}

- (IBAction)registerNow:(id)sender
{
    [self performSegueWithIdentifier:@"segRegisterNow" sender:self];
}

- (IBAction)forgotPassword:(id)sender
{
    [self performSegueWithIdentifier:@"segForgotPassword" sender:self];
}

-(IBAction)unwindToLogIn:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isMemberOfClass:[TermsOfServiceViewController class]])
    {        
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    if (![FBSDKAccessToken currentAccessToken])
    {
        _faceBookLogIn = NO;
    }
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"logInSession"])
    {
        _appLogIn = NO;
    }
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"rememberMe"])
    {
        [btnRememberMe setTitle:@"■ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = YES;
        
        
        txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberEmail"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassword"];
        
    }
    else
    {
        [btnRememberMe setTitle:@"□ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tosAgree"];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"rememberMe"])
    {
        [btnRememberMe setTitle:@"■ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = YES;
        
        
        txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberEmail"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassword"];
        
    }
    else
    {
        [btnRememberMe setTitle:@"□ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = NO;
    }
    
    
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    //facebook
    _loginButton = [[FBSDKLoginButton alloc] init];
    _loginButton.delegate = self;
    _loginButton.readPermissions = @[@"public_profile", @"email",@"user_friends",@"user_birthday",@"user_likes",];
//    _loginButton.readPermissions = @[@"public_profile", @"email",@"user_friends",@"user_birthday",@"user_about_me",@"user_likes",@"user_work_history"];
    _loginButton.center = self.view.center;
    CGRect frame = _loginButton.frame;
    frame.origin.y = frame.origin.y + 33;
    _loginButton.frame = frame;
    

    // Optional: Place the button in the center of your view.
    [self.view addSubview:_loginButton];
    if ([FBSDKAccessToken currentAccessToken])
    {
        // User is logged in, do work such as go to next view controller.
        _faceBookLogIn = YES;
    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"logInSession"])
    {
        _appLogIn = YES;
    }
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if(!error)
    {
        if ([FBSDKAccessToken currentAccessToken])
        {
            _faceBookLogIn = YES;
        }
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_faceBookLogIn)
    {
        // User is logged in, do work such as go to next view controller.
        //        [self performSegueWithIdentifier:@"segBranchSearch" sender:self];
        
        [self insertUserLoginAndUserAccount];
    }
    else if(_appLogIn)
    {
        [self logIn:btnLogIn];
    }
}

//facebook
-(void)insertUserLoginAndUserAccount
{
    NSLog(@"insert user log in");
//    if(_faceBookLogIn)
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"location,email,name,first_name,gender,age_range,birthday,friends,likes"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 
                 NSLog(@"fetched user:%@", result);
                 NSLog(@"birthday:%@",result[@"birthday"]);
                 NSDate *birthday = [Utility stringToDate:result[@"birthday"] fromFormat:@"dd/MM/yyyy"];
                 
                 //1.insert userlogin
                 //2.insert useraccount if not exist
                 NSString *modifiedUser = [NSString stringWithFormat:@"%@",result[@"id"]];
                 [Utility setModifiedUser:modifiedUser];
                 LogIn *logIn = [[LogIn alloc]initWithUsername:result[@"id"] status:1 deviceToken:[Utility deviceToken]];
                 UserAccount *userAccount = [[UserAccount alloc]initWithUsername:result[@"id"] password:txtPassword.text deviceToken:[Utility deviceToken] fullName:result[@"name"] nickName:@"" birthDate:birthday email:result[@"email"] phoneNo:@"" lineID:@"" roleID:0];
                 [self.homeModel insertItems:dbLogInUserAccount withData:@[logIn,userAccount] actionScreen:@"insert login and useraccount if not exist in logIn screen"];
                 [self loadingOverlayView];
             }
             else
             {
                 [self showAlert:@"" message:@"There is problem with facebook login, please try again"];
                 NSLog(@"test error: %@",error.description);
             }
         }];
    }
}

//app logIn
-(void)itemsInsertedWithReturnData:(NSArray *)items;
{
    [self removeOverlayViews];
    if(self.homeModel.propCurrentDBInsert == dbUserAccountValidate)
    {
        if([items count] > 0 && [items[0] count] == 0)
        {
            [self showAlert:@"" message:@"อีเมลล์/พาสเวิร์ด ไม่ถูกต้อง"];
        }
        else
        {
            //insert useraccount,receipt,ordertaking,ordernote,menu to sharedObject
            NSMutableArray *userAccountList = items[0];
            [UserAccount setCurrentUserAccount:userAccountList[0]];
            [Utility addToSharedDataList:items];
            
    
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"logInSession"];
            [[NSUserDefaults standardUserDefaults] setInteger:_rememberMe forKey:@"rememberMe"];
            if(_rememberMe)
            {
                [[NSUserDefaults standardUserDefaults] setValue:txtEmail.text forKey:@"rememberEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:txtPassword.text forKey:@"rememberPassword"];
            }
            
            
            
            //show terms of service
            NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
            if(dicTosAgree)
            {
                NSString *username;
                {
                    username = txtEmail.text;
                    NSNumber *tosAgree = [dicTosAgree objectForKey:username];
                    if(!tosAgree)
                    {
                        [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
                    }
                    else
                    {
                        [self performSegueWithIdentifier:@"segQrCodeScanTable" sender:self];
                    }
                }
            }
            else
            {
                [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
            }
        }
    }
    else if(self.homeModel.propCurrentDBInsert == dbLogInUserAccount)
    {
        //insert useraccount,receipt,ordertaking,ordernote,menu to sharedObject
        NSMutableArray *userAccountList = items[0];
        [UserAccount setCurrentUserAccount:userAccountList[0]];
        [Utility addToSharedDataList:items];
        
        
        
        //show terms of service
        NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
        NSString *username = [[FBSDKAccessToken currentAccessToken] userID];
        NSNumber *tosAgree = [dicTosAgree objectForKey:username];
        if(tosAgree)
        {
            [self performSegueWithIdentifier:@"segQrCodeScanTable" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTermsOfService"])
    {
        TermsOfServiceViewController *vc = segue.destinationViewController;
        if(_faceBookLogIn)
        {
            vc.username = [[FBSDKAccessToken currentAccessToken] userID];
        }
        else
        {
            vc.username = txtEmail.text;
        }
    }
}


@end

