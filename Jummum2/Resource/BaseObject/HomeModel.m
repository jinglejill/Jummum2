//
//  HomeModel.m
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/9/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//
#import <objc/runtime.h>
#import "HomeModel.h"
#import "Utility.h"
#import "PushSync.h"
#import "LogIn.h"
#import "UserAccount.h"
#import "Branch.h"
#import "Menu.h"
#import "Pic.h"
#import "MenuPic.h"
#import "Receipt.h"
#import "OrderTaking.h"
#import "OrderNote.h"
#import "UserPromotionUsed.h"
#import "RewardPoint.h"
#import "FacebookComment.h"
#import "HotDeal.h"
#import "RewardRedemption.h"
#import "PromoCode.h"
#import "Message.h"
#import "UserRewardRedemptionUsed.h"
#import "DisputeReason.h"
#import "Dispute.h"
#import "Comment.h"
#import "RecommendShop.h"
#import "Rating.h"
#import "MenuNote.h"
#import "LuckyDrawTicket.h"
#import "DiscountGroupMenuMap.h"
#import "BuffetMenuMap.h"
#import "EncryptedMessage.h"
#import "SaveReceipt.h"
#import "SaveOrderTaking.h"
#import "SaveOrderNote.h"
#import "CreditCardAndOrderSummary.h"
#import "GBPrimeQr.h"
#import "TransferForm.h"
#import "Bank.h"
#import "CustomViewController.h"



@interface HomeModel()
{
    NSMutableData *_downloadedData;
    BOOL _downloadSuccess;
}
@end
@implementation HomeModel
@synthesize propCurrentDB;
@synthesize propCurrentDBInsert;
@synthesize propCurrentDBUpdate;


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(!error)
    {
        NSLog(@"Download is Successful");
        switch (propCurrentDB) {
            case dbMasterWithProgressBar:
            case dbMaster:
                if(!_downloadSuccess)//กรณีไม่มี content length จึงไม่รู้ว่า datadownload/downloadsize = 1 -> _downloadSuccess จึงไม่ถูก set เป็น yes
                {
                    NSLog(@"content length = -1");
                    [self prepareData];
                }
                break;
                
                
            default:
                break;
        }
    }
    else
    {
        NSLog(@"Error %@",[error userInfo]);
        if (self.delegate)
        {
            [self.delegate connectionFail];
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)dataRaw;
{
    NSArray *arrClassName;
    switch (propCurrentDB)
    {
        case dbMaster:
        case dbMasterWithProgressBar:
        {
            [_dataToDownload appendData:dataRaw];
            if(propCurrentDB == dbMasterWithProgressBar)
            {
                if(self.delegate)
                {
                    [self.delegate downloadProgress:[_dataToDownload length ]/_downloadSize];
                }
            }
            
            
            if([ _dataToDownload length ]/_downloadSize == 1.0f)
            {
                _downloadSuccess = YES;
                [self prepareData];
            }
        }
            break;
        case dbMenu:
        {
            arrClassName = @[@"Message",@"Menu",@"SpecialPriceProgram",@"DiscountGroupMenuMap"];
        }
            break;
        case dbMenuList:
        {
            arrClassName = @[@"Message",@"Menu",@"MenuType",@"SpecialPriceProgram",@"Setting"];
        }
            break;
        case dbMenuBelongToBuffet:
        {
            arrClassName = @[@"Message",@"Menu",@"MenuType",@"SpecialPriceProgram",@"Receipt"];
        }
            break;
        case dbMenuNoteList:
        {
            arrClassName = @[@"MenuNote",@"Note",@"NoteType"];
        }
            break;
        case dbCustomerTable:
        {
            arrClassName = @[@"CustomerTable",@"Zone"];
        }
            break;
        case dbReceiptSummaryPage:
        case dbOrderJoining:
        {
            arrClassName = @[@"Receipt",@"CustomerTable",@"Branch",@"OrderTaking",@"Menu",@"OrderNote",@"Note"];
        }
            break;
        case dbPromotion:
        {
            arrClassName = @[@"Message",@"Message",@"OrderTaking",@"OrderNote",@"Promotion",@"CreditCardAndOrderSummary"];
        }
            break;
        case dbPromotionAndRewardRedemption:
        {
            arrClassName = @[@"Promotion",@"RewardRedemption"];
        }
            break;
        case dbUserAccount:
        {
            arrClassName = @[@"UserAccount"];
        }
            break;
        case dbRewardPoint:
        {
            arrClassName = @[@"RewardPoint",@"RewardRedemption",@"Branch"];
        }
            break;
        case dbHotDeal:
        {
            arrClassName = @[@"Promotion",@"Branch"];
        }
            break;
        case dbRewardPointSpent:
        case dbRewardPointSpentMore:
        case dbRewardPointSpentUsed:
        case dbRewardPointSpentUsedMore:
        case dbRewardPointSpentExpired:
        case dbRewardPointSpentExpiredMore:
        {
            arrClassName = @[@"RewardPoint",@"PromoCode",@"RewardRedemption"];
        }
            break;
        case dbReceipt:
        {
            arrClassName = @[@"Receipt"];
        }
            break;
        case dbReceiptDisputeRating:
        case dbReceiptDisputeRatingUpdateAndReload:
        case dbReceiptBuffetEnded:
        {
            arrClassName = @[@"Receipt",@"Dispute",@"Rating",@"OrderTaking",@"OrderNote",@"Menu",@"DisputeReason"];
        }
            break;
        case dbDisputeReasonList:
        {
            arrClassName = @[@"DisputeReason"];
        }
            break;
        case dbDisputeList:
        {
            arrClassName = @[@"Dispute"];
        }
        break;
//        case dbBranch:
        case dbBranchAndCustomerTableQR:
        case dbOrderItAgain:
        {
            arrClassName = @[@"Branch",@"CustomerTable",@"SaveReceipt",@"SaveOrderTaking",@"SaveOrderNote",@"Receipt",@"Note"];
        }
            break;
        case dbBranchSearch:
        {
            arrClassName = @[@"Branch"];
        }
            break;
        case dbSettingWithKey:
        {
            arrClassName = @[@"Setting"];
        }
        break;
        case dbRewardRedemptionLuckyDraw:
        {
            arrClassName = @[@"RewardRedemption",@"LuckyDrawTicket"];
        }
            break;
        case dbOrderJoiningShareQr:
        {
            arrClassName = @[@"EncryptedMessage"];
        }
            break;
        case dbReceiptAndLuckyDraw:
        {
            arrClassName = @[@"Receipt", @"LuckyDrawTicket"];
        }
            break;
        case dbBankList:
        {
            arrClassName = @[@"Bank"];
        }
            break;
        case dbTransferFormAndBankList:
        {
            arrClassName = @[@"TransferForm",@"Bank"];
        }
            break;
        default:
            break;
    }
    if(propCurrentDB != dbMaster && propCurrentDB != dbMasterWithProgressBar)
    {
        [_dataToDownload appendData:dataRaw];
        if([ _dataToDownload length ]/_downloadSize == 1.0f)
        {
            NSMutableArray *arrItem = [[NSMutableArray alloc] init];
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
            NSString *status = dicJson[@"status"];
            if([status integerValue] == 3)
            {
                CustomViewController *vc = (CustomViewController *)self.delegate;
                [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
            }
            else
            {
                NSArray *jsonArray = dicJson[@"data"];
                BOOL success = [dicJson[@"success"] boolValue];
                if(!success)
                {
                    NSString *error = dicJson[@"error"];
                    CustomViewController *vc = (CustomViewController *)self.delegate;
                    [vc removeOverlayViews];
                    [vc showAlert:@"" message:error];
                    
                    if(self.delegate)//luckyDraw
                    {
                        [self.delegate itemsDownloaded:arrItem manager:self];
                    }
                    
                    return;
                }
                
                if(!jsonArray)
                {
                    return;
                }
                
                for(int i=0; i<[jsonArray count]; i++)
                {
                    //arrdatatemp <= arrdata
                    NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
                    NSArray *arrData = jsonArray[i];
                    for(int j=0; j< arrData.count; j++)
                    {
                        NSDictionary *jsonElement = arrData[j];
                        NSObject *object = [[NSClassFromString([Utility getMasterClassName:i from:arrClassName]) alloc] init];
                        
                        unsigned int propertyCount = 0;
                        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
                        
                        for (unsigned int i = 0; i < propertyCount; ++i)
                        {
                            objc_property_t property = properties[i];
                            const char * name = property_getName(property);
                            NSString *key = [NSString stringWithUTF8String:name];
                            
                            
                            NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                            if(!jsonElement[dbColumnName])
                            {
                                continue;
                            }
                            
                            
                            if([Utility isDateColumn:dbColumnName])
                            {
                                NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                                if(!date)
                                {
                                    date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd"];
                                }
                                [object setValue:date forKey:key];
                            }
                            else
                            {
                                [object setValue:jsonElement[dbColumnName] forKey:key];
                            }
                        }
                        [arrDataTemp addObject:object];
                    }
                    [arrItem addObject:arrDataTemp];
                }
                
                // Ready to notify delegate that data is ready and pass back items
                if (self.delegate)
                {
//                    if(propCurrentDB == dbHotDeal || propCurrentDB == dbReceiptSummaryPage || propCurrentDB == dbOrderJoining ||propCurrentDB == dbRewardPoint || propCurrentDB == dbReceipt || propCurrentDB == dbReceiptDisputeRating || propCurrentDB == dbReceiptDisputeRatingUpdateAndReload || propCurrentDB == dbReceiptBuffetEnded || propCurrentDB == dbMenuList || propCurrentDB == dbMenuNoteList || propCurrentDB == dbBranchAndCustomerTableQR || propCurrentDB == dbBranchSearch || propCurrentDB == dbCustomerTable || propCurrentDB == dbSettingWithKey || propCurrentDB == dbMenuBelongToBuffet || propCurrentDB == dbPromotionAndRewardRedemption || propCurrentDB == dbPromotion || propCurrentDB == dbMenu || propCurrentDB == dbRewardRedemptionLuckyDraw || propCurrentDB == dbOrderJoiningShareQr || propCurrentDB == dbOrderItAgain || propCurrentDB == dbReceiptAndLuckyDraw || propCurrentDB == dbRewardPointSpent || propCurrentDB == dbRewardPointSpentUsed || propCurrentDB == dbRewardPointSpentExpired)
//                    {
//                        [self.delegate itemsDownloaded:arrItem manager:self];
//                    }
//                    else
//                    {
//                        [self.delegate itemsDownloaded:arrItem];
//                    }
                    [self.delegate itemsDownloaded:arrItem manager:self];
                }
            }
        }
    }
}

-(void)prepareData
{
    NSLog(@"start prepare data");
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];

    
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
    NSString *status = dicJson[@"status"];
    if([status integerValue] == 3)
    {
        CustomViewController *vc = (CustomViewController *)self.delegate;
        [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
    }
    else
    {
        NSArray *jsonArray = dicJson[@"data"];
        //    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
        
        
        //check loaded data ให้ไม่ต้องใส่ data แล้ว ไปบอก delegate ว่าให้ show alert error occur, please try again
        if([jsonArray count] == 0)
        {
            if (self.delegate)
            {
                [self.delegate itemsDownloaded:arrItem];
            }
            return;
        }
        else if([jsonArray count] == 1)
        {
            NSArray *arrData = jsonArray[0];
            NSDictionary *jsonElement = arrData[0];
            
            if(jsonElement[@"Expired"])
            {
                if([jsonElement[@"Expired"] isEqualToString:@"1"])
                {
                    if (self.delegate)
                    {
                        [self.delegate applicationExpired];
                    }
                    return;
                }
            }
        }
        for(int i=0; i<[jsonArray count]; i++)
        {
            //arrdatatemp <= arrdata
            NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
            NSArray *arrData = jsonArray[i];
            for(int j=0; j< arrData.count; j++)
            {
                NSDictionary *jsonElement = arrData[j];
                NSObject *object = [[NSClassFromString([Utility getMasterClassName:i]) alloc] init];
                
                unsigned int propertyCount = 0;
                objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
                
                for (unsigned int i = 0; i < propertyCount; ++i)
                {
                    objc_property_t property = properties[i];
                    const char * name = property_getName(property);
                    NSString *key = [NSString stringWithUTF8String:name];
                    
                    
                    NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                    if(!jsonElement[dbColumnName])
                    {
                        continue;
                    }
                    
                    if([Utility isDateColumn:dbColumnName])
                    {
                        NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                        [object setValue:date forKey:key];
                    }
                    else
                    {
                        [object setValue:jsonElement[dbColumnName] forKey:key];
                    }
                }
                [arrDataTemp addObject:object];
            }
            [arrItem addObject:arrDataTemp];
        }
        NSLog(@"end prepare data");
        
        // Ready to notify delegate that data is ready and pass back items
        if (self.delegate)
        {
            [self.delegate itemsDownloaded:arrItem];
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    switch (propCurrentDB) {
        case dbMasterWithProgressBar:
        {
            if(self.delegate)
            {
                [self.delegate downloadProgress:0.0f];
            }
        }
            break;
        default:
            break;
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"expected content length httpResponse: %ld", (long)[httpResponse expectedContentLength]);
    
    NSLog(@"expected content length response: %lld",[response expectedContentLength]);
    _downloadSize=[response expectedContentLength];
    _dataToDownload=[[NSMutableData alloc]init];
}

- (void)downloadItems:(enum enumDB)currentDB
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
        case dbMaster:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMasterGet]]];
        }
        break;
        case dbMasterWithProgressBar:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMasterGet]]];
        }
        break;
        default:
        break;
    }
    

    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&lang=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Language getLanguage]];
    
    

    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}

- (void)downloadItems:(enum enumDB)currentDB withData:(NSObject *)data
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
        case dbMenuList:
        {
            Branch *branch = (Branch *)data;
            noteDataString = [NSString stringWithFormat:@"branchID=%ld",branch.branchID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMenuGetList]]];
        }
            break;
        case dbMenuBelongToBuffet:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMenuBelongToBuffetGetList]]];
        }
        break;
        case dbUserAccount:
        {
            noteDataString = [NSString stringWithFormat:@"username=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlUserAccountGet]]];
        }
            break;
        case dbRewardPoint:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *searchText = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            UserAccount *userAccount = (UserAccount *)dataList[3];
            noteDataString = [NSString stringWithFormat:@"searchText=%@&page=%ld&perPage=%ld&memberID=%ld",searchText,[objPage integerValue],[objPerPage integerValue],userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointGet]]];
        }
            break;
        case dbRewardPointSpent:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *searchText = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            UserAccount *userAccount = (UserAccount *)dataList[3];
            noteDataString = [NSString stringWithFormat:@"searchText=%@&page=%ld&perPage=%ld&memberID=%ld",searchText,[objPage integerValue],[objPerPage integerValue],userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentGetList]]];
        }
            break;
        case dbRewardPointSpentUsed:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *searchText = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            UserAccount *userAccount = (UserAccount *)dataList[3];
            noteDataString = [NSString stringWithFormat:@"searchText=%@&page=%ld&perPage=%ld&memberID=%ld",searchText,[objPage integerValue],[objPerPage integerValue],userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentUsedGetList]]];
        }
        break;
        case dbRewardPointSpentExpired:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *searchText = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            UserAccount *userAccount = (UserAccount *)dataList[3];
            noteDataString = [NSString stringWithFormat:@"searchText=%@&page=%ld&perPage=%ld&memberID=%ld",searchText,[objPage integerValue],[objPerPage integerValue],userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentExpiredGetList]]];
        }
        break;
        case dbHotDeal:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *searchText = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            UserAccount *userAccount = (UserAccount *)dataList[3];
            noteDataString = [NSString stringWithFormat:@"searchText=%@&page=%ld&perPage=%ld&memberID=%ld",searchText,[objPage integerValue],[objPerPage integerValue],userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlHotDealGetList]]];
        }
            break;
        case dbReceipt:
        {
            Receipt *receipt = (Receipt *)data;
            
            noteDataString = [Utility getNoteDataString:receipt];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptGet]]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSNumber *objType = (NSNumber *)data;
            noteDataString = [NSString stringWithFormat:@"type=%ld",[objType integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDisputeReasonGetList]]];
        }
            break;
        case dbDisputeList:
        {
            Receipt *receipt = (Receipt *)data;
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld&status=%ld",receipt.receiptID,receipt.status];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDisputeGetList]]];
        }
            break;
        case dbBranch:
        {
            NSDate *modifiedDate = (NSDate *)data;
            noteDataString = [NSString stringWithFormat:@"modifiedDate=%@",modifiedDate];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlBranchGetList]]];
        }
            break;
        case dbReceiptDisputeRating:
        case dbReceiptDisputeRatingUpdateAndReload:
        case dbReceiptBuffetEnded:
        {
            NSNumber *objReceipt = (NSNumber *)data;
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld",[objReceipt integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptDisputeRatingGet]]];
        }
            break;
        case dbBranchAndCustomerTableQR:
        {
            noteDataString = [NSString stringWithFormat:@"decryptedMessage=%@",data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlBranchAndCustomerTableQRGet]]];
        }
            break;
        case dbBranchSearch:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *searchText = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            noteDataString = [NSString stringWithFormat:@"searchText=%@&page=%ld&perPage=%ld",searchText,[objPage integerValue],[objPerPage integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlBranchSearchGetList]]];
        }
            break;
        case dbCustomerTable:
        {
            Branch *branch = (Branch *)data;
            noteDataString = [NSString stringWithFormat:@"branchID=%ld",branch.branchID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlCustomerTableGetList]]];
        }
            break;
        case dbSettingWithKey:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlSettingWithKeyGet]]];
        }
        break;
        case dbPromotionAndRewardRedemption:
        {
            NSArray *dataList = (NSArray *)data;
            Branch *branch = dataList[0];
            UserAccount *userAccount = dataList[1];
            noteDataString = [NSString stringWithFormat:@"branchID=%ld&memberID=%ld",branch.branchID,userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlPromotionAndRewardRedemption]]];
        }
            break;
        case dbMenu:
        {
            NSArray *dataList = (NSArray *)data;
            NSNumber *objBranchID = dataList[0];
            NSNumber *objDiscountGroupMenuID = dataList[1];
            noteDataString = [NSString stringWithFormat:@"branchID=%ld&discountGroupMenuID=%ld",[objBranchID integerValue],[objDiscountGroupMenuID integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMenuGet]]];
        }
            break;
        case dbRewardRedemptionLuckyDraw:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardRedemptionLuckyDrawGet]]];
        }
            break;
        case dbReceiptSummaryPage:
        {
            NSArray *dataList = (NSArray *)data;
            UserAccount *userAccount = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            
            noteDataString = [NSString stringWithFormat:@"memberID=%ld&page=%ld&perPage=%ld",userAccount.userAccountID,[objPage integerValue],[objPerPage integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptSummaryPageGetList]]];
        }
            break;
        case dbOrderJoining:
        {
            NSArray *dataList = (NSArray *)data;
            UserAccount *userAccount = dataList[0];
            NSNumber *objPage = dataList[1];
            NSNumber *objPerPage = dataList[2];
            
            noteDataString = [NSString stringWithFormat:@"memberID=%ld&page=%ld&perPage=%ld",userAccount.userAccountID,[objPage integerValue],[objPerPage integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlOrderJoiningPageGetList]]];
        }
            break;
         case dbMenuNoteList:
        {
            NSArray *dataList = (NSArray *)data;
            Branch *branch = dataList[0];
            NSNumber *objMenuID = dataList[1];
            
            noteDataString = [NSString stringWithFormat:@"branchID=%ld&menuID=%ld",branch.branchID,[objMenuID integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMenuNoteGetList]]];
        }
            break;
        case dbOrderJoiningShareQr:
        {
            NSInteger receiptID = [(NSNumber *)data integerValue];
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld",receiptID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlOrderJoiningShareQrGet]]];
        }
            break;
            
        case dbOrderItAgain:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlOrderItAgainGetList]]];
        }
            break;
        case dbReceiptAndLuckyDraw:
        {
            NSNumber *objReceiptID = (NSNumber *)data;
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld",[objReceiptID integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptAndLuckyDrawGetList]]];
        }
            break;
        case dbBankList:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlBankGetList]]];
        }
            break;
        case dbTransferFormAndBankList:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlTransferFormAndBankGetList]]];
        }
            break;
        default:
            break;
    }
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&lang=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Language getLanguage]];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (void)downloadItemsJson:(enum enumDB)currentDB withData:(NSObject *)data
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSMutableDictionary *dicData;
    switch (currentDB)
    {
        case dbPromotion:
        {
//@[voucherCode,userAccount,branch,orderTakingList,orderNoteList]
            NSArray *dataList = (NSArray *)data;
            NSString *strVoucherCode = dataList[0];
            UserAccount *userAccount = dataList[1];
            Branch *branch = dataList[2];
            NSMutableArray *orderTakingList = dataList[3];
            NSMutableArray *orderNoteList = dataList[4];
            
            
            dicData = [[NSMutableDictionary alloc]init];
            NSMutableArray *arrOrderTaking = [[NSMutableArray alloc]init];
            for(int i=0; i<[orderTakingList count]; i++)
            {
                OrderTaking *orderTaking = orderTakingList[i];
                NSDictionary *dicOrderTaking = [orderTaking dictionary];
                [arrOrderTaking addObject:dicOrderTaking];
            }
            
            NSMutableArray *arrOrderNote = [[NSMutableArray alloc]init];
            for(int i=0; i<[orderNoteList count]; i++)
            {
                OrderNote *orderNote = orderNoteList[i];
                NSDictionary *dicOrderNote = [orderNote dictionary];
                [arrOrderNote addObject:dicOrderNote];
            }
            
            [dicData setValue:arrOrderTaking forKey:@"orderTaking"];
            [dicData setValue:arrOrderNote forKey:@"orderNote"];
            [dicData setValue:strVoucherCode forKey:@"voucherCode"];
            [dicData setValue:@(userAccount.userAccountID) forKey:@"userAccountID"];
            [dicData setValue:@(branch.branchID) forKey:@"branchID"];
            
            
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlPromotionGetList]]];
        }
            break;
        default:
            break;
    }
    

    [dicData setValue:[Utility deviceToken] forKey:@"modifiedDeviceToken"];
    [dicData setValue:[Utility modifiedUser] forKey:@"modifiedUser"];
    [dicData setValue:[Language getLanguage] forKey:@"lang"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicData options:0 error:&error];
    NSLog(@"url: %@",url);
    NSLog(@"dicData: %@",dicData);
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];
//    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (void)insertItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDBInsert = currentDB;
    NSURL * url;
    NSString *noteDataString;
    switch (currentDB)
    {
        case dbWriteLog:
        {
            noteDataString = [NSString stringWithFormat:@"stackTrace=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility url:urlWriteLog]];
        }
            break;
        case dbLogIn:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLogInInsert]];
        }
            break;
        case dbLogInUserAccount:
        {
            NSArray *dataList = (NSArray *)data;
            LogIn *logIn = dataList[0];
            UserAccount *userAccount = dataList[1];
            
            noteDataString = [Utility getNoteDataString:logIn];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:userAccount]];
            url = [NSURL URLWithString:[Utility url:urlLogInUserAccountInsert]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuInsert]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuInsertList]];
        }
            break;
        case dbPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPicInsert]];
        }
            break;
        case dbPicList:
        {
            NSMutableArray *picList = (NSMutableArray *)data;
            NSInteger countPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPic=%ld",[picList count]];
            for(Pic *item in picList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPic]];
                countPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPicInsertList]];
        }
            break;
        case dbMenuPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuPicInsert]];
        }
            break;
        case dbMenuPicList:
        {
            NSMutableArray *menuPicList = (NSMutableArray *)data;
            NSInteger countMenuPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuPic=%ld",[menuPicList count]];
            for(MenuPic *item in menuPicList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuPic]];
                countMenuPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuPicInsertList]];
        }
            break;
        case dbUserAccountValidate:
        {
            NSArray *dataList = (NSArray *)data;
            UserAccount *userAccount = dataList[0];
            LogIn *logIn = dataList[1];
            noteDataString = [Utility getNoteDataString:userAccount];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:logIn]];
            url = [NSURL URLWithString:[Utility url:urlUserAccountValidate]];
        }
            break;
        case dbUserAccount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountInsert]];
        }
            break;
        case dbUserAccountForgotPassword:
        {
            noteDataString = [NSString stringWithFormat:@"username=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountForgotPasswordInsert]];
        }
            break;
        case dbRewardPoint:
        {
            NSArray *dataList = (NSArray *)data;
            RewardPoint *rewardPoint = dataList[0];
            RewardRedemption *rewardRedemption = dataList[1];
            noteDataString = [Utility getNoteDataString:rewardPoint];
            noteDataString = [NSString stringWithFormat:@"%@&rewardRedemptionID=%ld",noteDataString,rewardRedemption.rewardRedemptionID];
            url = [NSURL URLWithString:[Utility url:urlRewardPointInsert]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointInsertList]];
        }
            break;
        case dbPushReminder:
        {
            NSArray *dataList = (NSArray *)data;
            Branch *branch = dataList[0];
            Receipt *receipt = dataList[1];
            
            noteDataString = [NSString stringWithFormat:@"branchID=%ld&receiptID=%ld",branch.branchID,receipt.receiptID];
            url = [NSURL URLWithString:[Utility url:urlPushReminder]];
        }
            break;
        case dbHotDeal:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlHotDealInsert]];
        }
            break;
        case dbHotDealList:
        {
            NSMutableArray *hotDealList = (NSMutableArray *)data;
            NSInteger countHotDeal = 0;
            
            noteDataString = [NSString stringWithFormat:@"countHotDeal=%ld",[hotDealList count]];
            for(HotDeal *item in hotDealList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countHotDeal]];
                countHotDeal++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlHotDealInsertList]];
        }
            break;
        case dbRewardRedemption:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionInsert]];
        }
            break;
        case dbRewardRedemptionList:
        {
            NSMutableArray *rewardRedemptionList = (NSMutableArray *)data;
            NSInteger countRewardRedemption = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardRedemption=%ld",[rewardRedemptionList count]];
            for(RewardRedemption *item in rewardRedemptionList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardRedemption]];
                countRewardRedemption++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionInsertList]];
        }
            break;
        case dbPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPromoCodeInsert]];
        }
            break;
        case dbPromoCodeList:
        {
            NSMutableArray *promoCodeList = (NSMutableArray *)data;
            NSInteger countPromoCode = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPromoCode=%ld",[promoCodeList count]];
            for(PromoCode *item in promoCodeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPromoCode]];
                countPromoCode++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPromoCodeInsertList]];
        }
            break;
        case dbUserRewardRedemptionUsed:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedInsert]];
        }
        break;
        case dbUserRewardRedemptionUsedList:
        {
            NSMutableArray *userRewardRedemptionUsedList = (NSMutableArray *)data;
            NSInteger countUserRewardRedemptionUsed = 0;
            
            noteDataString = [NSString stringWithFormat:@"countUserRewardRedemptionUsed=%ld",[userRewardRedemptionUsedList count]];
            for(UserRewardRedemptionUsed *item in userRewardRedemptionUsedList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countUserRewardRedemptionUsed]];
                countUserRewardRedemptionUsed++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedInsertList]];
        }
        break;
        case dbDisputeReason:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonInsert]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSMutableArray *disputeReasonList = (NSMutableArray *)data;
            NSInteger countDisputeReason = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDisputeReason=%ld",[disputeReasonList count]];
            for(DisputeReason *item in disputeReasonList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDisputeReason]];
                countDisputeReason++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonInsertList]];
        }
            break;
        case dbDispute:
        {
            NSArray *dataList = (NSArray *)data;
            Dispute *dispute = dataList[0];
            Branch *branch = dataList[1];
            noteDataString = [Utility getNoteDataString:dispute];
            noteDataString = [NSString stringWithFormat:@"%@&branchID=%ld",noteDataString,branch.branchID];
            url = [NSURL URLWithString:[Utility url:urlDisputeInsert]];
        }
            break;
        case dbDisputeList:
        {
            NSMutableArray *disputeList = (NSMutableArray *)data;
            NSInteger countDispute = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDispute=%ld",[disputeList count]];
            for(Dispute *item in disputeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDispute]];
                countDispute++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeInsertList]];
        }
            break;
        case dbDisputeCancel:
        {
            NSArray *dataList = (NSArray *)data;
            Dispute *dispute = dataList[0];
            Branch *branch = dataList[1];
            noteDataString = [Utility getNoteDataString:dispute];
            noteDataString = [NSString stringWithFormat:@"%@&branchID=%ld",noteDataString,branch.branchID];
            url = [NSURL URLWithString:[Utility url:urlDisputeCancelInsert]];
        }
        break;
        case dbComment:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlCommentInsert]];
        }
            break;
        case dbCommentList:
        {
            NSMutableArray *commentList = (NSMutableArray *)data;
            NSInteger countComment = 0;
            
            noteDataString = [NSString stringWithFormat:@"countComment=%ld",[commentList count]];
            for(Comment *item in commentList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countComment]];
                countComment++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlCommentInsertList]];
        }
            break;
        case dbRecommendShop:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRecommendShopInsert]];
        }
            break;
        case dbRecommendShopList:
        {
            NSMutableArray *recommendShopList = (NSMutableArray *)data;
            NSInteger countRecommendShop = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRecommendShop=%ld",[recommendShopList count]];
            for(RecommendShop *item in recommendShopList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRecommendShop]];
                countRecommendShop++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRecommendShopInsertList]];
        }
            break;
        case dbRating:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRatingInsert]];
        }
        break;
        case dbRatingList:
        {
            NSMutableArray *ratingList = (NSMutableArray *)data;
            NSInteger countRating = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRating=%ld",[ratingList count]];
            for(Rating *item in ratingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRating]];
                countRating++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRatingInsertList]];
        }
        break;
        case dbLogOut:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLogOutInsert]];
        }
            break;
        case dbLuckyDrawTicket:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLuckyDrawTicketInsert]];
        }
            break;
        case dbLuckyDrawTicketList:
        {
            NSMutableArray *luckyDrawTicketList = (NSMutableArray *)data;
            NSInteger countLuckyDrawTicket = 0;
            
            noteDataString = [NSString stringWithFormat:@"countLuckyDrawTicket=%ld",[luckyDrawTicketList count]];
            for(LuckyDrawTicket *item in luckyDrawTicketList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countLuckyDrawTicket]];
                countLuckyDrawTicket++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlLuckyDrawTicketInsertList]];
        }
        break;
        case dbBuffetMenuMap:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBuffetMenuMapInsert]];
        }
        break;
        case dbBuffetMenuMapList:
        {
            NSMutableArray *buffetMenuMapList = (NSMutableArray *)data;
            NSInteger countBuffetMenuMap = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBuffetMenuMap=%ld",[buffetMenuMapList count]];
            for(BuffetMenuMap *item in buffetMenuMapList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBuffetMenuMap]];
                countBuffetMenuMap++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBuffetMenuMapInsertList]];
        }
        break;
        case dbOrderJoiningScanQr:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *strDecryptedMessage = dataList[0];
            NSInteger memberID = [(NSNumber *)dataList[1] integerValue];
            noteDataString = [NSString stringWithFormat:@"decryptedMessage=%@&memberID=%ld",strDecryptedMessage,memberID];
            url = [NSURL URLWithString:[Utility url:urlOrderJoiningScanQrInsert]];
        }
            break;
        case dbBank:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBankInsert]];
        }
        break;
        case dbBankList:
        {
            NSMutableArray *bankList = (NSMutableArray *)data;
            NSInteger countBank = 0;

            noteDataString = [NSString stringWithFormat:@"countBank=%ld",[bankList count]];
            for(Bank *item in bankList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBank]];
                countBank++;
            }

            url = [NSURL URLWithString:[Utility url:urlBankInsertList]];
        }
        break;
        case dbTransferForm:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTransferFormInsert]];
        }
        break;
        case dbTransferFormList:
        {
            NSMutableArray *transferFormList = (NSMutableArray *)data;
            NSInteger countTransferForm = 0;

            noteDataString = [NSString stringWithFormat:@"countTransferForm=%ld",[transferFormList count]];
            for(TransferForm *item in transferFormList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTransferForm]];
                countTransferForm++;
            }

            url = [NSURL URLWithString:[Utility url:urlTransferFormInsertList]];
        }
        break;
        default:
            break;
    }
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&lang=%@&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Language getLanguage],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))//-1005 คือ1. ตอน push notification ไม่ได้ และ2. ตอน enterbackground ตอน transaction ยังไม่เสร็จ พอ enter foreground มันจะไม่ return data มาให้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            NSString *strReturnID = json[@"returnID"];
            NSArray *dataJson = json[@"dataJson"];
            NSString *strTableName = json[@"tableName"];
            //                    NSString *action = json[@"action"];
            if([status isEqual:@"1"])
            {
                NSLog(@"insert success");
                if(strReturnID)
                {
                    if (self.delegate)
                    {
                        [self.delegate itemsInsertedWithReturnID:strReturnID];
                    }
                }
                else if(strTableName)
                {
                    NSArray *arrClassName;
                    {
                        if([strTableName isEqualToString:@"UserAccountValidate"] || [strTableName isEqualToString:@"LogInUserAccount"])
                        {
                            arrClassName = @[@"UserAccount"];
                        }
                        else if([strTableName isEqualToString:@"UserAccountForgotPassword"])
                        {
                            arrClassName = @[@"UserAccount"];
                        }
                        else if([strTableName isEqualToString:@"RewardPoint"])
                        {
                            arrClassName = @[@"PromoCode"];
                        }
                        else if([strTableName isEqualToString:@"Receipt"])
                        {
                            arrClassName = @[@"Receipt",@"Dispute"];
                        }
                        else if([strTableName isEqualToString:@"Rating"])
                        {
                            arrClassName = @[@"Rating"];
                        }
                        else if([strTableName isEqualToString:@"OrderJoining"])
                        {
                            arrClassName = @[@"OrderJoining",@"Message"];
                        }
                        
                        NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                        if(self.delegate)
                        {
                            [self.delegate itemsInsertedWithReturnData:items];
                        }
                    }
                }
                else
                {
                    if(self.delegate)
                    {
                        [self.delegate itemsInserted];
                    }
                }
            }
            else if([status isEqual:@"2"])
            {
                //alertMsg
                if(self.delegate)
                {
                    NSString *msg = json[@"msg"];
                    [self.delegate alertMsg:msg];
                    [(CustomViewController *)self.delegate removeOverlayViews];
                    NSLog(@"status: %@", status);
                    NSLog(@"msg: %@", msg);
                }
            }
            else if([status isEqual:@"3"])
            {
                CustomViewController *vc = (CustomViewController *)self.delegate;
                [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
            }
            else
            {
                //Error
                NSLog(@"insert fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)insertItemsJson:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDBInsert = currentDB;
    NSURL * url;
    NSData *jsonData;
    switch (currentDB)
    {
        case dbOmiseCheckOut:
        {
//            @[[token tokenId],receipt,orderTakingList,orderNoteList,_selectedVoucherCode]
            NSArray *dataList = (NSArray *)data;
            NSString *omiseToken = dataList[0];
            Receipt *receipt = dataList[1];
            NSMutableArray *orderTakingList = dataList[2];
            NSMutableArray *orderNoteList = dataList[3];
            NSString *voucherCode = dataList[4];


            NSDictionary *dicData = [receipt dictionary];
            NSMutableArray *arrOrderTaking = [[NSMutableArray alloc]init];
            for(int i=0; i<[orderTakingList count]; i++)
            {
                OrderTaking *orderTaking = orderTakingList[i];
                NSDictionary *dicOrderTaking = [orderTaking dictionary];
                [arrOrderTaking addObject:dicOrderTaking];
            }
            NSMutableArray *arrOrderNote = [[NSMutableArray alloc]init];
            for(int i=0; i<[orderNoteList count]; i++)
            {
                OrderNote *orderNote = orderNoteList[i];
                NSDictionary *dicOrderNote = [orderNote dictionary];
                [arrOrderNote addObject:dicOrderNote];
            }

            NSMutableArray *mutDicData = [dicData mutableCopy];
            [mutDicData setValue:omiseToken forKey:@"omiseToken"];
            [mutDicData setValue:arrOrderTaking forKey:@"orderTaking"];
            [mutDicData setValue:arrOrderNote forKey:@"orderNote"];
            [mutDicData setValue:voucherCode forKey:@"voucherCode"];
            
            
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:mutDicData options:0 error:&error];
            
            url = [NSURL URLWithString:[Utility url:urlOmiseCheckOut]];
        }
            break;
        case dbSaveOrder:
        {
            NSArray *dataList = (NSArray *)data;
            SaveReceipt *saveReceipt = dataList[0];
            NSMutableArray *saveOrderTakingList = dataList[1];
            NSMutableArray *saveOrderNoteList = dataList[2];
            
            
            NSDictionary *dicData = [saveReceipt dictionary];
            NSMutableArray *arrSaveOrderTaking = [[NSMutableArray alloc]init];
            for(int i=0; i<[saveOrderTakingList count]; i++)
            {
                SaveOrderTaking *saveOrderTaking = saveOrderTakingList[i];
                NSDictionary *dicSaveOrderTaking = [saveOrderTaking dictionary];
                [arrSaveOrderTaking addObject:dicSaveOrderTaking];
            }
            NSMutableArray *arrSaveOrderNote = [[NSMutableArray alloc]init];
            for(int i=0; i<[saveOrderNoteList count]; i++)
            {
                SaveOrderNote *saveOrderNote = saveOrderNoteList[i];
                NSDictionary *dicSaveOrderNote = [saveOrderNote dictionary];
                [arrSaveOrderNote addObject:dicSaveOrderNote];
            }
            
            NSMutableArray *mutDicData = [dicData mutableCopy];
            [mutDicData setValue:arrSaveOrderTaking forKey:@"saveOrderTaking"];
            [mutDicData setValue:arrSaveOrderNote forKey:@"saveOrderNote"];
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:mutDicData options:0 error:&error];
            
            url = [NSURL URLWithString:[Utility url:urlSaveOrderInsertList]];
        }
            break;
        default:
            break;
    }

    NSLog(@"url: %@",url);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:jsonData];

    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))//-1005 คือ1. ตอน push notification ไม่ได้ และ2. ตอน enterbackground ตอน transaction ยังไม่เสร็จ พอ enter foreground มันจะไม่ return data มาให้
        {
            switch (propCurrentDB)
            {
                default:
                {
                    if(!dataRaw)
                    {
                        //data parameter is nil
                        NSLog(@"Error: %@", [error debugDescription]);
                        return ;
                    }
                    
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:dataRaw
                                          options:kNilOptions error:&error];
                    NSString *status = json[@"status"];
                    NSString *strReturnID = json[@"returnID"];
                    NSArray *dataJson = json[@"dataJson"];
                    NSString *strTableName = json[@"tableName"];
                    //                    NSString *action = json[@"action"];
                    if([status isEqual:@"1"])
                    {
                        NSLog(@"insert success");
                        if(strReturnID)
                        {
                            if (self.delegate)
                            {
                                [self.delegate itemsInsertedWithReturnID:strReturnID];
                            }
                        }
                        else if(strTableName)
                        {
                            NSArray *arrClassName;
                            if([strTableName isEqualToString:@"OmiseCheckOut"])
                            {
                                arrClassName = @[@"Message",@"Message",@"OrderTaking",@"OrderNote",@"Promotion",@"CreditCardAndOrderSummary",@"Message",@"Receipt",@"OrderTaking",@"OrderNote",@"LuckyDrawTicket"];
                            }
                            else if([strTableName isEqualToString:@"BuffetOrder"])
                            {
                                arrClassName = @[@"Receipt",@"OrderTaking",@"OrderNote"];
                            }
                            else if([strTableName isEqualToString:@"EncryptedMessage"])
                            {
                                arrClassName = @[@"EncryptedMessage"];
                            }
                            
                            NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                            if(self.delegate)
                            {
                                [self.delegate itemsInsertedWithReturnData:items];
                            }
                        }
                        else
                        {
                            if(self.delegate)
                            {
                                [self.delegate itemsInserted];
                            }
                        }
                    }
                    else if([status isEqual:@"2"])
                    {
                        //alertMsg
                        if(self.delegate)
                        {
                            NSArray *arrClassName;
                            NSMutableArray *mutItems;
                            NSString *msg = json[@"msg"];
                            NSArray *dataJson = json[@"dataJson"];
                            NSString *strTableName = json[@"tableName"];
                        
                            if([strTableName isEqualToString:@"Order"])
                            {
                                arrClassName = @[@"OrderTaking",@"OrderNote",@"Setting"];
                            }
                            else if([strTableName isEqualToString:@"OrderBelongToBuffet"])
                            {
                                arrClassName = @[@"OrderTaking",@"OrderNote"];
                            }
                            
                            //data
                            NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                            mutItems = [items mutableCopy];
                            
                        
                            //message
                            NSMutableArray *messgeList = [[NSMutableArray alloc]init];
                            Message *message = [[Message alloc]init];
                            message.text = msg;
                            [messgeList addObject:message];
                        
                        
                            [mutItems insertObject:messgeList atIndex:0];
                            [self.delegate itemsInsertedWithReturnData:mutItems];
                            NSLog(@"msg: %@", msg);
                        
                        }
                    }
                    else if([status isEqual:@"3"])
                    {
                        CustomViewController *vc = (CustomViewController *)self.delegate;
                        [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
                    }
                    else
                    {
                        //Error
                        NSLog(@"insert fail: %ld",currentDB);
                        NSLog(@"%@", status);
                        if (self.delegate)
                        {
                            [self.delegate itemsFail];
                        }
                    }
                }
                    break;
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)updateItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDBUpdate = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB)
    {
        case dbPushSyncUpdateTimeSynced:
        {
            NSMutableArray *pushSyncList = (NSMutableArray *)data;
            NSInteger countPushSync = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPushSync=%ld",[pushSyncList count]];
            for(PushSync *item in pushSyncList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPushSync]];
                countPushSync++;
            }
            url = [NSURL URLWithString:[Utility url:urlPushSyncUpdateTimeSynced]];
        }
            break;
        case dbPushSyncUpdateByDeviceToken:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPushSyncUpdateByDeviceToken]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuUpdate]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuUpdateList]];
        }
            break;
        case dbPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPicUpdate]];
        }
            break;
        case dbPicList:
        {
            NSMutableArray *picList = (NSMutableArray *)data;
            NSInteger countPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPic=%ld",[picList count]];
            for(Pic *item in picList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPic]];
                countPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPicUpdateList]];
        }
            break;
        case dbMenuPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuPicUpdate]];
        }
            break;
        case dbMenuPicList:
        {
            NSMutableArray *menuPicList = (NSMutableArray *)data;
            NSInteger countMenuPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuPic=%ld",[menuPicList count]];
            for(MenuPic *item in menuPicList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuPic]];
                countMenuPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuPicUpdateList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointUpdate]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointUpdateList]];
        }
            break;
        case dbHotDeal:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlHotDealUpdate]];
        }
            break;
        case dbHotDealList:
        {
            NSMutableArray *hotDealList = (NSMutableArray *)data;
            NSInteger countHotDeal = 0;
            
            noteDataString = [NSString stringWithFormat:@"countHotDeal=%ld",[hotDealList count]];
            for(HotDeal *item in hotDealList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countHotDeal]];
                countHotDeal++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlHotDealUpdateList]];
        }
            break;
        case dbRewardRedemption:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionUpdate]];
        }
            break;
        case dbRewardRedemptionList:
        {
            NSMutableArray *rewardRedemptionList = (NSMutableArray *)data;
            NSInteger countRewardRedemption = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardRedemption=%ld",[rewardRedemptionList count]];
            for(RewardRedemption *item in rewardRedemptionList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardRedemption]];
                countRewardRedemption++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionUpdateList]];
        }
            break;
        case dbPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPromoCodeUpdate]];
        }
            break;
        case dbPromoCodeList:
        {
            NSMutableArray *promoCodeList = (NSMutableArray *)data;
            NSInteger countPromoCode = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPromoCode=%ld",[promoCodeList count]];
            for(PromoCode *item in promoCodeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPromoCode]];
                countPromoCode++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPromoCodeUpdateList]];
        }
            break;
        case dbUserRewardRedemptionUsed:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedUpdate]];
        }
        break;
        case dbUserRewardRedemptionUsedList:
        {
            NSMutableArray *userRewardRedemptionUsedList = (NSMutableArray *)data;
            NSInteger countUserRewardRedemptionUsed = 0;
            
            noteDataString = [NSString stringWithFormat:@"countUserRewardRedemptionUsed=%ld",[userRewardRedemptionUsedList count]];
            for(UserRewardRedemptionUsed *item in userRewardRedemptionUsedList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countUserRewardRedemptionUsed]];
                countUserRewardRedemptionUsed++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedUpdateList]];
        }
        break;
        case dbDisputeReason:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonUpdate]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSMutableArray *disputeReasonList = (NSMutableArray *)data;
            NSInteger countDisputeReason = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDisputeReason=%ld",[disputeReasonList count]];
            for(DisputeReason *item in disputeReasonList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDisputeReason]];
                countDisputeReason++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonUpdateList]];
        }
            break;
        case dbDispute:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeUpdate]];
        }
            break;
        case dbDisputeList:
        {
            NSMutableArray *disputeList = (NSMutableArray *)data;
            NSInteger countDispute = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDispute=%ld",[disputeList count]];
            for(Dispute *item in disputeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDispute]];
                countDispute++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeUpdateList]];
        }
            break;
        case dbReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptUpdate]];
        }
        break;
        case dbComment:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlCommentUpdate]];
        }
            break;
        case dbCommentList:
        {
            NSMutableArray *commentList = (NSMutableArray *)data;
            NSInteger countComment = 0;
            
            noteDataString = [NSString stringWithFormat:@"countComment=%ld",[commentList count]];
            for(Comment *item in commentList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countComment]];
                countComment++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlCommentUpdateList]];
        }
            break;
        case dbRecommendShop:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRecommendShopUpdate]];
        }
            break;
        case dbRecommendShopList:
        {
            NSMutableArray *recommendShopList = (NSMutableArray *)data;
            NSInteger countRecommendShop = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRecommendShop=%ld",[recommendShopList count]];
            for(RecommendShop *item in recommendShopList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRecommendShop]];
                countRecommendShop++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRecommendShopUpdateList]];
        }
            break;
        case dbUserAccount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountUpdate]];
        }
            break;
        case dbRating:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRatingUpdate]];
        }
        break;
        case dbRatingList:
        {
            NSMutableArray *ratingList = (NSMutableArray *)data;
            NSInteger countRating = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRating=%ld",[ratingList count]];
            for(Rating *item in ratingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRating]];
                countRating++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRatingUpdateList]];
        }
        break;
        case dbLuckyDrawTicket:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLuckyDrawTicketUpdate]];
        }
            break;
        case dbLuckyDrawTicketList:
        {
            NSMutableArray *luckyDrawTicketList = (NSMutableArray *)data;
            NSInteger countLuckyDrawTicket = 0;
            
            noteDataString = [NSString stringWithFormat:@"countLuckyDrawTicket=%ld",[luckyDrawTicketList count]];
            for(LuckyDrawTicket *item in luckyDrawTicketList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countLuckyDrawTicket]];
                countLuckyDrawTicket++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlLuckyDrawTicketUpdateList]];
        }
        break;
        case dbBuffetMenuMap:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBuffetMenuMapUpdate]];
        }
        break;
        case dbBuffetMenuMapList:
        {
            NSMutableArray *buffetMenuMapList = (NSMutableArray *)data;
            NSInteger countBuffetMenuMap = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBuffetMenuMap=%ld",[buffetMenuMapList count]];
            for(BuffetMenuMap *item in buffetMenuMapList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBuffetMenuMap]];
                countBuffetMenuMap++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBuffetMenuMapUpdateList]];
        }
        break;
        case dbReceiptAndPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptAndPromoCodeUpdate]];
        }
        break;
        case dbTransferForm:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTransferFormUpdate]];
        }
        break;
        case dbTransferFormList:
        {
            NSMutableArray *transferFormList = (NSMutableArray *)data;
            NSInteger countTransferForm = 0;

            noteDataString = [NSString stringWithFormat:@"countTransferForm=%ld",[transferFormList count]];
            for(TransferForm *item in transferFormList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTransferForm]];
                countTransferForm++;
            }

            url = [NSURL URLWithString:[Utility url:urlTransferFormUpdateList]];
        }
        break;
        case dbBank:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBankUpdate]];
        }
        break;
        case dbBankList:
        {
            NSMutableArray *bankList = (NSMutableArray *)data;
            NSInteger countBank = 0;

            noteDataString = [NSString stringWithFormat:@"countBank=%ld",[bankList count]];
            for(Bank *item in bankList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBank]];
                countBank++;
            }

            url = [NSURL URLWithString:[Utility url:urlBankUpdateList]];
        }
        break;

        default:
            break;
    }
    
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&lang=%@&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Language getLanguage],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))//-1005 คือตอน push notification ไม่ได้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            NSArray *dataJson = json[@"dataJson"];
            NSString *strTableName = json[@"tableName"];
            if([status isEqual:@"1"])
            {
                NSLog(@"update success");
                if(strTableName)
                {
                    NSArray *arrClassName;
                    if([strTableName isEqualToString:@"Receipt"])
                    {
                        arrClassName = @[@"Receipt"];
                    }
                    else if([strTableName isEqualToString:@"ReceiptAndPromoCode"])
                    {
                        arrClassName = @[@"Receipt",@"Message"];
                    }
                    
                    NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                    if(self.delegate)
                    {
                        [self.delegate itemsUpdatedWithManager:self items:items];
                    }
                }
                else
                {
                    if (self.delegate)
                    {
                        [self.delegate itemsUpdated];
                    }
                }
            }
            else if([status isEqual:@"2"])
            {
                NSString *alert = json[@"alert"];
                if (self.delegate)
                {
                    [self.delegate itemsUpdated:alert];
                }
            }
            else if([status isEqual:@"3"])
            {
                CustomViewController *vc = (CustomViewController *)self.delegate;
                [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
            }
            else
            {
                //Error
                NSLog(@"update fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)deleteItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB)
    {
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuDelete]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuDeleteList]];
        }
            break;
        case dbPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPicDelete]];
        }
            break;
        case dbPicList:
        {
            NSMutableArray *picList = (NSMutableArray *)data;
            NSInteger countPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPic=%ld",[picList count]];
            for(Pic *item in picList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPic]];
                countPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPicDeleteList]];
        }
            break;
        case dbMenuPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuPicDelete]];
        }
            break;
        case dbMenuPicList:
        {
            NSMutableArray *menuPicList = (NSMutableArray *)data;
            NSInteger countMenuPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuPic=%ld",[menuPicList count]];
            for(MenuPic *item in menuPicList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuPic]];
                countMenuPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuPicDeleteList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointDelete]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointDeleteList]];
        }
            break;
        case dbHotDeal:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlHotDealDelete]];
        }
            break;
        case dbHotDealList:
        {
            NSMutableArray *hotDealList = (NSMutableArray *)data;
            NSInteger countHotDeal = 0;
            
            noteDataString = [NSString stringWithFormat:@"countHotDeal=%ld",[hotDealList count]];
            for(HotDeal *item in hotDealList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countHotDeal]];
                countHotDeal++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlHotDealDeleteList]];
        }
            break;
        case dbRewardRedemption:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionDelete]];
        }
            break;
        case dbRewardRedemptionList:
        {
            NSMutableArray *rewardRedemptionList = (NSMutableArray *)data;
            NSInteger countRewardRedemption = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardRedemption=%ld",[rewardRedemptionList count]];
            for(RewardRedemption *item in rewardRedemptionList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardRedemption]];
                countRewardRedemption++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionDeleteList]];
        }
            break;
        case dbPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPromoCodeDelete]];
        }
            break;
        case dbPromoCodeList:
        {
            NSMutableArray *promoCodeList = (NSMutableArray *)data;
            NSInteger countPromoCode = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPromoCode=%ld",[promoCodeList count]];
            for(PromoCode *item in promoCodeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPromoCode]];
                countPromoCode++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPromoCodeDeleteList]];
        }
            break;
        case dbUserRewardRedemptionUsed:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedDelete]];
        }
        break;
        case dbUserRewardRedemptionUsedList:
        {
            NSMutableArray *userRewardRedemptionUsedList = (NSMutableArray *)data;
            NSInteger countUserRewardRedemptionUsed = 0;
            
            noteDataString = [NSString stringWithFormat:@"countUserRewardRedemptionUsed=%ld",[userRewardRedemptionUsedList count]];
            for(UserRewardRedemptionUsed *item in userRewardRedemptionUsedList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countUserRewardRedemptionUsed]];
                countUserRewardRedemptionUsed++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedDeleteList]];
        }
        break;
        case dbDisputeReason:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonDelete]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSMutableArray *disputeReasonList = (NSMutableArray *)data;
            NSInteger countDisputeReason = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDisputeReason=%ld",[disputeReasonList count]];
            for(DisputeReason *item in disputeReasonList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDisputeReason]];
                countDisputeReason++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonDeleteList]];
        }
            break;
        case dbDispute:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeDelete]];
        }
            break;
        case dbDisputeList:
        {
            NSMutableArray *disputeList = (NSMutableArray *)data;
            NSInteger countDispute = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDispute=%ld",[disputeList count]];
            for(Dispute *item in disputeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDispute]];
                countDispute++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeDeleteList]];
        }
            break;
        case dbRecommendShop:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRecommendShopDelete]];
        }
            break;
        case dbRecommendShopList:
        {
            NSMutableArray *recommendShopList = (NSMutableArray *)data;
            NSInteger countRecommendShop = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRecommendShop=%ld",[recommendShopList count]];
            for(RecommendShop *item in recommendShopList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRecommendShop]];
                countRecommendShop++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRecommendShopDeleteList]];
        }
            break;
        case dbRating:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRatingDelete]];
        }
        break;
        case dbRatingList:
        {
            NSMutableArray *ratingList = (NSMutableArray *)data;
            NSInteger countRating = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRating=%ld",[ratingList count]];
            for(Rating *item in ratingList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRating]];
                countRating++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRatingDeleteList]];
        }
        break;
        case dbLuckyDrawTicket:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLuckyDrawTicketDelete]];
        }
            break;
        case dbLuckyDrawTicketList:
        {
            NSMutableArray *luckyDrawTicketList = (NSMutableArray *)data;
            NSInteger countLuckyDrawTicket = 0;
            
            noteDataString = [NSString stringWithFormat:@"countLuckyDrawTicket=%ld",[luckyDrawTicketList count]];
            for(LuckyDrawTicket *item in luckyDrawTicketList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countLuckyDrawTicket]];
                countLuckyDrawTicket++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlLuckyDrawTicketDeleteList]];
        }
        break;
        case dbBuffetMenuMap:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBuffetMenuMapDelete]];
        }
        break;
        case dbBuffetMenuMapList:
        {
            NSMutableArray *buffetMenuMapList = (NSMutableArray *)data;
            NSInteger countBuffetMenuMap = 0;
            
            noteDataString = [NSString stringWithFormat:@"countBuffetMenuMap=%ld",[buffetMenuMapList count]];
            for(BuffetMenuMap *item in buffetMenuMapList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBuffetMenuMap]];
                countBuffetMenuMap++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlBuffetMenuMapDeleteList]];
        }
        break;
        case dbTransferForm:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlTransferFormDelete]];
        }
        break;
        case dbTransferFormList:
        {
            NSMutableArray *transferFormList = (NSMutableArray *)data;
            NSInteger countTransferForm = 0;

            noteDataString = [NSString stringWithFormat:@"countTransferForm=%ld",[transferFormList count]];
            for(TransferForm *item in transferFormList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countTransferForm]];
                countTransferForm++;
            }

            url = [NSURL URLWithString:[Utility url:urlTransferFormDeleteList]];
        }
        break;
        case dbBank:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlBankDelete]];
        }
        break;
        case dbBankList:
        {
            NSMutableArray *bankList = (NSMutableArray *)data;
            NSInteger countBank = 0;

            noteDataString = [NSString stringWithFormat:@"countBank=%ld",[bankList count]];
            for(Bank *item in bankList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countBank]];
                countBank++;
            }

            url = [NSURL URLWithString:[Utility url:urlBankDeleteList]];
        }
        break;
        default:
            break;
    }
    
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(!error || (error && error.code == -1005))//-1005 คือตอน push notification ไม่ได้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                NSLog(@"delete success");
            }
            else if([status isEqual:@"3"])
            {
                CustomViewController *vc = (CustomViewController *)self.delegate;
                [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
            }
            else
            {
                //Error
                NSLog(@"delete fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

-(void)sendEmail:(NSString *)toAddress withSubject:(NSString *)subject andBody:(NSString *)body
{
    NSString *bodyPercentEscape = [Utility percentEscapeString:body];
    NSString *noteDataString = [NSString stringWithFormat:@"toAddress=%@&subject=%@&body=%@", toAddress,subject,bodyPercentEscape];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[Utility url:urlSendEmail]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                [self.delegate removeOverlayViewConnectionFail];
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                
            }
            else
            {
                //Error
                NSLog(@"send email fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

-(void)uploadPhoto:(NSData *)imageData fileName:(NSString *)fileName
{
    if (imageData != nil)
    {
        NSString *noteDataString = @"";
        noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser]];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:[Utility url:urlUploadPhoto]];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        //        [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:[Utility modifiedUser] forKey:@"modifiedUser"];
        [_params setObject:[Utility deviceToken] forKey:@"modifiedDeviceToken"];
        [_params setObject:[Utility dbName] forKey:@"dbName"];
        for (NSString *param in _params)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [urlRequest setHTTPBody:body];
        
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
            if(error && error.code != -1005)
            {
                if (self.delegate)
                {
                    [self.delegate connectionFail];
                }
                NSLog(@"Error: %@", [error debugDescription]);
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
        
        [dataTask resume];
    }
}

- (void)downloadImageWithFileName:(NSString *)fileName completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"imageFileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser]];
    NSURL * url = [NSURL URLWithString:[Utility url:urlDownloadPhoto]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            
            NSString *status = json[@"status"];
            if([status integerValue] == 3)
            {
                CustomViewController *vc = (CustomViewController *)self.delegate;
                [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
            }
            else
            {
                NSString *base64String = json[@"base64String"];
                if(json && base64String && ![base64String isEqualToString:@""])
                {
                    NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    
                    UIImage *image = [[UIImage alloc] initWithData:nsDataEncrypted];
                    completionBlock(YES,image);
                }
                else
                {
                    completionBlock(NO,nil);
                }
            }
        }
    }];
    
    [dataTask resume];
}

- (void)downloadImageWithFileName:(NSString *)fileName type:(NSInteger)type branchID:(NSInteger)branchID completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"imageFileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&type=%ld&branchID=%ld&lang=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],type,branchID,[Language getLanguage]];
    NSURL * url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDownloadPhoto]]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            
            
            NSString *status = json[@"status"];
            if([status integerValue] == 3)
            {
                CustomViewController *vc = (CustomViewController *)self.delegate;
                [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
            }
            else
            {
                NSString *base64String = json[@"base64String"];
                if(json && base64String && ![base64String isEqualToString:@""])
                {
                    NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    
                    UIImage *image = [[UIImage alloc] initWithData:nsDataEncrypted];
                    completionBlock(YES,image);
                }
                else
                {
                    completionBlock(NO,nil);
                }
            }
        }
    }];
    
    [dataTask resume];
}

- (void)downloadQRToPay:(NSObject *)data completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    GBPrimeQr *gbPrimeQr = (GBPrimeQr *)data;
    NSString *noteDataString = [Utility getNoteDataString:gbPrimeQr];
    NSURL * url = [NSURL URLWithString:gbPrimeQr.postUrl];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error)
        {
            completionBlock(NO,nil);
        }
        else
        {
            UIImage *image = [[UIImage alloc] initWithData:dataRaw];
            completionBlock(YES,image);
        }
    }];
    
    [dataTask resume];
}

- (void)downloadItems:(enum enumDB)currentDB withData:(NSObject *)data completionBlock:(void (^)(BOOL succeeded, NSMutableArray *items))completionBlock
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
       
    }
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&lang=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Language getLanguage]];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error)
        {
            completionBlock(NO,nil);
        }
        else
        {
            /////////
            {
                NSArray *arrClassName;
                switch (currentDB)
                {
//                    case dbMenuNoteList:
//                        arrClassName = @[@"MenuNote"];
//                        break;
                }
                
                
                NSMutableArray *arrItem = [[NSMutableArray alloc] init];
                
                
                NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:dataRaw options:NSJSONReadingAllowFragments error:nil];
                NSString *status = dicJson[@"status"];
                if([status integerValue] == 3)
                {
                    CustomViewController *vc = (CustomViewController *)self.delegate;
                    [vc performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
                }
                else
                {
                    NSArray *jsonArray = dicJson[@"data"];
                    //                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:dataRaw options:NSJSONReadingAllowFragments error:nil];
                    
                    if(!jsonArray)
                    {
                        return;
                    }
                    for(int i=0; i<[jsonArray count]; i++)
                    {
                        //arrdatatemp <= arrdata
                        NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
                        NSArray *arrData = jsonArray[i];
                        for(int j=0; j< arrData.count; j++)
                        {
                            NSDictionary *jsonElement = arrData[j];
                            NSObject *object = [[NSClassFromString([Utility getMasterClassName:i from:arrClassName]) alloc] init];
                            
                            unsigned int propertyCount = 0;
                            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
                            
                            for (unsigned int i = 0; i < propertyCount; ++i)
                            {
                                objc_property_t property = properties[i];
                                const char * name = property_getName(property);
                                NSString *key = [NSString stringWithUTF8String:name];
                                
                                
                                NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                                if(!jsonElement[dbColumnName])
                                {
                                    continue;
                                }
                                
                                
                                if([Utility isDateColumn:dbColumnName])
                                {
                                    NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                                    if(!date)
                                    {
                                        date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd"];
                                    }
                                    [object setValue:date forKey:key];
                                }
                                else
                                {
                                    [object setValue:jsonElement[dbColumnName] forKey:key];
                                }
                            }
                            [arrDataTemp addObject:object];
                        }
                        [arrItem addObject:arrDataTemp];
                    }
                    
                    // Ready to notify delegate that data is ready and pass back items
                    if (self.delegate)
                    {
                        completionBlock(YES,arrItem);
                    }
                }
            }
        }
    }];
    
    [dataTask resume];
}

- (void)downloadFileWithFileName:(NSString *)fileName completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"fileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser]];
    NSURL * url = [NSURL URLWithString:[Utility url:urlDownloadFile]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error != nil)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            
            
            NSString *base64String = json[@"base64String"];
            if(json && base64String && ![base64String isEqualToString:@""])
            {
                NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                completionBlock(YES,nsDataEncrypted);
            }
            else
            {
                completionBlock(NO,nil);
            }
        }
    }];
    
    [dataTask resume];
}

@end

