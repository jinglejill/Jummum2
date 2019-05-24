//
//  Menu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 27/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Receipt.h"
#import "MenuForBuffet.h"
#import "MenuForAlacarte.h"


@interface Menu : NSObject
@property (nonatomic) NSInteger menuID;
@property (retain, nonatomic) NSString * menuCode;
@property (retain, nonatomic) NSString * titleThai;
@property (nonatomic) float price;
@property (nonatomic) NSInteger menuTypeID;
@property (nonatomic) NSInteger subMenuTypeID;
@property (nonatomic) NSInteger buffetMenu;
@property (nonatomic) NSInteger alacarteMenu;
@property (nonatomic) NSInteger timeToOrder;
@property (nonatomic) NSInteger recommended;
@property (nonatomic) NSInteger recommendedOrderNo;
@property (retain, nonatomic) NSString * imageUrl;
@property (retain, nonatomic) NSString * color;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) NSInteger menuOrderNo;
@property (nonatomic) NSInteger subMenuOrderNo;
@property (nonatomic) NSInteger expand;
@property (nonatomic) NSInteger branchID;
@property (nonatomic) float specialPrice;


-(Menu *)initWithMenuCode:(NSString *)menuCode titleThai:(NSString *)titleThai price:(float)price menuTypeID:(NSInteger)menuTypeID subMenuTypeID:(NSInteger)subMenuTypeID buffetMenu:(NSInteger)buffetMenu alacarteMenu:(NSInteger)alacarteMenu timeToOrder:(NSInteger)timeToOrder recommended:(NSInteger)recommended recommendedOrderNo:(NSInteger)recommendedOrderNo imageUrl:(NSString *)imageUrl color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status remark:(NSString *)remark;

+(NSInteger)getNextID;
+(void)addObject:(Menu *)menu;
+(void)removeObject:(Menu *)menu;
+(void)addList:(NSMutableArray *)menuList;
+(void)removeList:(NSMutableArray *)menuList;
+(Menu *)getMenu:(NSInteger)menuID;
+(Menu *)getMenu:(NSInteger)menuID branchID:(NSInteger)branchID;
-(BOOL)editMenu:(Menu *)editingMenu;
+(Menu *)copyFrom:(Menu *)fromMenu to:(Menu *)toMenu;
+(NSMutableArray *)getMenuListWithMenuType:(NSInteger)menuTypeID menuList:(NSMutableArray *)menuList;
+(NSMutableArray *)sortList:(NSMutableArray *)menuList;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getMenuListWithOrderTakingList:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)getMenuListWithBranchID:(NSInteger)branchID;
+(NSMutableArray *)setBranchID:(NSInteger)branchID menuList:(NSMutableArray *)menuList;
+(MenuForAlacarte *)getCurrentMenuList;
+(void)setCurrentMenuList:(MenuForAlacarte *)menuForAlacarte;
+(void)removeCurrentMenuList;
+(MenuForBuffet *)getCurrentMenuForBuffet;
+(void)setCurrentMenuForBuffet:(MenuForBuffet *)menuForBuffet;
+(void)removeCurrentMenuForBuffet;
+(NSMutableArray *)getMenuListRecommendedWithMenuList:(NSMutableArray *)menuList;
+(BOOL)hasRecommendedMenuWithMenuList:(NSMutableArray *)menuList;
@end
