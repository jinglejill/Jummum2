//
//  MeViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MeViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "CustomTableViewCellImageText.h"
#import "CustomTableViewCellProfile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface MeViewController ()
{
    NSArray *_meList;
    NSArray *_meImageList;
    NSArray *_aboutUsList;
    NSArray *_aboutUsImageList;
    NSArray *_logOutList;
    NSArray *_logOutImageList;
    NSInteger _pageType;
}
@end

@implementation MeViewController
static NSString * const reuseIdentifierImageText = @"CustomTableViewCellImageText";
static NSString * const reuseIdentifierProfile = @"CustomTableViewCellProfile";


@synthesize tbvMe;


-(IBAction)unwindToMe:(UIStoryboardSegue *)segue
{
    
}

-(void)loadView
{
    [super loadView];
    
    _meList = @[@"ประวัติการสั่งอาหาร",@"บัตรเครดิต/เดบิต",@"ข้อกำหนดและเงื่อนไข",@"นโยบายความเป็นส่วนตัว"];//,@"ข้อมูลส่วนตัว",,@"แต้มสะสม/แลกของรางวัล"
    _meImageList = @[@"history.png",@"creditCard.png",@"termsOfService.png",@"privacyPolicy.png"];//,@"personalData.png",@"gift.png"
    _aboutUsList = @[@"แนะนำร้านอาหาร",@"แนะนำติชม",@"ติดต่อ JUMMUM",@"Log out"];
    _aboutUsImageList = @[@"recommendShop.png",@"comment.png",@"contactUs.png",@"logOut.png"];
    _logOutList = @[@"Log out"];
    _logOutImageList = @[@"logOut.png"];
    tbvMe.delegate = self;
    tbvMe.dataSource = self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    tbvMe.backgroundColor = cSystem4_10;
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageText bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierImageText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierProfile bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierProfile];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvMe])
    {
        if(section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return [_meList count];
        }
        else if (section == 2)
        {
            return [_aboutUsList count];
        }
//        else if (section == 3)
//        {
//            return [_logOutList count];
//        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvMe])
    {
     
        if(section == 0)
        {
            CustomTableViewCellProfile *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierProfile];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.imgValue.layer.cornerRadius = 35;
            cell.imgValue.layer.masksToBounds = YES;
            cell.imgValue.layer.borderWidth = 0;
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblEmail.text = userAccount.email;
            
            
            return cell;
        }
        else if (section == 1)
        {
            CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.imgVwIcon.image = [UIImage imageNamed:_meImageList[item]];
            cell.lblText.text = _meList[item];
            cell.lblText.textColor = cSystem1;
            return cell;
        }
        else if (section == 2)
        {
            CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.imgVwIcon.image = [UIImage imageNamed:_aboutUsImageList[item]];
            cell.lblText.text = _aboutUsList[item];
            cell.lblText.textColor = cSystem1;
            return cell;
        }
//        else if (section == 3)
//        {
//            CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//
//            cell.imgVwIcon.image = [UIImage imageNamed:_logOutImageList[item]];
//            cell.lblText.text = _logOutList[item];
//            cell.lblText.textColor = cSystem1;
//            return cell;
//        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvMe])
    {
        if(indexPath.section == 0)
        {
            return 90;
        }
        else
        {
            return 44;
        }
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:tbvMe])
    {
        if(indexPath.section == 0)
        {
            [self performSegueWithIdentifier:@"segPersonalData" sender:self];
        }
        else if(indexPath.section == 1)
        {
            switch (indexPath.item)
            {
                    //                _meList = @[@"ประวัติการสั่งอาหาร",@"ข้อมูลส่วนตัว",@"แต้มสะสม",@"My Credit Cards"];
                case 0:
                {
                    NSLog(@"did select receipt summary");
                    dispatch_async(dispatch_get_main_queue(),^ {
                        [self performSegueWithIdentifier:@"segReceiptSummary" sender:self];
                    });
                    
                }
                    break;
                case 1:
                {
                    [self performSegueWithIdentifier:@"segCreditCard" sender:self];
                }
                    break;
                case 2:
                {
                    _pageType = 1;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                case 3:
                {
                    _pageType = 2;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                default:
                    break;
            }
        }
        else if(indexPath.section == 2)
        {
            switch (indexPath.item)
            {
                    //                _meList = @[@"ประวัติการสั่งอาหาร",@"ข้อมูลส่วนตัว",@"แต้มสะสม",@"My Credit Cards"];
                
                case 0:
                {
                    [self performSegueWithIdentifier:@"segRecommendShop" sender:self];
                }
                    break;
                case 1:
                {
                    [self performSegueWithIdentifier:@"segComment" sender:self];
                }
                    break;
                case 2:
                {
                    _pageType = 3;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                case 3:
                {
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rememberMe"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberEmail"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberPassword"];
                    
                    
                    
                    [self removeMemberData];
                    [self showAlert:@"" message:@"ออกจากระบบสำเร็จ" method:@selector(unwindToLogIn)];
                }
                    break;
                default:
                    break;
            }
        }
//        else if(indexPath.section == 3)
//        {
//            [FBSDKAccessToken setCurrentAccessToken:nil];
//            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
//            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rememberMe"];
//            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberEmail"];
//            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberPassword"];
//
//
//
//            [self removeMemberData];
//            [self showAlert:@"" message:@"ออกจากระบบสำเร็จ" method:@selector(unwindToLogIn)];
//        }
    }
}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return CGFLOAT_MIN;
//    return tableView.sectionHeaderHeight;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGFLOAT_MIN;
    }
//    else if(section == 1)
//    {
//        return 8;
//    }
    return tableView.sectionHeaderHeight;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTosAndPrivacyPolicy"])
    {
        TosAndPrivacyPolicyViewController *vc = segue.destinationViewController;
        vc.pageType = _pageType;
    }
}

-(void)unwindToLogIn
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}
@end
