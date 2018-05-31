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
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface MeViewController ()
{
    NSArray *_meList;
    NSArray *_meImageList;
    NSArray *_aboutUsList;
    NSArray *_aboutUsImageList;
    NSInteger _pageType;
}
@end

@implementation MeViewController
static NSString * const reuseIdentifierImageText = @"CustomTableViewCellImageText";


@synthesize tbvMe;


-(IBAction)unwindToMe:(UIStoryboardSegue *)segue
{

}

-(void)loadView
{
    [super loadView];
    _meList = @[@"ประวัติการสั่งอาหาร",@"ข้อมูลส่วนตัว",@"แต้มสะสม/แลกของรางวัล",@"บัตรเครดิต/เดบิต"];
    _meImageList = @[@"history.jpg",@"personalData.png",@"gift.png",@"creditCard.png"];
    _aboutUsList = @[@"ข้อกำหนดและเงื่อนไข",@"นโยบายความเป็นส่วนตัว",@"Log out"];
    _aboutUsImageList = @[@"termsOfService.png",@"privacyPolicy.png",@"logOut.png"];
    tbvMe.delegate = self;
    tbvMe.dataSource = self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageText bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierImageText];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvMe])
    {
        if (section == 0)
        {
            return [_meList count];
        }
        else
        {
            return [_aboutUsList count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvMe])
    {
        CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        if (section == 0)
        {
            cell.imgVwIcon.image = [UIImage imageNamed:_meImageList[item]];
            cell.lblText.text = _meList[item];
        }
        else
        {
            cell.imgVwIcon.image = [UIImage imageNamed:_aboutUsImageList[item]];
            cell.lblText.text = _aboutUsList[item];
        }
        
        


        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvMe])
    {
        return 44;
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
                    [self performSegueWithIdentifier:@"segPersonalData" sender:self];
                }
                    break;
                case 2:
                {
                    [self performSegueWithIdentifier:@"segReward" sender:self];
                }
                    break;
                case 3:
                {
                    [self performSegueWithIdentifier:@"segCreditCard" sender:self];
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.item)
            {
                    //                _meList = @[@"ประวัติการสั่งอาหาร",@"ข้อมูลส่วนตัว",@"แต้มสะสม",@"My Credit Cards"];
                case 0:
                {
                    _pageType = 1;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                case 1:
                {
                    _pageType = 2;
                    [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
                }
                    break;
                case 2:
                {
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
                    [self removeMemberData];
                    [self showAlert:@"" message:@"ออกจากระบบสำเร็จ" method:@selector(unwindToLogIn)];
                }
                    break;
                default:
                    break;
            }
        }
    }
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
