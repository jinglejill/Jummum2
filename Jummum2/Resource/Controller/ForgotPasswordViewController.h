//
//  ForgotPasswordViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface ForgotPasswordViewController : CustomViewController
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)submit:(id)sender;
- (IBAction)goBack:(id)sender;

@end
