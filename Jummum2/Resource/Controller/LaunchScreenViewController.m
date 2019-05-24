//
//  LaunchScreenViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LogInViewController.h"
#import "NewVersionUpdateViewController.h"
#import "Card.h"
#import "Language.h"


@interface LaunchScreenViewController ()
{
    BOOL _redirectToLogin;
    NSString *_appStoreVersion;
    
}
@end

@implementation LaunchScreenViewController
@synthesize progressBar;
@synthesize lblTitle;
@synthesize lblMessage;
@synthesize imgVwLogoTop;


-(IBAction)unwindToLaunchScreen:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[NewVersionUpdateViewController class]])
    {
        NSString *strKey = [NSString stringWithFormat:@"UpdateVersion%@",_appStoreVersion];
        NSString *strUpdateVersion = [Setting getSettingValueWithKeyName:strKey];
        if(!strUpdateVersion || ![strUpdateVersion integerValue])
        {
            _redirectToLogin = YES;
        }
    }    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if(_redirectToLogin)
    {
        _redirectToLogin = 0;
        [self downloadSetting];
    }
    else
    {
        if([self needsUpdate])
        {
            NSString *key = [NSString stringWithFormat:@"dismiss verion:%@",_appStoreVersion];
            NSNumber *dismissVersion = [[NSUserDefaults standardUserDefaults] valueForKey:key];
            if([dismissVersion integerValue])
            {
                [self downloadSetting];
            }
            else
            {
                [self performSegueWithIdentifier:@"segNewVersionUpdate" sender:self];
            }
        }
        else
        {
            [self downloadSetting];
        }
    }
    
    [Card setUpCards];
    
    
    //delete image in cache
    [Utility deleteFileInCache:@"/JMM"];
    
    
    [Utility createCacheFoler:@"/JMM"];
    [Utility createCacheFoler:@"/JMM/Image"];
    [Utility createCacheFoler:@"/JMM/Image/Promotion"];
    [Utility createCacheFoler:@"/JMM/Image/Reward"];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    imgVwLogoTop.constant = (self.view.frame.size.height - (542-94))/2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    NSString *message = [Setting getValue:@"002m" example:@"Pay for your order, earn and track rewards, check your balance and more, all from your mobile device"];
    lblTitle.text = title;
    lblMessage.text = message;
    
    
    [Language setSupportLanguage];
//    [[NSUserDefaults standardUserDefaults] setValue:@"TH" forKey:@"language"];
    
}

- (void)downloadProgress:(float)percent
{
    progressBar.progress = percent;
}

- (void)itemsDownloaded:(NSArray *)items
{
    if([items count] == 0)
    {
        NSString *title = [Setting getValue:@"001t" example:@"Warning"];
        NSString *message = [Setting getValue:@"001m" example:@"Memory fail"];
        [self showAlert:title message:message method:@selector(downloadSetting)];
        return;
    }
    
    
    [Utility itemsDownloaded:items];
    [self removeOverlayViews];//อาจ มีการเรียกจากหน้า customViewController
    
    
    [self performSegueWithIdentifier:@"segLogIn" sender:self];
}

-(BOOL) needsUpdate
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if(!data)
    {
        return NO;
    }
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1)
    {
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        _appStoreVersion = appStoreVersion;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segNewVersionUpdate"])
    {
        NewVersionUpdateViewController *vc = segue.destinationViewController;
        vc.appStoreVersion = _appStoreVersion;
    }
}

- (void)connectionFail
{
    [self removeOverlayViews];
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    [self showAlert:title message:message method:@selector(downloadSetting)];
}

-(void)downloadSetting
{
    progressBar.progress = 0;
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}
@end
