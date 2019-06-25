//
//  MeViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MeViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "ReceiptSummaryViewController.h"
#import "CommentViewController.h"
#import "BasketViewController.h"
#import "BranchSearchViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CreditCardViewController.h"
#import "CustomerTableSearchViewController.h"
#import "HotDealDetailViewController.h"
#import "MenuSelectionViewController.h"
#import "MyRewardViewController.h"
#import "NoteViewController.h"
#import "PaymentCompleteViewController.h"
#import "PersonalDataViewController.h"
#import "RecommendShopViewController.h"
#import "RewardDetailViewController.h"
#import "RewardRedemptionViewController.h"
#import "SelectPaymentMethodViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "VoucherCodeListViewController.h"
#import "CustomTableViewCellImageText.h"
#import "CustomTableViewCellImageLabelText.h"
#import "CustomTableViewCellProfile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LogIn.h"



@interface MeViewController ()
{
    NSArray *_meList;
    NSArray *_meImageList;
    NSArray *_aboutUsList;
    NSArray *_aboutUsImageList;
    NSInteger _pageType;
    BOOL _goToBuffetOrder;
    NSInteger _selectedIndexPicker;
    NSArray *_languageList;
    NSString *_selectedLangText;
}
@end

@implementation MeViewController
static NSString * const reuseIdentifierImageText = @"CustomTableViewCellImageText";
static NSString * const reuseIdentifierImageLabelText = @"CustomTableViewCellImageLabelText";
static NSString * const reuseIdentifierProfile = @"CustomTableViewCellProfile";


@synthesize tbvMe;
@synthesize topViewHeight;
@synthesize pickerVw;


-(IBAction)unwindToMe:(UIStoryboardSegue *)segue
{
    self.showOrderDetail = 0;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            Language *language = _languageList[_selectedIndexPicker];
            _selectedLangText = language.code;
        }
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        _selectedIndexPicker = [Language getSelectedIndex];
        [pickerVw selectRow:_selectedIndexPicker inComponent:0 animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)loadView
{
    [super loadView];
    
    _meList = @[@"Change language",@"บัตรเครดิต/เดบิต",@"ข้อกำหนดและเงื่อนไขของ JUMMUM",@"นโยบายความเป็นส่วนตัว"];
    _meImageList = @[@"changeLang.png",@"creditCard.png",@"termsOfService.png",@"privacyPolicy.png"];
    _aboutUsList = @[@"แนะนำร้านอาหาร",@"แนะนำ ติชม",@"ติดต่อ JUMMUM",@"Log out"];
    _aboutUsImageList = @[@"recommendShop.png",@"comment.png",@"contactUs.png",@"logOut.png"];
    
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
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageLabelText bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierImageLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierProfile bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierProfile];
    }
    
    
    //------
    CustomTableViewCellProfile *cell = [tbvMe dequeueReusableCellWithIdentifier:reuseIdentifierProfile];

    
    _languageList = [Language getLanguageList];
    [pickerVw removeFromSuperview];
    pickerVw.delegate = self;
    pickerVw.dataSource = self;
    pickerVw.showsSelectionIndicator = YES;
    
    
    cell.imgValue.layer.cornerRadius = 35;
    cell.imgValue.layer.masksToBounds = YES;
    cell.imgValue.layer.borderWidth = 0;
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    if([userAccount.fullName isEqualToString:@""])
    {
        cell.lblEmail.text = [NSString stringWithFormat:@"%@ %@", userAccount.firstName,userAccount.lastName];
    }
    else
    {
        cell.lblEmail.text = userAccount.fullName;
    }
    
    
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    float topPadding = window.safeAreaInsets.top;
    CGRect frame = cell.frame;
    frame.origin.x = 0;
    frame.origin.y = topPadding == 0?20:topPadding;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 90;
    cell.frame = frame;
    [self.view addSubview:cell];
    
    
    
    [cell.singleTapGestureRecognizer addTarget:self action:@selector(handleSingleTap:)];
    [cell.vwContent addGestureRecognizer:cell.singleTapGestureRecognizer];
    cell.singleTapGestureRecognizer.numberOfTapsRequired = 1;
    ////-----------
    
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
        else if (section == 1)
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
        if (section == 0)
        {
            if(item == 0)
            {
                CustomTableViewCellImageLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.imgVwIcon.image = [UIImage imageNamed:_meImageList[item]];
                cell.lblText.text =  [Language getText:_meList[item]];
                cell.lblText.textColor = cSystem4;
                
                
                cell.txtValue.tag = 1;
                cell.txtValue.delegate = self;
                cell.txtValue.inputView = pickerVw;
                [cell.txtValue setInputAccessoryView:self.toolBar];
                [cell.txtValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                
                
                cell.txtValue.text = [Language getLanguage];
                
                
                return cell;
            }
            else
            {
                CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.imgVwIcon.image = [UIImage imageNamed:_meImageList[item]];
                cell.lblText.text = [Language getText:_meList[item]];
                cell.lblText.textColor = cSystem4;
                return cell;
            }
        }
        else if (section == 1)
        {
            CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.imgVwIcon.image = [UIImage imageNamed:_aboutUsImageList[item]];
            cell.lblText.text = [Language getText:_aboutUsList[item]];
            cell.lblText.textColor = cSystem4;
            return cell;
        }
    }
    
    return nil;
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
    if([tableView isEqual:tbvMe])
    {
        if(indexPath.section == 0)
        {
            switch (indexPath.item)
            {
                case 0:
                {
                    UITextField *textField = [self.view viewWithTag:1];
                    [textField becomeFirstResponder];
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
        else if(indexPath.section == 1)
        {
            switch (indexPath.item)
            {
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
                    [self loadingOverlayView];
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rememberMe"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberEmail"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberPassword"];
                    
                    
                    NSString *message = [Language getText:@"ออกจากระบบสำเร็จ"];
                    [self removeMemberData];
                    [self removeOverlayViews];
                    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
                    LogIn *logIn = [[LogIn alloc]initWithUsername:userAccount.username status:-1 deviceToken:[Utility deviceToken] model:[self deviceName]];
                    [self.homeModel insertItems:dbLogOut withData:logIn actionScreen:@"log out in Me screen"];
                    [self showAlert:@"" message:message method:@selector(unwindToLogIn)];
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;//CGFLOAT_MIN;
    }
    return tableView.sectionHeaderHeight;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTosAndPrivacyPolicy"])
    {
        TosAndPrivacyPolicyViewController *vc = segue.destinationViewController;
        vc.pageType = _pageType;
    }
    else if([[segue identifier] isEqualToString:@"segReceiptSummary"])
    {
        ReceiptSummaryViewController *vc = segue.destinationViewController;
        vc.showOrderDetail = self.showOrderDetail;
        vc.selectedReceipt = self.selectedReceipt;
        vc.goToBuffetOrder = _goToBuffetOrder;
    }
}

-(void)unwindToLogIn
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self performSegueWithIdentifier:@"segPersonalData" sender:self];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellImageLabelText *cell = [tbvMe cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        _selectedIndexPicker = row;
        Language *language = _languageList[row];
        [Language setLanguage:language.code];
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomTableViewCellImageLabelText *cell = [tbvMe cellForRowAtIndexPath:indexPath];
        cell.txtValue.text = [Language getLanguage];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellImageLabelText *cell = [tbvMe cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        return [_languageList count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strText = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellImageLabelText *cell = [tbvMe cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        Language *language = _languageList[row];
        strText = language.code;
    }
    
    return strText;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [tbvMe reloadData];
}
@end
