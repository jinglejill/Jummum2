//
//  SaveToCameraRollViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 15/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SaveToCameraRollViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Note.h"
#import "OrderNote.h"
#import "Menu.h"


@interface SaveToCameraRollViewController ()
{
    UITableView *tbvData;
}
@end

@implementation SaveToCameraRollViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";


@synthesize lblMessage;
@synthesize vwAlertHeight;
@synthesize lblMessageHeight;
@synthesize vwAlert;
@synthesize receipt;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    lblMessageHeight.constant = lblMessage.frame.size.height;
    vwAlertHeight.constant = 80+38+38+44+lblMessage.frame.size.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    tbvData = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    
    


    // Do any additional setup after loading the view.
    NSString *strMessageHeader = @"ชำระเงินสำเร็จ";
    NSString *strMessageSubTitle = @"ขอบคุณที่ใช้บริการ";

    UIFont *font = [UIFont boldSystemFontOfSize:22];
    UIColor *color = [UIColor darkGrayColor];
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrStringHeader = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",strMessageHeader] attributes:attribute];


    UIFont *font2 = [UIFont systemFontOfSize:15];
    UIColor *color2 = [UIColor darkGrayColor];
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strMessageSubTitle attributes:attribute2];


    [attrStringHeader appendAttributedString:attrString];



    lblMessage.attributedText = attrStringHeader;
    [lblMessage sizeToFit];
    
    
    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
}

- (IBAction)button1Clicked:(id)sender
{
    //save to camera roll
    [self screenCaptureBill:receipt];
    [self performSegueWithIdentifier:@"segUnwindToBranchSearch" sender:self];
}

- (IBAction)button2Clicked:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToBranchSearch" sender:self];
}

-(void)screenCaptureBill:(Receipt *)receipt
{
    NSMutableArray *arrImage = [[NSMutableArray alloc]init];
    
    
    //order header
    CustomTableViewCellReceiptSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
    Branch *branch = [Branch getBranch:receipt.branchID];
    cell.lblReceiptNo.text = [NSString stringWithFormat:@"Order no. #%@", receipt.receiptNoID];
    cell.lblReceiptDate.text = [Utility dateToString:receipt.receiptDate toFormat:@"d MMM yy HH:mm"];
    cell.lblBranchName.text = [NSString stringWithFormat:@"ร้าน %@",branch.name];
    cell.lblBranchName.textColor = mGreen;
    cell.btnOrderItAgain.hidden = YES;
    
    
    CGRect frame = cell.frame;
    frame.size.height = 79;
    cell.frame = frame;
    
    UIImage *image = [self imageFromView:cell];
    [arrImage addObject:image];
    
    
    
    
    
    
    ///// order detail
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    for(int i=0; i<[orderTakingList count]; i++)
    {
        CustomTableViewCellOrderSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
        
        
        OrderTaking *orderTaking = orderTakingList[i];
        Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
        cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        
        
        //menu
        if(orderTaking.takeAway)
        {
            UIFont *font = [UIFont systemFontOfSize:15];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ"
                                                                                           attributes:attribute];
            
            NSDictionary *attribute2 = @{NSFontAttributeName: font};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblMenuName.attributedText = attrString;
        }
        else
        {
            cell.lblMenuName.text = menu.titleThai;
        }
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
        CGRect frame = cell.lblMenuName.frame;
        frame.size.width = menuNameLabelSize.width;
        frame.size.height = menuNameLabelSize.height;
        cell.lblMenuNameHeight.constant = menuNameLabelSize.height;
        cell.lblMenuName.frame = frame;
        
        
        
        //note
        NSMutableAttributedString *strAllNote;
        NSMutableAttributedString *attrStringRemove;
        NSMutableAttributedString *attrStringAdd;
        NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
        NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            UIFont *font = [UIFont systemFontOfSize:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
            
            
            UIFont *font2 = [UIFont systemFontOfSize:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
            
            
            [attrStringRemove appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strAddTypeNote])
        {
            UIFont *font = [UIFont systemFontOfSize:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
            
            
            UIFont *font2 = [UIFont systemFontOfSize:11];
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
        
        
        
        CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
        noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
        CGRect frame2 = cell.lblNote.frame;
        frame2.size.width = noteLabelSize.width;
        frame2.size.height = noteLabelSize.height;
        cell.lblNoteHeight.constant = noteLabelSize.height;
        cell.lblNote.frame = frame2;
        
        
        
        
        
        float totalAmount = orderTaking.specialPrice * orderTaking.quantity;
        NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
        cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
        
        
        float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
        CGRect frameCell = cell.frame;
        frameCell.size.height = height;
        cell.frame = frameCell;
        
        
        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }
    /////
    
    
    
    
    
    //section 1 --> total //
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
        
        
        if(receipt.discountValue == 0 && receipt.serviceChargePercent == 0)//3 rows
        {
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont systemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.textColor = [UIColor darkGrayColor];
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            
        }
        else if(receipt.discountValue > 0 && receipt.serviceChargePercent == 0)//5 rows
        {
            
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                strDiscount = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscount];
                
                NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                
                cell.lblTitle.text = receipt.discountType==1?@"ส่วนลด":strDiscount;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //after discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = @"ยอดรวม";
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 3:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.textColor = [UIColor darkGrayColor];
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 4:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
        }
        else if(receipt.discountValue == 0 && receipt.serviceChargePercent > 0)//4 rows
        {
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //service charge
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                
                NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = strServiceChargePercent;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.textColor = [UIColor darkGrayColor];
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.textColor = [UIColor darkGrayColor];
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 3:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
        }
        else if(receipt.discountValue > 0 && receipt.serviceChargePercent > 0)//6 rows
        {
            
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                strDiscount = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscount];
                
                NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                
                
                cell.lblTitle.text = receipt.discountType==1?@"ส่วนลด":strDiscount;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //after discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = @"ยอดรวม";
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont boldSystemFontOfSize:15];
                cell.lblTitle.textColor = [UIColor darkGrayColor];
                cell.lblAmount.font = [UIFont boldSystemFontOfSize:15];
                cell.lblAmount.textColor = mGreen;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 3:
            {
                //service charge
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                
                NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = strServiceChargePercent;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.textColor = [UIColor darkGrayColor];
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 4:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.font = [UIFont systemFontOfSize:15];
                cell.lblAmount.textColor = [UIColor darkGrayColor];
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 5:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
        }
    }
    ////
    
    UIImage *combineImage = [self combineImage:arrImage];
    UIImageWriteToSavedPhotosAlbum(combineImage, nil, nil, nil);
}
@end
