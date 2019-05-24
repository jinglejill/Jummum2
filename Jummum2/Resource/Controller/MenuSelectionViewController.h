//
//  MenuSelectionViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "Receipt.h"
#import "SaveReceipt.h"


@interface MenuSelectionViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnViewBasket;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalQuantityTop;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UIView *vwBottomShadow;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;
@property (strong, nonatomic) Branch *branch;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) Receipt *buffetReceipt;
@property (strong, nonatomic) SaveReceipt *saveReceipt;
@property (strong, nonatomic) NSMutableArray *saveOrderTakingList;
@property (strong, nonatomic) NSMutableArray *saveOrderNoteList;
@property (nonatomic) NSInteger fromReceiptSummaryMenu;
@property (nonatomic) NSInteger fromJoinOrderMenu;
@property (nonatomic) NSInteger fromOrderItAgain;


-(IBAction)unwindToMenuSelection:(UIStoryboardSegue *)segue;
- (IBAction)goBackHome:(id)sender;
- (IBAction)viewBasket:(id)sender;

@end
