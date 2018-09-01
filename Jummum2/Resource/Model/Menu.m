//
//  Menu.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 27/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Menu.h"
#import "MenuType.h"
#import "SubMenuType.h"
#import "OrderTaking.h"
#import "SharedMenu.h"
#import "SharedCurrentMenu.h"
#import "SharedMenuForBuffet.h"
#import "Utility.h"
#import "Receipt.h"



@implementation Menu

-(Menu *)initWithMenuCode:(NSString *)menuCode titleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID subMenuType2ID:(NSInteger)subMenuType2ID subMenuType3ID:(NSInteger)subMenuType3ID buffetMenu:(NSInteger)buffetMenu belongToMenuID:(NSInteger)belongToMenuID timeToOrder:(NSInteger)timeToOrder imageUrl:(NSString *)imageUrl color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark
{
    self = [super init];
    if(self)
    {
        self.menuID = [Menu getNextID];
        self.menuCode = menuCode;
        self.titleThai = titleThai;
        self.price = price;
        self.menuTypeID = menuTypeID;
        self.subMenuTypeID = subMenuTypeID;
        self.subMenuType2ID = subMenuType2ID;
        self.subMenuType3ID = subMenuType3ID;
        self.buffetMenu = buffetMenu;
        self.belongToMenuID = belongToMenuID;
        self.timeToOrder = timeToOrder;
        self.imageUrl = imageUrl;
        self.color = color;
        self.orderNo = orderNo;
        self.status = status;
        self.remark = remark;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList addObject:menu];
}

+(void)removeObject:(Menu *)menu
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList removeObject:menu];
}

+(void)addList:(NSMutableArray *)menuList
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList addObjectsFromArray:menuList];
}

+(void)removeList:(NSMutableArray *)menuList
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    [dataList removeObjectsInArray:menuList];
}

+(Menu *)getMenu:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Menu *)copy).menuID = self.menuID;
        [copy setMenuCode:self.menuCode];
        [copy setTitleThai:self.titleThai];
        ((Menu *)copy).price = self.price;
        ((Menu *)copy).menuTypeID = self.menuTypeID;
        ((Menu *)copy).subMenuTypeID = self.subMenuTypeID;
        ((Menu *)copy).subMenuType2ID = self.subMenuType2ID;
        ((Menu *)copy).subMenuType3ID = self.subMenuType3ID;
        ((Menu *)copy).buffetMenu = self.buffetMenu;
        ((Menu *)copy).belongToMenuID = self.belongToMenuID;
        ((Menu *)copy).timeToOrder = self.timeToOrder;
        [copy setImageUrl:self.imageUrl];
        [copy setColor:self.color];
        ((Menu *)copy).orderNo = self.orderNo;
        ((Menu *)copy).status = self.status;
        [copy setRemark:self.remark];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editMenu:(Menu *)editingMenu
{
    if(self.menuID == editingMenu.menuID
       && [self.menuCode isEqualToString:editingMenu.menuCode]
       && [self.titleThai isEqualToString:editingMenu.titleThai]
       && self.price == editingMenu.price
       && self.menuTypeID == editingMenu.menuTypeID
       && self.subMenuTypeID == editingMenu.subMenuTypeID
       && self.subMenuType2ID == editingMenu.subMenuType2ID
       && self.subMenuType3ID == editingMenu.subMenuType3ID
       && self.buffetMenu == editingMenu.buffetMenu
       && self.belongToMenuID == editingMenu.belongToMenuID
       && self.timeToOrder == editingMenu.timeToOrder
       && [self.imageUrl isEqualToString:editingMenu.imageUrl]
       && [self.color isEqualToString:editingMenu.color]
       && self.orderNo == editingMenu.orderNo
       && self.status == editingMenu.status
       && [self.remark isEqualToString:editingMenu.remark]
       )
    {
        return NO;
    }
    return YES;
}

+(Menu *)copyFrom:(Menu *)fromMenu to:(Menu *)toMenu
{
    toMenu.menuID = fromMenu.menuID;
    toMenu.menuCode = fromMenu.menuCode;
    toMenu.titleThai = fromMenu.titleThai;
    toMenu.price = fromMenu.price;
    toMenu.menuTypeID = fromMenu.menuTypeID;
    toMenu.subMenuTypeID = fromMenu.subMenuTypeID;
    toMenu.subMenuType2ID = fromMenu.subMenuType2ID;
    toMenu.subMenuType3ID = fromMenu.subMenuType3ID;
    toMenu.buffetMenu = fromMenu.buffetMenu;
    toMenu.belongToMenuID = fromMenu.belongToMenuID;
    toMenu.timeToOrder = fromMenu.timeToOrder;
    toMenu.imageUrl = fromMenu.imageUrl;
    toMenu.color = fromMenu.color;
    toMenu.orderNo = fromMenu.orderNo;
    toMenu.status = fromMenu.status;
    toMenu.remark = fromMenu.remark;
    toMenu.modifiedUser = [Utility modifiedUser];
    toMenu.modifiedDate = [Utility currentDateTime];
    
    return toMenu;
}

+(Menu *)getMenu:(NSInteger)menuID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld and _branchID = %ld",menuID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getMenuListWithMenuType:(NSInteger)menuTypeID menuList:(NSMutableArray *)menuList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [menuList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *sortArray = [self sortList:[filterArray mutableCopy]];
    return sortArray;
}

+(NSMutableArray *)sortList:(NSMutableArray *)menuList
{
    for(Menu *item in menuList)
    {
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:item.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
        MenuType *menuType = [MenuType getMenuType:item.menuTypeID];
        item.menuOrderNo = menuType.orderNo;
        
        
        //        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscount:item.orderTakingID];
        //        item.cancelDiscountReason = orderCancelDiscount?orderCancelDiscount.reason:@"";
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_menuID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4, nil];
    NSArray *sortArray = [menuList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedMenu sharedMenu].menuList = dataList;
}

+(NSMutableArray *)getMenuListWithOrderTakingList:(NSMutableArray *)orderTakingList
{
    NSSet *menuIDSet = [NSSet setWithArray:[orderTakingList valueForKey:@"_menuID"]];
    
    
    NSInteger branchID = 0;
    if([orderTakingList count]>0)
    {
        OrderTaking *orderTaking = orderTakingList[0];
        branchID = orderTaking.branchID;
    }
    NSMutableArray *menuList = [[NSMutableArray alloc]init];
    for(NSNumber *item in menuIDSet)
    {
        Menu *menu = [Menu getMenu:[item integerValue] branchID:branchID];
        [menuList addObject:menu];
    }
    
    menuList = [Menu sortList:menuList];
    return menuList;
}

+(NSMutableArray *)getMenuListWithBranchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)setBranchID:(NSInteger)branchID menuList:(NSMutableArray *)menuList
{
    for(Menu *item in menuList)
    {
        item.branchID = branchID;
    }
    
    return menuList;
}

+(NSMutableArray *)getCurrentMenuList
{
    NSMutableArray *dataList = [SharedCurrentMenu SharedCurrentMenu].menuList;
    return dataList;
}

+(void)setCurrentMenuList:(NSMutableArray *)menuList
{
    [SharedCurrentMenu SharedCurrentMenu].menuList = menuList;
}

+(void)removeCurrentMenuList
{
    NSMutableArray *dataList = [SharedCurrentMenu SharedCurrentMenu].menuList;
    [dataList removeAllObjects];
}

+(MenuForBuffet *)getCurrentMenuForBuffet
{
    MenuForBuffet *menuForBuffet = [SharedMenuForBuffet sharedMenuForBuffet].menuForBuffet;
    return menuForBuffet;
}

+(void)setCurrentMenuForBuffet:(MenuForBuffet *)menuForBuffet
{
    [SharedMenuForBuffet sharedMenuForBuffet].menuForBuffet = menuForBuffet;
}

+(void)removeCurrentMenuForBuffet
{
    MenuForBuffet *menuForBuffet = [SharedMenuForBuffet sharedMenuForBuffet].menuForBuffet;
    menuForBuffet = nil;
}

+(NSMutableArray *)getMenuListALaCarteWithBranchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld and _belongToMenuID = 0",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getMenuListBuffetWithReceipt:(Receipt *)receipt
{
    NSMutableArray *buffetMenuList = [[NSMutableArray alloc]init];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID branchID:item.branchID];
        if(menu.buffetMenu)
        {
            [buffetMenuList addObject:menu];
        }
    }
    return buffetMenuList;
}

+(NSMutableArray *)getMenuListBelongToBuffetWithBuffetMenuList:(NSMutableArray *)buffetMenuList
{
    NSMutableArray *belongToBuffetMenuList = [[NSMutableArray alloc]init];
    for(Menu *item in buffetMenuList)
    {
        NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld and _belongToMenuID = %ld",item.branchID,item.menuID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        
        [belongToBuffetMenuList addObjectsFromArray:filterArray];
    }
    
    return belongToBuffetMenuList;
}

+(NSMutableArray *)getMenuBelongToBuffet:(Receipt *)receipt
{
    NSMutableSet *menuSet = [[NSMutableSet alloc]init];
    NSMutableSet *menuBelongToBuffetSet = [[NSMutableSet alloc]init];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID branchID:item.branchID];
        [menuSet addObject:menu];
    }
    
    for(Menu *item in menuSet)
    {
        if(item.buffetMenu)
        {
            NSMutableArray *dataList = [SharedMenu sharedMenu].menuList;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld and _belongToMenuID = %ld and status = 1",item.branchID,item.menuID];
            NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
            
            [menuBelongToBuffetSet addObjectsFromArray:filterArray];
        }
    }
    
    return [[menuBelongToBuffetSet allObjects] mutableCopy];
}

@end
