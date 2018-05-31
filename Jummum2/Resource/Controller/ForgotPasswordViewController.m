//
//  ForgotPasswordViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize txtEmail;


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtEmail)
    {
        [self submit:nil];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtEmail.delegate = self;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (IBAction)submit:(id)sender
{
    txtEmail.text = [Utility trimString:txtEmail.text];
    
    if(![Utility validateEmailWithString:txtEmail.text])
    {
        [self showAlert:@"" message:@"คุณใส่อีเมลล์ไม่ถูกต้อง"];
        return;
    }
    
    [self loadingOverlayView];
    [self.homeModel insertItems:dbUserAccountForgotPassword withData:txtEmail.text actionScreen:@"send email for reset password"];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *userAccountList = items[0];
    if([userAccountList count]==0)
    {
        [self showAlert:@"" message:@"ไม่มีอีเมลล์นี้ในระบบ"];
    }
    else
    {
        [self showAlert:@"" message:@"เราได้ส่งอีเมลล์ให้คุณแล้ว กรุณาเช็คอีเมลล์ของคุณ" method:@selector(goBack:)];
    }
}

@end
