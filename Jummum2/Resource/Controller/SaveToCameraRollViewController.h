//
//  SaveToCameraRollViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 15/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"


@interface SaveToCameraRollViewController : CustomViewController

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIView *vwAlert;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAlertHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblMessageHeight;


@property (strong, nonatomic) Receipt *receipt;



- (IBAction)button1Clicked:(id)sender;
- (IBAction)button2Clicked:(id)sender;
@end
