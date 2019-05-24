//
//  ReceiptSummaryViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ReceiptSummaryViewController.h"
#import "OrderDetailViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "MenuSelectionViewController.h"
#import "ShareOrderQrViewController.h"
#import "ShowQRToPayViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel.h"
#import "CustomTableViewCellLabelRemark.h"
#import "CustomTableViewCellButton.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"


@interface ReceiptSummaryViewController ()
{
    NSMutableArray *_receiptList;
    BOOL _lastItemReached;
    Branch *_receiptBranch;
    NSInteger _selectedReceiptID;
    Receipt *_selectedReceipt;
    NSMutableDictionary *_dicTimer;
    NSInteger _page;
    NSInteger _perPage;
    BOOL _loadData;
    NSInteger _shareOrderReceiptID;
}
@end

@implementation ReceiptSummaryViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize orderItAgainReceipt;


-(IBAction)unwindToReceiptSummary:(UIStoryboardSegue *)segue
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tbvData reloadData];
    
}
    
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if(!_loadData)
    {
        _page = 1;
        _lastItemReached = NO;
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbReceiptSummaryPage withData:@[userAccount,@(_page),@(_perPage)]];
    }
    else
    {
        _loadData = NO;
    }
    

    if(self.showOrderDetail)
    {
        self.showOrderDetail = 0;
        [self segueToOrderDetailAuto:self.selectedReceipt];
    }
    else if(self.goToBuffetOrder)
    {
        self.goToBuffetOrder = 0;
        _selectedReceipt = self.selectedReceipt;
        [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"ประวัติการสั่งอาหาร"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
    _dicTimer = [[NSMutableDictionary alloc]init];
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    
    
    
    [self loadingOverlayView];
    _loadData = YES;
    _page = 1;
    _perPage = 10;
    _lastItemReached = NO;
    _receiptList = [[NSMutableArray alloc]init];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptSummaryPage withData:@[userAccount,@(_page),@(_perPage)]];
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    _receiptList = [Receipt removeStatus3:_receiptList];
    if([tableView isEqual:tbvData])
    {
        if([_receiptList count] == 0)
        {
            NSString *message = [Language getText:@"คุณไม่มีประวัติการสั่งอาหาร"];
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = message;
            noDataLabel.textColor        = cSystem4;
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        else
        {
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        return [_receiptList count];
    }
    else
    {
        return 6;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        return 1;
    }
    else
    {
        if(section == 0)
        {
//            NSInteger receiptID = tableView.tag;
            NSInteger receiptIndex = tableView.tag;
            Receipt *receipt = _receiptList[receiptIndex];
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
            orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
            
            return [orderTakingList count];
        }
        else if(section == 1 || section == 2 || section == 3 || section == 4 || section == 5)
        {
            return 1;
        }
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        Receipt *receipt = _receiptList[section];
        
        //order no.
        UIColor *color = cSystem4;
        NSDictionary *attribute = @{NSForegroundColorAttributeName:color};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Order no. #%@",receipt.receiptNoID] attributes:attribute];
    

        UIColor *color2 = cSystem2;
        NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2};
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@" (Buffet)" attributes:attribute2];
        if(receipt.buffetReceiptID)
        {
            [attrString appendAttributedString:attrString2];
        }
        cell.lblReceiptNo.attributedText = attrString;
        [cell.lblReceiptNo sizeToFit];
        CGRect frame = cell.lblReceiptNo.frame;
        frame.size.height = 17;
        cell.lblReceiptNo.frame = frame;
       
    
        
        //show qr for share buffet order
        NSInteger timeToOrder = receipt.timeToOrder;
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
        NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
        BOOL receiptStatusValid = receipt.status == 2 || receipt.status == 5 || receipt.status == 6;
        cell.btnShareOrder.hidden = !(receiptStatusValid && receipt.hasBuffetMenu && timeToCountDown && !receipt.buffetEnded);
        cell.btnShareOrder.tag = receipt.receiptID;
        [cell.btnShareOrder addTarget:self action:@selector(shareOrderQr:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //date and branch name
        Branch *branch = [Branch getBranch:receipt.branchID];
        cell.lblReceiptDate.text = [Utility dateToString:receipt.modifiedDate toFormat:@"d MMM yy HH:mm"];
        cell.lblBranchName.text = [NSString stringWithFormat:[Language getText:@"ร้าน %@"],branch.name];
        cell.lblBranchName.textColor = cSystem1;
        
        
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
        }
        
        
        cell.tbvOrderDetail.delegate = self;
        cell.tbvOrderDetail.dataSource = self;
        cell.tbvOrderDetail.tag = section;//receipt.receiptID;
        [cell.tbvOrderDetail reloadData];
        [cell.btnOrderItAgain setTitle:[Language getText:@"สั่งซ้ำ"] forState:UIControlStateNormal];
        [cell.btnOrderItAgain addTarget:self action:@selector(orderItAgain:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonDesign:cell.btnOrderItAgain];
        
        
        if (!_lastItemReached && section == [_receiptList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbReceiptSummaryPage withData:@[userAccount,@(_page),@(_perPage)]];
        }
        
        return cell;
    }
    else
    {
//        NSInteger receiptID = tableView.tag;
        NSInteger receiptIndex = tableView.tag;
        Receipt *receipt = _receiptList[receiptIndex];
        if(section == 0)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
            orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
            Branch *branch = [Branch getBranch:receipt.branchID];
            
            
            if(item < [orderTakingList count])
            {
                CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                OrderTaking *orderTaking = orderTakingList[item];
                Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
                cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
                
                
                //menu
                if(orderTaking.takeAway)
                {
                    NSString *message = [Language getText:@"ใส่ห่อ"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    NSDictionary *attribute2 = @{NSFontAttributeName: font};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                    
                    
                    [attrString appendAttributedString:attrString2];
                    cell.lblMenuName.attributedText = attrString;
                }
                else
                {
                    cell.lblMenuName.text = menu.titleThai;
                }
                [cell.lblMenuName sizeToFit];
                cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
                
                
                
                //note
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    NSString *message = [Language getText:branch.wordNo];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSString *message = [Language getText:branch.wordAdd];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    strAllNote = attrStringRemove;
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                        [strAllNote appendAttributedString:attrString];
                        [strAllNote appendAttributedString:attrStringAdd];
                    }
                }
                else
                {
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        strAllNote = attrStringAdd;
                    }
                    else
                    {
                        strAllNote = [[NSMutableAttributedString alloc]init];
                    }
                }
                cell.lblNote.attributedText = strAllNote;
                [cell.lblNote sizeToFit];
                cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
                
                
                
                float totalAmount = (orderTaking.specialPrice+orderTaking.takeAwayPrice+orderTaking.notePrice) * orderTaking.quantity;
                NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
                
                
                
                if(receipt.receiptID == _selectedReceiptID)
                {
                    cell.backgroundColor = mSelectionStyleGray;
                    if(item == [orderTakingList count]-1)
                    {
                        _selectedReceiptID = 0;
                    }
                }
                else
                {
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                return cell;
            }
        }
        else if(section == 1)
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
            if([Utility isStringEmpty:receipt.remark])
            {
                cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
            }
            else
            {
                NSString *message = [Language getText:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
            }
            [cell.lblText sizeToFit];
            cell.lblTextHeight.constant = cell.lblText.frame.size.height;
        
            return cell;
        }
        else if(section == 2)
        {
            CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
            NSString *strTotalAmount = [Utility formatDecimal:receipt.netTotal withMinFraction:2 andMaxFraction:2];
            strTotalAmount = [Utility addPrefixBahtSymbol:strTotalAmount];
            cell.lblAmount.text = strTotalAmount;
            cell.lblTitle.text = [Language getText:@"รวมทั้งหมด"];
            cell.lblTitleTop.constant = 8;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem1;
            cell.vwTopBorder.hidden = NO;
            cell.vwBottomBorder.hidden = NO;
        
        
            return cell;
        }
        else if(section == 3)
        {
            CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
            NSString *strStatus = [Receipt getStrStatus:receipt];
            UIColor *color = cSystem2;
        

            UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
            NSMutableAttributedString *attrStringStatus = [[NSMutableAttributedString alloc] initWithString:strStatus attributes:attribute];
 
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
            UIColor *color2 = cSystem4;
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
            NSMutableAttributedString *attrStringStatusLabel = [[NSMutableAttributedString alloc] initWithString:@"Status: " attributes:attribute2];
        
        
            [attrStringStatusLabel appendAttributedString:attrStringStatus];
            cell.lblValue.attributedText = attrStringStatusLabel;


            NSInteger timeToOrder = receipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            BOOL receiptStatusValid = receipt.status == 2 || receipt.status == 5 || receipt.status == 6;
            BOOL showBuffetButtonSection = (receiptStatusValid && receipt.hasBuffetMenu && timeToCountDown && !receipt.buffetEnded);
            if(showBuffetButtonSection)
            {
                NSInteger timeToOrder = receipt.timeToOrder;
                NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
                NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
                if(timeToCountDown == 0 || receipt.buffetEnded)
                {
                    cell.lblText.text = @"";
                    cell.lblText.hidden = YES;
                }
                else
                {
                    if(![_dicTimer objectForKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]])
                    {
                        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:receipt repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                        [self populateLabelwithTime:timeToCountDown receipt:receipt];
                        [_dicTimer setValue:timer forKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]];
                    }
                    cell.lblText.hidden = NO;
                }
            }
            else
            {
                cell.lblText.text = @"";
                cell.lblText.hidden = YES;
                
                NSTimer *timer = [_dicTimer objectForKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]];
                if(timer)
                {
                    [timer invalidate];
                }                
            }
            cell.lblTextWidthConstant.constant = 70;
        
        
            return cell;
        }
        else if(section == 4)
        {
            CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
            NSString *title = [Language getText:@"สั่งบุฟเฟ่ต์"];
            NSInteger timeToOrder = receipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            cell.btnValue.tag = receiptIndex;
            BOOL receiptStatusValid = receipt.status == 2 || receipt.status == 5 || receipt.status == 6;
            cell.btnValue.hidden = !(receiptStatusValid && receipt.hasBuffetMenu && timeToCountDown && !receipt.buffetEnded);
            cell.btnValue.backgroundColor = cSystem1;
            [cell.btnValue setTitle:title forState:UIControlStateNormal];
            [cell.btnValue addTarget:self action:@selector(orderBuffet:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnValue];
        
        
            return cell;
        }
        else if(section == 5)
        {
            CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            
            NSString *title = [Language getText:@"ชำระเงิน"];
            cell.btnValue.tag = receiptIndex;
            cell.btnValue.hidden = !(receipt.status == 1);
            cell.btnValue.backgroundColor = cSystem1;
            [cell.btnValue setTitle:title forState:UIControlStateNormal];
            [cell.btnValue addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnValue];
        
        
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if([tableView isEqual:tbvData])
    {
        //load order มาโชว์
        Receipt *receipt = _receiptList[indexPath.section];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        Branch *branch = [Branch getBranch:receipt.branchID];
        
        
        float sumHeight = 0;
        for(int i=0; i<[orderTakingList count]; i++)
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[i];
            Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Language getText:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            [cell.lblMenuName sizeToFit];
            cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                NSString *message = [Language getText:branch.wordNo];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Language getText:branch.wordAdd];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            [cell.lblNote sizeToFit];
            cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
            
            float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
            sumHeight += height;
        }
        
        
        //remarkHeight
        CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
        if([Utility isStringEmpty:receipt.remark])
        {
            cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
        }
        else
        {
            NSString *message = [Language getText:@"หมายเหตุ: "];
            cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
        }
        [cell.lblText sizeToFit];
        cell.lblTextHeight.constant = cell.lblText.frame.size.height;
        
        cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
        float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
        
        
        NSInteger timeToOrder = receipt.timeToOrder;
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
        NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
        BOOL receiptStatusValid = receipt.status == 2 || receipt.status == 5 || receipt.status == 6;
        BOOL showBuffetButtonSection = (receiptStatusValid && receipt.hasBuffetMenu && timeToCountDown && !receipt.buffetEnded);
        float btnBuffetHeight = showBuffetButtonSection ?44:0;
        float btnPayHeight = receipt.status == 1?44:0;
        
        return sumHeight+83+remarkHeight+34+34+btnBuffetHeight+btnPayHeight;//+37;
    }
    else
    {
//        NSInteger receiptID = tableView.tag;
        NSInteger receiptIndex = tableView.tag;
        Receipt *receipt = _receiptList[receiptIndex];
        if(section == 0)
        {
            //load order มาโชว์
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
            orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
            Branch *branch = [Branch getBranch:receipt.branchID];
            
            
            if(indexPath.item < [orderTakingList count])
            {
                CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                OrderTaking *orderTaking = orderTakingList[indexPath.item];
                Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
                cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
                
                
                //menu
                if(orderTaking.takeAway)
                {
                    NSString *message = [Language getText:@"ใส่ห่อ"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    NSDictionary *attribute2 = @{NSFontAttributeName: font};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                    
                    
                    [attrString appendAttributedString:attrString2];
                    cell.lblMenuName.attributedText = attrString;
                }
                else
                {
                    cell.lblMenuName.text = menu.titleThai;
                }
                [cell.lblMenuName sizeToFit];
                cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
                
                
                
                //note
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    NSString *message = [Language getText:branch.wordNo];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSString *message = [Language getText:branch.wordAdd];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    strAllNote = attrStringRemove;
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                        [strAllNote appendAttributedString:attrString];
                        [strAllNote appendAttributedString:attrStringAdd];
                    }
                }
                else
                {
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        strAllNote = attrStringAdd;
                    }
                    else
                    {
                        strAllNote = [[NSMutableAttributedString alloc]init];
                    }
                }
                cell.lblNote.attributedText = strAllNote;
                [cell.lblNote sizeToFit];
                cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
                
                float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
                return height;
                
            }
        }
        else if(section == 1)
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
        
        
            if([Utility isStringEmpty:receipt.remark])
            {
                cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
            }
            else
            {
                NSString *message = [Language getText:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
            }
            [cell.lblText sizeToFit];
            cell.lblTextHeight.constant = cell.lblText.frame.size.height;
        
            if([Utility isStringEmpty:receipt.remark])
            {
                return 0;
            }
            else
            {
                cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
                float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
                
                return remarkHeight;
            }
        }
        else if(section == 2)
        {
            return 34;
        }
        else if(section == 3)
        {
            return 34;
        }
        else if(section == 4)
        {
            NSInteger timeToOrder = receipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            BOOL receiptStatusValid = receipt.status == 2 || receipt.status == 5 || receipt.status == 6;
            BOOL showBuffetButtonSection = (receiptStatusValid && receipt.hasBuffetMenu && timeToCountDown && !receipt.buffetEnded);
            float btnBuffetHeight = showBuffetButtonSection ?44:0;
            
            return btnBuffetHeight;
        }
        else if(section == 5)
        {
            float height = receipt.status == 1?44:0;
            return height;
        }
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![tableView isEqual:tbvData])
    {
        
//        _selectedReceiptID = tableView.tag;
        NSInteger receiptIndex = tableView.tag;
        Receipt *receipt = _receiptList[receiptIndex];
        _selectedReceiptID = receipt.receiptID;
        _selectedReceipt = receipt;
        [tableView reloadData];
        
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"segOrderDetail" sender:self];
        });
        
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceiptSummaryPage)
    {
        [self removeOverlayViews];
        [Utility updateSharedObject:items];


        if(_page == 1)
        {
            _receiptList = items[0];
        }
        else
        {
            NSInteger remaining = [_receiptList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_receiptList removeLastObject];
            }
            
            [_receiptList addObjectsFromArray:items[0]];
        }
    
        if([items[0] count] < _perPage)
        {
            _lastItemReached = YES;
        }
        else
        {
            _page += 1;
        }
    
        [tbvData reloadData];
    }
}

-(void)reloadTableView
{
    [tbvData reloadData];
}

- (IBAction)refresh:(id)sender
{
    [self viewDidAppear:NO];
}

-(void)orderItAgain:(id)sender
{
    CGPoint point = [sender convertPoint:CGPointZero toView:tbvData];
    NSIndexPath *indexPath = [tbvData indexPathForRowAtPoint:point];
    Receipt *receipt = _receiptList[indexPath.section];


    //belong to buffet
    if(receipt.buffetReceiptID)
    {
        Receipt *buffetReceipt = [Receipt getReceipt:receipt.buffetReceiptID receiptList:_receiptList];
        if(buffetReceipt)
        {
            NSInteger timeToOrder = buffetReceipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:buffetReceipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            if(timeToCountDown <= 0)
            {
                [self showAlert:@"" message:[Language getText:@"ขอโทษค่ะ หมดเวลาสั่งบุฟเฟ่ต์แล้วค่ะ"]];
                return;
            }
        }
        else
        {
            [self showAlert:@"" message:[Language getText:@"ขอโทษค่ะ หมดเวลาสั่งบุฟเฟ่ต์แล้วค่ะ"]];
            return;
        }
    }
    
    
    [OrderTaking removeCurrentOrderTakingList];
    orderItAgainReceipt = receipt;
    [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([[segue identifier] isEqualToString:@"segOrderDetail"] || [[segue identifier] isEqualToString:@"segOrderDetailNoAnimate"])
    {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.receipt = _selectedReceipt;
    }
    else if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.buffetReceipt = _selectedReceipt;
        vc.fromReceiptSummaryMenu = 1;
    }
    else if([[segue identifier] isEqualToString:@"segShareOrderQr"])
    {
        ShareOrderQrViewController *vc = segue.destinationViewController;
        vc.shareOrderReceiptID = _shareOrderReceiptID;
    }
    else if([[segue identifier] isEqualToString:@"segShowQRToPay"])
    {
        ShowQRToPayViewController *vc = segue.destinationViewController;
        vc.receipt = _selectedReceipt;
        vc.fromReceiptSummary = 1;
    }
}

-(void)segueToOrderDetailAuto:(Receipt *)receipt
{
    _selectedReceipt = receipt;
    [self performSegueWithIdentifier:@"segOrderDetailNoAnimate" sender:self];
}

- (IBAction)joinOrder:(id)sender
{
    [self performSegueWithIdentifier:@"segJoinOrder" sender:self];
}

-(void)orderBuffet:(id)sender
{
    UIButton *btnValue = sender;
    _selectedReceipt = _receiptList[btnValue.tag];
    [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
}

-(void)updateTimer:(NSTimer *)timer
{
    Receipt *receipt = timer.userInfo;
    NSInteger timeToOrder = receipt.timeToOrder;
    NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
    NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
    if(timeToCountDown == 0)
    {
        [timer invalidate];
        [tbvData reloadData];
    }
    else
    {
        [self populateLabelwithTime:timeToCountDown receipt:receipt];
    }
}

- (void)populateLabelwithTime:(NSInteger)seconds receipt:(Receipt *)receipt
{
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;
    
    
    NSInteger index = [Receipt getIndexOfObject:receipt receiptList:_receiptList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    

    NSIndexPath *indexPathOrderDetail = [NSIndexPath indexPathForRow:0 inSection:3];
    CustomTableViewCellLabelLabel *cellTimeToCountDown = [cell.tbvOrderDetail cellForRowAtIndexPath:indexPathOrderDetail];
    cellTimeToCountDown.lblText.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    cellTimeToCountDown.lblText.hidden = NO;
}

-(void)shareOrderQr:(id)sender
{
    UIButton *shareOrder = (UIButton *)sender;
    _shareOrderReceiptID = shareOrder.tag;
    [self performSegueWithIdentifier:@"segShareOrderQr" sender:self];
}

-(void)pay:(id)sender
{
    UIButton *btnPay = (UIButton *)sender;
//    _selectedReceipt = [Receipt getReceipt:btnPay.tag];
    _selectedReceipt = _receiptList[btnPay.tag];
    [self performSegueWithIdentifier:@"segShowQRToPay" sender:self];
}
@end

