//
//  AlertViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 27/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import <StoreKit/StoreKit.h>
//#import "<StoreKit.SKStoreProductViewController.h>"


@interface AlertViewController : CustomViewController<SKStoreProductViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwAlert;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnDismiss;
- (IBAction)dismiss:(id)sender;
- (IBAction)update:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitle;

@end
