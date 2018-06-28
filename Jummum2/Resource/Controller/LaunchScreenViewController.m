//
//  LaunchScreenViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()
{
    BOOL _redirectToLogin;
}
@end

@implementation LaunchScreenViewController
@synthesize progressBar;


-(IBAction)unwindToLaunchScreen:(UIStoryboardSegue *)segue
{
    
}

//-(void)viewdi
-(void)loadView
{
    [super loadView];
    
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    {
        CGRect frame = progressBar.frame;
        frame.origin.y = self.view.frame.size.height-20;
        frame.size.width = self.view.frame.size.width - 40;
        frame.origin.x = 20;
        progressBar.frame = frame;
    }
    
    [self.view addSubview:progressBar];
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
            NSString *title = @"Warning";
            NSString *message = @"Memory fail";
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:message                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            
            NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
            [attrStringTitle addAttribute:NSFontAttributeName
                                    value:[UIFont fontWithName:@"Prompt-SemiBold" size:22]
                                    range:NSMakeRange(0, title.length)];
            [attrStringTitle addAttribute:NSForegroundColorAttributeName
                                    value:cSystem4
                                    range:NSMakeRange(0, title.length)];
            [alert setValue:attrStringTitle forKey:@"attributedTitle"];
            
            
            NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
            [attrStringMsg addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Prompt-Regular" size:15]
                                  range:NSMakeRange(0, message.length)];
            [attrStringTitle addAttribute:NSForegroundColorAttributeName
                                    value:cSystem4
                                    range:NSMakeRange(0, title.length)];
            [alert setValue:attrStringMsg forKey:@"attributedMessage"];
            
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                
                                            }];
            [alert addAction:defaultAction];
            dispatch_async(dispatch_get_main_queue(),^ {
                [self presentViewController:alert animated:YES completion:nil];
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                UIColor *color = cSystem1;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
                
                UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
                label.attributedText = attrString;
                
            } );
            return;
        }
        
        
        
        [Utility itemsDownloaded:items];
        [self removeOverlayViews];//อาจ มีการเรียกจากหน้า customViewController
        
        
        
//        if([self needsUpdate])
//        {
//
//            [self performSegueWithIdentifier:@"segUpdateVersion" sender:self];
//        }
//        else
//        {
            [self performSegueWithIdentifier:@"segLogIn" sender:self];
//        }
    }
}

-(BOOL) needsUpdate
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    return NO;
}
@end
