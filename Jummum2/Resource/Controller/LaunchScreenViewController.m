//
//  LaunchScreenViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LogInViewController.h"


@interface LaunchScreenViewController ()
{
    BOOL _redirectToLogin;
}
@end

@implementation LaunchScreenViewController
@synthesize progressBar;
@synthesize lblAppStoreVersion;
@synthesize lblTitle;
@synthesize lblMessage;


-(IBAction)unwindToLaunchScreen:(UIStoryboardSegue *)segue
{
    _redirectToLogin = YES;
    progressBar.progress = 0;
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.homeModel downloadItems:dbMasterWithProgressBar];
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressBar.trackTintColor = [UIColor whiteColor];
    progressBar.progressTintColor = cSystem2;
    {
        CGRect frame = progressBar.frame;
        frame.origin.y = self.view.frame.size.height-20;
        frame.size.width = self.view.frame.size.width - 40;
        frame.origin.x = 20;
        progressBar.frame = frame;
    }
    
    [self.view addSubview:progressBar];
    
    
    
    NSString *title = [Setting getValue:@"002t" example:@"Welcome"];
    NSString *message = [Setting getValue:@"002m" example:@"Pay for your order, earn and track rewards, ckeck your balance and more, all from your mobile device"];
    lblTitle.text = title;
    lblMessage.text = message;
}

- (void)downloadProgress:(float)percent
{
    progressBar.progress = percent;
}

- (void)itemsDownloaded:(NSArray *)items
{
    if(self.homeModel.propCurrentDB == dbMasterWithProgressBar)
    {
        if([items count] == 0)
        {
            NSString *title = [Setting getValue:@"001t" example:@"Warning"];
            NSString *message = [Setting getValue:@"001m" example:@"Memory fail"];
            [self showAlert:title message:message];
            return;
        }
        
        
        
        [Utility itemsDownloaded:items];
        [self removeOverlayViews];//อาจ มีการเรียกจากหน้า customViewController
        
        
        if(_redirectToLogin)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
            [UIApplication sharedApplication].keyWindow.rootViewController = logInViewController;
            
            
//            [self performSegueWithIdentifier:@"segLogIn" sender:self];
        }
        else
        {
            if([self needsUpdate])
            {
                [self performSegueWithIdentifier:@"segNewVersionUpdate" sender:self];
            }
            else
            {
                [self performSegueWithIdentifier:@"segLogIn" sender:self];
            }

        }
    }
}

-(BOOL) needsUpdate
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1)
    {
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
//        lblAppStoreVersion.text = [NSString stringWithFormat:@"App store version: %@, current version: %@",appStoreVersion,currentVersion];
        NSString *strAppVersion = [NSString stringWithFormat:@"App store version: %@, current version: %@",appStoreVersion,currentVersion];
        [[NSUserDefaults standardUserDefaults] setValue:strAppVersion forKey:@"appVersion"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    else
    {
        NSString *strAppVersion = @"appVersion no resultCount";
        [[NSUserDefaults standardUserDefaults] setValue:strAppVersion forKey:@"appVersion"];
    }
    return NO;
}

- (void) connectionFail
{
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    [self showAlert:title message:message method:@selector(tryDownloadAgain)];
}

-(void)tryDownloadAgain
{
    progressBar.progress = 0;
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}
@end
