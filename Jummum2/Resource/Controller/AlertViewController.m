//
//  AlertViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 27/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "AlertViewController.h"
//#import "SKStoreProductViewController.h"


@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)dismiss:(id)sender
{
    [self performSegueWithIdentifier:@"segLogIn" sender:self];
}

- (IBAction)update:(id)sender
{
    //go to app store
//    static NSInteger const kAppITunesItemIdentifier = 1404154271;//324684580;
//    [self openStoreProductViewControllerWithITunesItemIdentifier:kAppITunesItemIdentifier];
    
    
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString * appITunesItemIdentifier =  lookup[@"results"][0][@"trackId"];
    [self openStoreProductViewControllerWithITunesItemIdentifier:[appITunesItemIdentifier intValue]];
//
    
    
    
//    NSString *iTunesLink = @"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}



- (void)openStoreProductViewControllerWithITunesItemIdentifier:(NSInteger)iTunesItemIdentifier {
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSNumber *identifier = [NSNumber numberWithInteger:iTunesItemIdentifier];
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:identifier };
//    UIViewController *viewController = self.window.rootViewController;
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [self presentViewController:storeViewController
                                                                        animated:YES
                                                                      completion:nil];
                                       else NSLog(@"SKStoreProductViewController: %@", error);
                                   }];
    
//    [storeViewController release];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
