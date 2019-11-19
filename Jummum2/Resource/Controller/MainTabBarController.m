//
//  MainTabBarController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MainTabBarController.h"
#import "QRCodeScanTableViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CommentViewController.h"
#import "BasketViewController.h"
#import "BranchSearchViewController.h"
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
#import "ReceiptSummaryViewController.h"
#import "OrderDetailViewController.h"
#import "ShowQRToPayViewController.h"
#import "LuckyDrawViewController.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "Receipt.h"
#import "Utility.h"


@interface MainTabBarController ()
{
    NSInteger _switchToQRTab;
    NSInteger _switchToReceiptSummaryTab;
    Branch *_selectedBranch;
    CustomerTable *_selectedCustomerTable;
    BOOL _fromOrderItAgain;
    BOOL _fromOrderNow;
    Receipt *_buffetReceipt;
    Receipt *_selectedReceipt;
    BOOL _showOrderDetail;
    BOOL _showReceiptSummary;
    BOOL _showMenuSelection;
    BOOL _orderBuffet;
    BOOL _orderBuffetAfterOrderBuffet;
    Receipt *_orderItAgainReceipt;
    BOOL _switchToHotDealTab;
}
@end

@implementation MainTabBarController


-(IBAction)unwindToMainTabBar:(UIStoryboardSegue *)segue
{
    CustomViewController *vc = segue.sourceViewController;
    if([vc isMemberOfClass:[CreditCardAndOrderSummaryViewController class]] && ((CreditCardAndOrderSummaryViewController *)vc).addRemoveMenu)
    {
        CreditCardAndOrderSummaryViewController *vc = segue.sourceViewController;
        _selectedBranch = vc.branch;
        _selectedCustomerTable = vc.customerTable;
        _fromOrderNow = YES; // fromRewardRedemption || fromHotDealDetail || fromLuckyDraw
        _buffetReceipt = vc.buffetReceipt;
        
        _switchToQRTab = 1;
    }
    else if([vc isKindOfClass:[PaymentCompleteViewController class]] && ((PaymentCompleteViewController *)vc).orderBuffet)
    {
        PaymentCompleteViewController *vcPaymentComplete = (PaymentCompleteViewController *)vc;
        _orderBuffet = vcPaymentComplete.orderBuffet;
        _showOrderDetail = 0;
        if(vcPaymentComplete.receipt.buffetReceiptID)
        {
            Receipt *buffetReceipt = [Receipt getReceipt:vcPaymentComplete.receipt.buffetReceiptID];
            _selectedReceipt = buffetReceipt;
            _orderBuffetAfterOrderBuffet = 1;
        }
        else
        {
            _selectedReceipt = vcPaymentComplete.receipt;
        }
        
        _switchToReceiptSummaryTab = 1;
    }
    else if([vc isKindOfClass:[PaymentCompleteViewController class]] && ((PaymentCompleteViewController *)vc).goToHotDeal)
    {
        _switchToHotDealTab = 1;
    }
    else if([vc isKindOfClass:[ShowQRToPayViewController class]])
    {
        _switchToHotDealTab = 1;
    }
    else if(([vc isMemberOfClass:[ReceiptSummaryViewController class]] && ((ReceiptSummaryViewController *)vc).orderItAgainReceipt) || ([vc isMemberOfClass:[OrderDetailViewController class]] && ((OrderDetailViewController *)vc).orderItAgainReceipt))
    {
        ReceiptSummaryViewController *receiptSummaryVc = (ReceiptSummaryViewController *)vc;
        _orderItAgainReceipt = receiptSummaryVc.orderItAgainReceipt;
        receiptSummaryVc.orderItAgainReceipt = nil;        
        
        _fromOrderItAgain = YES;
        _switchToQRTab = 1;
        [self viewDidAppear:NO];
    }
    else if(vc.showReceiptSummary)
    {
        _showReceiptSummary = 1;
        _switchToReceiptSummaryTab = 1;
    }
    else if([vc isKindOfClass:[HotDealDetailViewController class]] && ((HotDealDetailViewController *)vc).goToMenuSelection)
    {
        HotDealDetailViewController *hotDealDetailVc = (HotDealDetailViewController *)vc;
        hotDealDetailVc.goToMenuSelection = 0;

        _selectedBranch = hotDealDetailVc.branch;
        _showMenuSelection = 1;
        _switchToQRTab = 1;
    }
    else if([vc isKindOfClass:[RewardRedemptionViewController class]] && ((RewardRedemptionViewController *)vc).goToMenuSelection)
    {
        RewardRedemptionViewController *rewardRedemptionVc = (RewardRedemptionViewController *)vc;

        _selectedBranch = rewardRedemptionVc.branch;
        _showMenuSelection = rewardRedemptionVc.goToMenuSelection;
        _fromOrderNow = YES;
        _switchToQRTab = 1;
        
        rewardRedemptionVc.goToMenuSelection = 0;
    }
    else if([vc isKindOfClass:[LuckyDrawViewController class]])
    {
        LuckyDrawViewController *luckyDrawVc = (LuckyDrawViewController *)vc;

        _selectedBranch = [Branch getBranch:luckyDrawVc.branchID];
        _showMenuSelection = 1;
        _switchToQRTab = 1;
    }
    else if([vc isKindOfClass:[CommentViewController class]] ||
                 [vc isKindOfClass:[BasketViewController class]] ||
                 [vc isKindOfClass:[BranchSearchViewController class]] ||
                 [vc isKindOfClass:[CreditCardAndOrderSummaryViewController class]] ||
                 [vc isKindOfClass:[CreditCardViewController class]] ||
                 [vc isKindOfClass:[CustomerTableSearchViewController class]] ||
                 [vc isKindOfClass:[HotDealDetailViewController class]] ||
                 [vc isKindOfClass:[MenuSelectionViewController class]] ||
                 [vc isKindOfClass:[MyRewardViewController class]] ||
                 [vc isKindOfClass:[NoteViewController class]] ||
                 [vc isKindOfClass:[PaymentCompleteViewController class]] ||
                 [vc isKindOfClass:[PersonalDataViewController class]] ||
                 [vc isKindOfClass:[RecommendShopViewController class]] ||
                 [vc isKindOfClass:[RewardDetailViewController class]] ||
                 [vc isKindOfClass:[RewardRedemptionViewController class]] ||
                 [vc isKindOfClass:[SelectPaymentMethodViewController class]] ||
                 [vc isKindOfClass:[TosAndPrivacyPolicyViewController class]] ||
                 [vc isKindOfClass:[VoucherCodeListViewController class]]
                 )
    {
        _selectedReceipt = vc.selectedReceipt;
        _showOrderDetail = vc.showOrderDetail;
        
        _switchToReceiptSummaryTab = 1;
    }
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Prompt-Regular" size:11.0f]} forState:UIControlStateNormal];
    
    
    //login already
    BOOL firstTimeInstalled = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstTimeInstalled"];
    if(!firstTimeInstalled)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTimeInstalled"];
    }
    
    
    self.selectedIndex = mainTabQrScan;
    [self.selectedViewController viewDidAppear:NO];
}
 
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_switchToQRTab)
    {
        _switchToQRTab = 0;
        if(_fromOrderItAgain)
        {
            self.selectedIndex = mainTabQrScan;
            QRCodeScanTableViewController *vc = (QRCodeScanTableViewController *)self.selectedViewController;
            vc.orderItAgainReceipt = _orderItAgainReceipt;
            vc.fromOrderItAgain = _fromOrderItAgain;
            _fromOrderItAgain = NO;
            
            [vc viewDidAppear:NO];
        }
        else if(_fromOrderNow)
        {
            self.selectedIndex = mainTabQrScan;
            QRCodeScanTableViewController *vc = (QRCodeScanTableViewController *)self.selectedViewController;
            vc.selectedBranch = _selectedBranch;
            vc.selectedCustomerTable = _selectedCustomerTable;
            vc.fromOrderNow = _fromOrderNow;
            vc.buffetReceipt = _buffetReceipt;
            _fromOrderNow = NO;
            
            [vc viewDidAppear:NO];
        }
        else if(_showMenuSelection)
        {
            _showMenuSelection = 0;
            
            self.selectedIndex = mainTabQrScan;
            QRCodeScanTableViewController *vc = (QRCodeScanTableViewController *)self.selectedViewController;
            vc.selectedBranch = _selectedBranch;
            vc.goToMenuSelection = 1;
            [vc viewDidAppear:NO];
        }        
    }
    else if(_switchToReceiptSummaryTab)
    {
        _switchToReceiptSummaryTab = 0;
        self.selectedIndex = mainTabHistory;
        
        
        ReceiptSummaryViewController *vc = (ReceiptSummaryViewController *)self.selectedViewController;
        vc.goToBuffetOrder = _orderBuffet;
        vc.selectedReceipt = _selectedReceipt;
        vc.showOrderDetail = _showOrderDetail;
        
        if(_showReceiptSummary)
        {
            [vc reloadTableView];
        }
        else if(_orderBuffetAfterOrderBuffet)
        {
            _orderBuffetAfterOrderBuffet = 0;
            [vc viewDidAppear:NO];
        }
        else if(_showOrderDetail)
        {
            _showOrderDetail = 0;
            [vc viewDidAppear:NO];
        }
    }
    else if(_switchToHotDealTab)
    {
        _switchToHotDealTab = 0;
        self.selectedIndex = mainTabHotDeal;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(self.selectedIndex == mainTabQrScan)
    {
        QRCodeScanTableViewController *vc = (QRCodeScanTableViewController *)viewController;
        vc.alreadySeg = NO;
        [vc viewDidLayoutSubviews];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
