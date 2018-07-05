//
//  NewVersionUpdateViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 2/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import <StoreKit/StoreKit.h>


@interface NewVersionUpdateViewController : CustomViewController<SKStoreProductViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwAlert;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnDismiss;
- (IBAction)dismiss:(id)sender;
- (IBAction)update:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAlertHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnDismissTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnDismissHeight;

@end
