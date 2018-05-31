//
//  MenuSelectionViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuSelectionViewController.h"
#import "BasketViewController.h"
#import "CustomTableViewCellMenu.h"
#import "CustomTableViewCellQuantity.h"
#import "CustomTableViewCellSearchBar.h"
#import "Menu.h"
#import "MenuType.h"
#import "MenuTypeNote.h"
#import "Note.h"
#import "NoteType.h"
#import "SubMenuType.h"
#import "OrderTaking.h"
#import "SpecialPriceProgram.h"
#import "Setting.h"
#import "Utility.h"


@interface MenuSelectionViewController ()
{
    NSMutableArray *_menuList;
    NSMutableArray *_menuTypeList;
    NSMutableArray *_menuTypeNoteList;
    NSMutableArray *_noteList;
    NSMutableArray *_noteTypeList;
    NSMutableArray *_subMenuTypeList;
    NSMutableArray *_specialPriceProgramList;
    

    NSMutableArray *_filterMenuList;
    OrderTaking *_orderTaking;
    OrderTaking *_copyOrderTaking;
    NSInteger _showCheckOnly;
    NSInteger _selectedMenuTypeIndex;
}

@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation MenuSelectionViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierMenu = @"CustomTableViewCellMenu";
static NSString * const reuseIdentifierQuantity = @"CustomTableViewCellQuantity";
static NSString * const reuseIdentifierSearchBar = @"CustomTableViewCellSearchBar";


@synthesize branch;
@synthesize customerTable;
@synthesize tbvMenu;
@synthesize vwBottomShadow;
@synthesize lblTotalQuantityTop;
@synthesize lblTotalQuantity;
@synthesize lblTotalAmount;


-(IBAction)unwindToMenuSelection:(UIStoryboardSegue *)segue
{
    [self.view endEditing:true];
    [tbvMenu reloadData];
    [self updateTotalAmount];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segViewBasket"])
    {
        BasketViewController *vc = segue.destinationViewController;
        vc.branch = branch;
        vc.customerTable = customerTable;
    }
}

-(void)loadView
{
    [super loadView];
    
    
    tbvMenu.delegate = self;
    tbvMenu.dataSource = self;
    [self setShadow:vwBottomShadow];
    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    if([orderTakingList count]>0)
    {
        OrderTaking *orderTaking = orderTakingList[0];
        if(orderTaking.branchID == branch.branchID)
        {
            lblTotalQuantity.text = [Utility formatDecimal:[orderTakingList count] withMinFraction:0 andMaxFraction:0];
            lblTotalQuantityTop.text = lblTotalQuantity.text;
            
            
            NSString *strTotal = [Utility formatDecimal:[OrderTaking getSubTotalAmount:orderTakingList] withMinFraction:2 andMaxFraction:2];
            strTotal = [Utility addPrefixBahtSymbol:strTotal];
            lblTotalAmount.text = strTotal;
        }
        else
        {
            [OrderTaking removeCurrentOrderTakingList];
            [Menu removeCurrentMenuList];
            lblTotalQuantity.text = @"0";
            lblTotalQuantityTop.text = @"";
            lblTotalAmount.text = [Utility addPrefixBahtSymbol:@"0.00"];
        }
    }
    else
    {
        lblTotalQuantity.text = @"0";
        lblTotalQuantityTop.text = @"";
        lblTotalAmount.text = [Utility addPrefixBahtSymbol:@"0.00"];
    }
    
    
    _menuList = [Menu getCurrentMenuList];
    if([_menuList count] == 0)
    {
        [self loadingOverlayView];
        [self.homeModel downloadItems:dbMenuList withData:branch.dbName];
    }
    else
    {
        _menuTypeList = [MenuType getMenuTypeList];
        _menuTypeNoteList = [MenuTypeNote getMenuTypeNoteList];
        _noteList = [Note getNoteList];
        _noteTypeList = [NoteType getNoteTypeList];
        _subMenuTypeList = [SubMenuType getSubMenuTypeList];
        _menuTypeList = [MenuType sortList:_menuTypeList];
        
        
        
        _filterMenuList = _menuList;
        [self setData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenu bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierMenu];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSearchBar bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierSearchBar];
    }

    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)goBackHome:(id)sender
{
//    [self performSegueWithIdentifier:@"segUnwindToQRCodeScanTable" sender:self];
    [self performSegueWithIdentifier:@"segUnwindToBranchSearch" sender:self];
}

- (IBAction)viewBasket:(id)sender
{
    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    if([orderTakingList count] != 0)
    {
        [self performSegueWithIdentifier:@"segViewBasket" sender:self];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 0)
        {
            return 1;
        }
        else
        {
            MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
            NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
            return [menuList count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 0)
        {
            CustomTableViewCellSearchBar *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSearchBar];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.sbText.delegate = self;
            cell.sbText.tag = 300;
            
            
            return cell;
        }
        else
        {
            CustomTableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMenu];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
            NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
            Menu *menu = menuList[item];
            cell.lblMenuName.text = menu.titleThai;
            
            
            
            
            
            SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
            if(specialPriceProgram)
            {
                NSString *strPrice = [Utility formatDecimal:menu.price withMinFraction:2 andMaxFraction:2];
                strPrice = [NSString stringWithFormat:@"฿ %@",strPrice];
                UIFont *font = [UIFont systemFontOfSize:15];
                NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strPrice attributes:attribute];
                cell.lblPrice.attributedText = attrString;
                [cell.lblPrice sizeToFit];
                
                
                NSString *strSpecialPrice = [Utility formatDecimal:specialPriceProgram.specialPrice withMinFraction:2 andMaxFraction:2];
                cell.lblSpecialPrice.text = [NSString stringWithFormat:@"฿ %@",strSpecialPrice];
            }
            else
            {
                NSString *strPrice = [Utility formatDecimal:menu.price withMinFraction:2 andMaxFraction:2];
                strPrice = [NSString stringWithFormat:@"฿ %@",strPrice];
                UIFont *font = [UIFont systemFontOfSize:15];
                NSDictionary *attribute = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strPrice attributes:attribute];
                cell.lblPrice.attributedText = attrString;
                cell.lblSpecialPrice.text = @"";
            }
            
            
            NSString *imageFileName = [Utility isStringEmpty:menu.imageUrl]?@"NoImage.jpg":menu.imageUrl;
            NSLog(@"image file name: %@" , imageFileName);
            [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     NSLog(@"succeed");
                     cell.imgMenuPic.image = image;
                 }
             }];
            cell.imgMenuPic.contentMode = UIViewContentModeScaleAspectFit;
            NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
            NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:orderTakingList];
            if([orderTakingListWithMenuID count]==0)
            {
                cell.imgTriangle.hidden = YES;
            }
            else
            {
                cell.imgTriangle.hidden = NO;
                cell.lblQuantity.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
            }
            
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return SEARCH_BAR_HEIGHT;
    }
    else
    {
        return 90;
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
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 1)
        {
            //add ordertaking
            MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
            NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
            Menu *menu = menuList[item];
            SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
            float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
            
            
            NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
            OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
            [OrderTaking addObject:orderTaking];
            [orderTakingList addObject:orderTaking];
            
            
            [tbvMenu reloadData];
            [self updateTotalAmount];
            [self blinkAddedNotiView];
        }
    }
}

-(void)itemsDownloaded:(NSArray *)items
{
    _menuList = [items[0] mutableCopy];
    _menuTypeList = [items[1] mutableCopy];
    _menuTypeNoteList = [items[2] mutableCopy];
    _noteList = [items[3] mutableCopy];
    _noteTypeList = [items[4] mutableCopy];
    _subMenuTypeList = [items[5] mutableCopy];
    _specialPriceProgramList = [items[6] mutableCopy];
    _menuTypeList = [MenuType sortList:_menuTypeList];
    
    
    _menuList = [Menu setBranchID:branch.branchID menuList:_menuList];
    _filterMenuList = _menuList;
    [Menu setCurrentMenuList:_menuList];

    
    [Menu addListCheckDuplicate:_menuList];//ต้องเฉพาะไม่ซ้ำ
    [MenuType setSharedData:_menuTypeList];
    [MenuTypeNote setSharedData:_menuTypeNoteList];
    [Note setSharedData:_noteList];
    [NoteType setSharedData:_noteTypeList];
    [SubMenuType setSharedData:_subMenuTypeList];
    [SpecialPriceProgram setSharedData:_specialPriceProgramList];
    
    
    
    [self setData];
    [self removeOverlayViews];
}

-(void)setData
{
    [self createHorizontalScroll];
    [tbvMenu reloadData];
    if([_menuTypeList count]>0)
    {
        MenuType *menuType = _menuTypeList[0];
        NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
        if([menuList count]>0)
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    else
    {
        [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)createHorizontalScroll
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    scrollView.delegate = self;
    int buttonX = 15;
    for (int i = 0; i < [_menuTypeList count]; i++)
    {
        MenuType *menuType = _menuTypeList[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, 100, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        if(i==0)
        {
            [button setTitleColor:mOrange forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        [button setTitle:menuType.name forState:UIControlStateNormal];
        [button sizeToFit];
        [scrollView addSubview:button];
        buttonX = 15 + buttonX+button.frame.size.width;
        [button addTarget:self action:@selector(menuTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        
        CGRect frame = button.frame;
        frame.size.height = 2;
        frame.origin.y = button.frame.origin.y + button.frame.size.height-2;
    
        UIView *highlightBottomBorder = [[UIView alloc]initWithFrame:frame];
        highlightBottomBorder.backgroundColor = mGreen;
        highlightBottomBorder.tag = i+1+100;
        highlightBottomBorder.hidden = i!=0;
        [scrollView addSubview:highlightBottomBorder];
    }
    
    scrollView.contentSize = CGSizeMake(buttonX, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
}

-(void)menuTypeSelected:(UIButton*)sender
{
    UIButton *button = sender;
    _selectedMenuTypeIndex = button.tag-1;
    
    
    for(int i=1; i<=[_menuTypeList count]; i++)
    {
        UIButton *eachButton = [self.view viewWithTag:i];
        [eachButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        UIView *highlightBottomBorder = [self.view viewWithTag:i+100];
        highlightBottomBorder.hidden = YES;
    }
    
    
    [button setTitleColor:mOrange forState:UIControlStateNormal];
    UIView *highlightBottomBorder = [self.view viewWithTag:button.tag+100];
    highlightBottomBorder.hidden = NO;
    
    
    
    

    [tbvMenu reloadData];
    if([_menuTypeList count]>0)
    {
        MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
        NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
        if([menuList count]>0)
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    else
    {
        [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)updateTotalAmount
{
    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    lblTotalQuantity.text = [NSString stringWithFormat:@"%ld",[orderTakingList count]];
    lblTotalQuantityTop.text = [orderTakingList count]==0?@"":[NSString stringWithFormat:@"%ld",[orderTakingList count]];
    
    
    NSString *strTotal = [Utility formatDecimal:[OrderTaking getSubTotalAmount:orderTakingList] withMinFraction:2 andMaxFraction:2];
    strTotal = [Utility addPrefixBahtSymbol:strTotal];
    lblTotalAmount.text = strTotal;
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterMenuList = _menuList;
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvMenu reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_titleThai contains[c] %@) or (_price = %f)", searchText, [Utility floatValue:searchText]];
        _filterMenuList = [[_menuList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:@""];
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvMenu reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        // if text length == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self cancelSearching];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    //    [self.searchBar setShowsCancelButton:YES animated:YES];
    UISearchBar *sbText = [self.view viewWithTag:300];
    [sbText setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
    UISearchBar *sbText = [self.view viewWithTag:300];
    [sbText setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    UISearchBar *sbText = [self.view viewWithTag:300];
    self.searchBarActive = NO;
    [sbText resignFirstResponder];
    sbText.text  = @"";
    [self filterContentForSearchText:sbText.text scope:@""];
    
}
@end
