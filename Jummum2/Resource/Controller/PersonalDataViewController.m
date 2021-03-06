//
//  PersonalDataViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "CustomTableViewCellLabelLabel.h"
#import "UserAccount.h"


@interface PersonalDataViewController ()
{
    
}
@end

@implementation PersonalDataViewController
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *title = [Language getText:@"ข้อมูลส่วนตัว"];
    lblNavTitle.text = title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    tbvData.dataSource = self;
    tbvData.delegate = self;
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (item)
    {
        case 0:
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = [Utility validateEmailWithString:userAccount.username]?[Language getText:@"อีเมล"]:[Language getText:@"อีเมล (FB)"];
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = userAccount.email;
        }
            break;
        case 1:
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = [Language getText:@"ชื่อ"];
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = userAccount.firstName;
        }
            break;
        case 2:
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = [Language getText:@"นามสกุล"];
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = userAccount.lastName;
        }
            break;
        case 3:
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = [Language getText:@"วันเกิด"];
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = [Utility dateToString:userAccount.birthDate toFormat:@"d MMM yyyy"];
        }
            break;
        case 4:
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = [Language getText:@"เบอร์โทร."];
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = [Utility setPhoneNoFormat:userAccount.phoneNo];;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
