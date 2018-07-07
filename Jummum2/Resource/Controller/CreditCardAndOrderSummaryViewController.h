//
//  CreditCardAndOrderSummaryViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "CustomViewVoucher.h"
#import "Promotion.h"


@interface CreditCardAndOrderSummaryViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UIView *vwTopBorderPay;
@property (strong, nonatomic) IBOutlet UITableView *tbvTotal;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvTotalHeightConstant;
@property (strong, nonatomic) IBOutlet CustomViewVoucher *voucherView;
@property (strong, nonatomic) Branch *branch;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (nonatomic) NSInteger fromReceiptSummaryMenu;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;

- (IBAction)backToBasket:(id)sender;
- (IBAction)pay:(id)sender;
-(IBAction)unwindToCreditCardAndOrderSummary:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
@end
