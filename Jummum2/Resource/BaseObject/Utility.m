//
//  Utility.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>
#import "UserAccount.h"
#import "LogIn.h"
#import "SharedUserAccount.h"
#import "SharedLogIn.h"
//#import "NSData+Encryption.h"
#import "NSData+AES.h"



extern NSArray *globalMessage;
extern NSString *globalPingAddress;
extern NSString *globalDomainName;
extern NSString *globalSubjectNoConnection;
extern NSString *globalDetailNoConnection;
extern NSString *globalKey;
extern NSString *globalModifiedUser;
extern NSString *globalBundleID;



@implementation Utility
+ (NSString *) randomStringWithLength: (int) len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])] ];
    }
    
    return randomString;
}

+ (NSString *) randomStringWithLength: (int) len letters:(NSString *)letters
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])] ];
    }
    
    return randomString;
}

+(NSString *)randomStrongPassword
{
    NSString *lettersCap = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *lettersNonCap = @"abcdefghijklmnopqrstuvwxyz";
    NSString *lettersNumber = @"0123456789";
    NSString *lettersAll = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
    
    NSString *password = [self randomStringWithLength:1 letters:lettersCap];
    password = [NSString stringWithFormat:@"%@%@",password,[self randomStringWithLength:1 letters:lettersNonCap]];
    password = [NSString stringWithFormat:@"%@%@",password,[self randomStringWithLength:1 letters:lettersNumber]];
    password = [NSString stringWithFormat:@"%@%@",password,[self randomStringWithLength:5 letters:lettersAll]];
    
    return password;
    
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
//    NSString *emailRegex = @"\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,6}";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void) setPingAddress:(NSString *)pingAddress
{
    globalPingAddress = pingAddress;
}

+ (NSString *) pingAddress
{
    return globalPingAddress;
}

+ (void) setDomainName:(NSString *)domainName
{
    globalDomainName = domainName;
}

+ (NSString *) domainName
{
    return globalDomainName;
}

+ (void) setSubjectNoConnection:(NSString *)subjectNoConnection
{
    globalSubjectNoConnection = subjectNoConnection;
}

+ (NSString *) subjectNoConnection
{
    return globalSubjectNoConnection;
}

+ (void) setDetailNoConnection:(NSString *)detailNoConnection
{
    globalDetailNoConnection = detailNoConnection;
}

+ (NSString *) detailNoConnection
{
    return globalDetailNoConnection;
}

+(void)setKey:(NSString *)key
{
    globalKey = key;
}
+(NSString *)key
{
    return globalKey;
}

+ (NSString *) deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN];
}

+ (NSInteger) deviceID
{
    NSString *strDeviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceID"];
    return [strDeviceID integerValue];
}

+ (NSString *) dbName
{
//    return [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    return [[NSUserDefaults standardUserDefaults] stringForKey:BRANCH];
}

+(void)setBundleID:(NSString *)bundleID
{
    globalBundleID = bundleID;
}
+(NSString *)bundleID
{
    return globalBundleID;
}

+ (NSString *) url:(enum enumUrl)eUrl
{
    NSString *url = [[NSString alloc]init];
    switch (eUrl)
    {
        case urlSendEmail:
            url = @"sendEmail.php";
            break;
        case urlUploadPhoto:
            url = @"uploadPhoto.php";
            break;
        case urlDownloadPhoto:
            url = @"JMMDownloadImage.php";
            break;
        case urlDownloadFile:
            url = @"downloadFile.php";
            break;
        case urlPushSyncSync:
            url = @"JMMPushSyncSync.php";
            break;
        case urlPushSyncUpdateByDeviceToken:
            url = @"JMMPushSyncUpdateByDeviceToken.php";
            break;
        case urlPushSyncUpdateTimeSynced:
            url = @"JMMPushSyncUpdateTimeSynced.php";
            break;
        case urlMasterGet:
            url = @"JMMMasterGet.php";
            break;
        case urlLogInInsert:
            url = @"JMMLogInInsert.php";
            break;
        case urlLogInUserAccountInsert:
            url = @"JMMLogInUserAccountInsert.php";
            break;
        case urlLogOutInsert:
            url = @"JMMLogOutInsert.php";
            break;
        case urlWriteLog:
            url = @"JMMWriteLog.php";
            break;
        case urlMenuInsert:
            url = @"JMMMenuInsert.php";
            break;
        case urlMenuUpdate:
            url = @"JMMMenuUpdate.php";
            break;
        case urlMenuDelete:
            url = @"JMMMenuDelete.php";
            break;
        case urlMenuInsertList:
            url = @"JMMMenuInsertList.php";
            break;
        case urlMenuUpdateList:
            url = @"JMMMenuUpdateList.php";
            break;
        case urlMenuDeleteList:
            url = @"JMMMenuDeleteList.php";
            break;
        case urlMenuGetList:
            url = @"JMMMenuGetList.php";
            break;
        case urlMenuNoteGetList:
            url = @"JMMMenuNoteGetList.php";
            break;
        case urlPicInsert:
            url = @"JMMPicInsert.php";
            break;
        case urlPicUpdate:
            url = @"JMMPicUpdate.php";
            break;
        case urlPicDelete:
            url = @"JMMPicDelete.php";
            break;
        case urlPicInsertList:
            url = @"JMMPicInsertList.php";
            break;
        case urlPicUpdateList:
            url = @"JMMPicUpdateList.php";
            break;
        case urlPicDeleteList:
            url = @"JMMPicDeleteList.php";
            break;
        case urlMenuPicInsert:
            url = @"JMMMenuPicInsert.php";
            break;
        case urlMenuPicUpdate:
            url = @"JMMMenuPicUpdate.php";
            break;
        case urlMenuPicDelete:
            url = @"JMMMenuPicDelete.php";
            break;
        case urlMenuPicInsertList:
            url = @"JMMMenuPicInsertList.php";
            break;
        case urlMenuPicUpdateList:
            url = @"JMMMenuPicUpdateList.php";
            break;
        case urlMenuPicDeleteList:
            url = @"JMMMenuPicDeleteList.php";
            break;
        case urlOmiseCheckOut:
            url = @"JMMOmiseCheckOut.php";
            break;
        case urlReceiptOrderTakingOrderNoteInsert:
            url = @"JMMReceiptOrderTakingOrderNoteInsert.php";
            break;
        case urlCustomerTableGetList:
            url = @"JMMCustomerTableGetList.php";
            break;
        case urlReceiptSummaryGetList:
            url = @"JMMReceiptSummaryGetList.php";
            break;
        case urlPromotionGetList:
            url = @"JMMPromotionGetList.php";
            break;
        case urlFacebookComment:
            url = @"FacebookCommentInsertList.php";
            break;
        case urlUserAccountValidate:
            url = @"JMMUserAccountValidate.php";
            break;
        case urlUserAccountGet:
            url = @"JMMUserAccountGet.php";
            break;
        case urlUserAccountInsert:
            url = @"JMMUserAccountInsert.php";
            break;
        case urlUserAccountUpdate:
            url = @"JMMUserAccountUpdate.php";
            break;
        case urlTermsOfService:
            url = @"HtmlTermsOfService.php";
            break;
        case urlContactUs:
            url = @"HtmlContactUs.php";
            break;
        case urlUserAccountForgotPasswordInsert:
            url = @"JMMUserAccountForgotPasswordInsert.php";
            break;
        case urlRewardPointInsert:
            url = @"JMMRewardPointInsert.php";
            break;
        case urlRewardPointUpdate:
            url = @"JMMRewardPointUpdate.php";
            break;
        case urlRewardPointDelete:
            url = @"JMMRewardPointDelete.php";
            break;
        case urlRewardPointInsertList:
            url = @"JMMRewardPointInsertList.php";
            break;
        case urlRewardPointUpdateList:
            url = @"JMMRewardPointUpdateList.php";
            break;
        case urlRewardPointDeleteList:
            url = @"JMMRewardPointDeleteList.php";
            break;
        case urlRewardPointGet:
            url = @"JMMRewardPointGet.php";
            break;
        case urlPrivacyPolicy:
            url = @"HtmlPrivacyPolicy.php";
            break;
        case urlPushReminder:
            url = @"JMMPushReminder.php";
            break;
        case urlHotDealInsert:
            url = @"JMMHotDealInsert.php";
            break;
        case urlHotDealUpdate:
            url = @"JMMHotDealUpdate.php";
            break;
        case urlHotDealDelete:
            url = @"JMMHotDealDelete.php";
            break;
        case urlHotDealInsertList:
            url = @"JMMHotDealInsertList.php";
            break;
        case urlHotDealUpdateList:
            url = @"JMMHotDealUpdateList.php";
            break;
        case urlHotDealDeleteList:
            url = @"JMMHotDealDeleteList.php";
            break;
        case urlHotDealGetList:
            url = @"JMMHotDealGetList.php";
            break;
        case urlRewardRedemptionInsert:
            url = @"JMMRewardRedemptionInsert.php";
            break;
        case urlRewardRedemptionUpdate:
            url = @"JMMRewardRedemptionUpdate.php";
            break;
        case urlRewardRedemptionDelete:
            url = @"JMMRewardRedemptionDelete.php";
            break;
        case urlRewardRedemptionInsertList:
            url = @"JMMRewardRedemptionInsertList.php";
            break;
        case urlRewardRedemptionUpdateList:
            url = @"JMMRewardRedemptionUpdateList.php";
            break;
        case urlRewardRedemptionDeleteList:
            url = @"JMMRewardRedemptionDeleteList.php";
            break;
        case urlPromoCodeInsert:
            url = @"JMMPromoCodeInsert.php";
            break;
        case urlPromoCodeUpdate:
            url = @"JMMPromoCodeUpdate.php";
            break;
        case urlPromoCodeDelete:
            url = @"JMMPromoCodeDelete.php";
            break;
        case urlPromoCodeInsertList:
            url = @"JMMPromoCodeInsertList.php";
            break;
        case urlPromoCodeUpdateList:
            url = @"JMMPromoCodeUpdateList.php";
            break;
        case urlPromoCodeDeleteList:
            url = @"JMMPromoCodeDeleteList.php";
            break;
        case urlRewardPointSpentGetList:
            url = @"JMMRewardPointSpentGetList.php";
            break;
        case urlRewardPointSpentMoreGetList:
            url = @"JMMRewardPointSpentMoreGetList.php";
            break;
        case urlRewardPointSpentUsedGetList:
            url = @"JMMRewardPointSpentUsedGetList.php";
            break;
        case urlRewardPointSpentUsedMoreGetList:
            url = @"JMMRewardPointSpentUsedMoreGetList.php";
            break;
        case urlRewardPointSpentExpiredGetList:
            url = @"JMMRewardPointSpentExpiredGetList.php";
            break;
        case urlRewardPointSpentExpiredMoreGetList:
            url = @"JMMRewardPointSpentExpiredMoreGetList.php";
            break;
        case urlUserRewardRedemptionUsedInsert:
            url = @"JMMUserRewardRedemptionUsedInsert.php";
            break;
        case urlUserRewardRedemptionUsedUpdate:
            url = @"JMMUserRewardRedemptionUsedUpdate.php";
            break;
        case urlUserRewardRedemptionUsedDelete:
            url = @"JMMUserRewardRedemptionUsedDelete.php";
            break;
        case urlUserRewardRedemptionUsedInsertList:
            url = @"JMMUserRewardRedemptionUsedInsertList.php";
            break;
        case urlUserRewardRedemptionUsedUpdateList:
            url = @"JMMUserRewardRedemptionUsedUpdateList.php";
            break;
        case urlUserRewardRedemptionUsedDeleteList:
            url = @"JMMUserRewardRedemptionUsedDeleteList.php";
            break;
        case urlReceiptMaxModifiedDateGetList:
            url = @"JMMReceiptMaxModifiedDateGetList.php";
            break;
        case urlReceiptWithModifiedDateGet:
            url = @"JMMReceiptWithModifiedDateGet.php";
            break;
        case urlReceiptGet:
            url = @"JMMReceiptGet.php";
            break;
        case urlDisputeReasonInsert:
            url = @"JMMDisputeReasonInsert.php";
            break;
        case urlDisputeReasonUpdate:
            url = @"JMMDisputeReasonUpdate.php";
            break;
        case urlDisputeReasonDelete:
            url = @"JMMDisputeReasonDelete.php";
            break;
        case urlDisputeReasonInsertList:
            url = @"JMMDisputeReasonInsertList.php";
            break;
        case urlDisputeReasonUpdateList:
            url = @"JMMDisputeReasonUpdateList.php";
            break;
        case urlDisputeReasonDeleteList:
            url = @"JMMDisputeReasonDeleteList.php";
            break;
        case urlDisputeReasonGetList:
            url = @"JMMDisputeReasonGetList.php";
            break;
        case urlDisputeInsert:
            url = @"JMMDisputeInsert.php";
            break;
        case urlDisputeUpdate:
            url = @"JMMDisputeUpdate.php";
            break;
        case urlDisputeDelete:
            url = @"JMMDisputeDelete.php";
            break;
        case urlDisputeInsertList:
            url = @"JMMDisputeInsertList.php";
            break;
        case urlDisputeUpdateList:
            url = @"JMMDisputeUpdateList.php";
            break;
        case urlDisputeDeleteList:
            url = @"JMMDisputeDeleteList.php";
            break;
        case urlDisputeGetList:
            url = @"JMMDisputeGetList.php";
            break;
        case urlDisputeCancelInsert:
            url = @"JMMDisputeCancelInsert.php";
            break;
        case urlReceiptUpdate:
            url = @"JMMReceiptUpdate.php";
            break;
        case urlBranchGetList:
            url = @"JMMBranchGetList.php";
            break;
        case urlBranchAndCustomerTableGet:
            url = @"JMMBranchAndCustomerTableGet.php";
            break;
        case urlBranchAndCustomerTableQRGet:
            url = @"JMMBranchAndCustomerTableQRGet.php";
            break;
        case urlBranchSearchGetList:
            url = @"JMMBranchSearchGetList.php";
            break;
        case urlRewardRedemptionWithBranchGetList:
            url = @"JMMRewardRedemptionWithBranchIDGetList.php";
            break;
        case urlCommentInsert:
            url = @"JMMCommentInsert.php";
            break;
        case urlCommentUpdate:
            url = @"JMMCommentUpdate.php";
            break;
        case urlCommentDelete:
            url = @"JMMCommentDelete.php";
            break;
        case urlCommentInsertList:
            url = @"JMMCommentInsertList.php";
            break;
        case urlCommentUpdateList:
            url = @"JMMCommentUpdateList.php";
            break;
        case urlCommentDeleteList:
            url = @"JMMCommentDeleteList.php";
            break;
        case urlRecommendShopInsert:
            url = @"JMMRecommendShopInsert.php";
            break;
        case urlRecommendShopUpdate:
            url = @"JMMRecommendShopUpdate.php";
            break;
        case urlRecommendShopDelete:
            url = @"JMMRecommendShopDelete.php";
            break;
        case urlRecommendShopInsertList:
            url = @"JMMRecommendShopInsertList.php";
            break;
        case urlRecommendShopUpdateList:
            url = @"JMMRecommendShopUpdateList.php";
            break;
        case urlRecommendShopDeleteList:
            url = @"JMMRecommendShopDeleteList.php";
            break;
        case urlRatingInsert:
            url = @"JMMRatingInsert.php";
            break;
        case urlRatingUpdate:
            url = @"JMMRatingUpdate.php";
            break;
        case urlRatingDelete:
            url = @"JMMRatingDelete.php";
            break;
        case urlRatingInsertList:
            url = @"JMMRatingInsertList.php";
            break;
        case urlRatingUpdateList:
            url = @"JMMRatingUpdateList.php";
            break;
        case urlRatingDeleteList:
            url = @"JMMRatingDeleteList.php";
            break;
        case urlReceiptDisputeRatingGet:
            url = @"JMMReceiptDisputeRatingGet.php";
            break;
        case urlOpeningTimeMenuBelongToBuffetGet:
            url = @"JMMOpeningTimeMenuBelongToBuffetGet.php";
            break;
        case urlMenuBelongToBuffetGetList:
            url = @"JMMMenuBelongToBuffetGetList.php";
            break;
        case urlBuffetOrderInsertList:
            url = @"JMMBuffetOrderInsertList.php";
            break;
        case urlSettingWithKeyGet:
            url = @"JMMSettingWithKeyGet.php";
            break;
        case urlPromotionAndRewardRedemption:
            url = @"JMMPromotionAndRewardRedemptionGetList.php";
            break;
        case urlMenuGet:
            url = @"JMMMenuGet.php";
            break;
        case urlLuckyDrawTicketInsert:
            url = @"JMMLuckyDrawTicketInsert.php";
            break;
        case urlLuckyDrawTicketUpdate:
            url = @"JMMLuckyDrawTicketUpdate.php";
            break;
        case urlLuckyDrawTicketDelete:
            url = @"JMMLuckyDrawTicketDelete.php";
            break;
        case urlLuckyDrawTicketInsertList:
            url = @"JMMLuckyDrawTicketInsertList.php";
            break;
        case urlLuckyDrawTicketUpdateList:
            url = @"JMMLuckyDrawTicketUpdateList.php";
            break;
        case urlLuckyDrawTicketDeleteList:
            url = @"JMMLuckyDrawTicketDeleteList.php";
            break;
        case urlRewardRedemptionLuckyDrawGet:
            url = @"JMMRewardRedemptionLuckyDrawGet.php";
            break;
        case urlBuffetMenuMapInsert:
            url = @"JMMBuffetMenuMapInsert.php";
            break;
        case urlBuffetMenuMapUpdate:
            url = @"JMMBuffetMenuMapUpdate.php";
            break;
        case urlBuffetMenuMapDelete:
            url = @"JMMBuffetMenuMapDelete.php";
            break;
        case urlBuffetMenuMapInsertList:
            url = @"JMMBuffetMenuMapInsertList.php";
            break;
        case urlBuffetMenuMapUpdateList:
            url = @"JMMBuffetMenuMapUpdateList.php";
            break;
        case urlBuffetMenuMapDeleteList:
            url = @"JMMBuffetMenuMapDeleteList.php";
            break;
        case urlReceiptSummaryPageGetList:
            url = @"JMMReceiptSummaryPageGetList.php";
            break;
        case urlOrderJoiningShareQrGet:
            url = @"JMMOrderJoiningShareQrGet.php";
            break;
        case urlOrderJoiningScanQrInsert:
            url = @"JMMOrderJoiningScanQrInsert.php";
            break;
        case urlOrderJoiningPageGetList:
            url = @"JMMOrderJoiningPageGetList.php";
            break;
        case urlSaveOrderInsertList:
            url = @"JMMSaveOrderInsertList.php";
            break;
        case urlOrderItAgainGetList:
            url = @"JMMOrderItAgainGetList.php";
            break;
        case urlReceiptAndLuckyDrawGetList:
            url = @"JMMReceiptAndLuckyDrawGetList.php";
            break;
        case urlReceiptAndPromoCodeUpdate:
            url = @"JMMReceiptAndPromoCodeUpdate.php";
            break;
        default:
            break;
    }
    url = [NSString stringWithFormat:@"%@%@", [self domainName],url];
    return url;
}

+ (NSString *) appendRandomParam:(NSString *)url
{
    return [NSString stringWithFormat:@"%@?%@&",url,[Utility randomStringWithLength:6]];
}

+ (NSString *) formatDate:(NSString *)strDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = fromFormat;
    NSDate *date  = [df dateFromString:strDate];
    
    // Convert to new Date Format
    [df setDateFormat:toFormat];///////uncomment dont forget
    
    //must set timezone to normal
    NSString *newStrDate = [df stringFromDate:date];
    return newStrDate;
}

+ (nullable NSDate *) stringToDate:(NSString *)strDate fromFormat:(NSString *)fromFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = fromFormat;
    
    NSDate *date = [df dateFromString:strDate];
    return date;
}

+ (NSString *) dateToString:(NSDate *)date toFormat:(NSString *)toFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = toFormat;
    
    
    NSString *strDate = [df stringFromDate:date];
    if(!strDate)
    {
        strDate = @"";
    }
    return strDate;
}

+ (NSDate *) setDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return date;
}

+(NSString *)modifiedUser
{
    return globalModifiedUser;
}

+(void)setModifiedUser:(NSString *)modifiedUser
{
    globalModifiedUser = modifiedUser;
}

+ (NSInteger) numberOfDaysFromDate:(NSDate *)dateFrom dateTo:(NSDate *)dateTo
{
    NSTimeInterval secondsBetween = [dateTo timeIntervalSinceDate:dateFrom];
    int numberOfDays = secondsBetween / 86400 + 1;
    return numberOfDays;
}

+ (NSDate *) dateFromDateTime:(NSDate *)dateTime
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
                                    fromDate:dateTime];
    NSDate *date = [[NSCalendar currentCalendar]
                    dateFromComponents:components];
    
    return date;
}

+ (NSInteger) dayFromDateTime:(NSDate *)dateTime
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
                                    fromDate:dateTime];
    
    NSInteger day = [components day];
    return day;
}

+ (NSDate *) GMTDate:(NSDate *)dateTime
{
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateTimeInLocalTimezone = [dateTime dateByAddingTimeInterval:timeZoneSeconds];
    
    return dateTimeInLocalTimezone;
}

+ (NSDate *) currentDateTime
{
    return [Utility GMTDate:[NSDate date]];
}

+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *)concatParameter:(NSDictionary *)condition
{
    NSString *value;
    NSString *urlParameter = @"";
    for(id key in condition)
    {
        value = [condition objectForKey:key];
        urlParameter = [NSString stringWithFormat:@"%@&%@=%@",urlParameter,key,value];
    }
    
    NSRange needleRange = NSMakeRange(1,[urlParameter length]-1);
    urlParameter = [urlParameter substringWithRange:needleRange];
    
    return urlParameter;
}

+ (NSString *) getNoteDataString: (NSObject *)object
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}

+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")] && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString = [Utility trimString:escapeString];
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        key = [NSString stringWithFormat:@"%@%02ld",key,runningNo];
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}

+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo3Digit:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")] && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString = [Utility trimString:escapeString];
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        key = [NSString stringWithFormat:@"%@%03ld",key,runningNo];
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        NSString *keyWithPrefix = [NSString stringWithFormat:@"%@%@",prefix,[self makeFirstLetterUpperCase:key]];
        [dicCondition setValue:escapeString forKey:keyWithPrefix];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix runningNo:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        NSString *keyWithPrefix = [NSString stringWithFormat:@"%@%@%02ld",prefix,[self makeFirstLetterUpperCase:key],runningNo];
        [dicCondition setValue:escapeString forKey:keyWithPrefix];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSObject *) trimAndFixEscapeString: (NSObject *)object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            NSString *trimString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            escapeString = [self percentEscapeString:trimString];
        }
        [object setValue:escapeString forKey:key];
    }
    free(properties);
    
    return object;
}

+ (NSString *)formatDecimal:(float)number
{
    NSNumberFormatter *formatterBaht = [[NSNumberFormatter alloc]init];
    [formatterBaht setNumberStyle:NSNumberFormatterDecimalStyle];
    formatterBaht.minimumFractionDigits = 0;
    formatterBaht.maximumFractionDigits = 2;
    NSString *strFormattedBaht = [formatterBaht stringFromNumber:[NSNumber numberWithFloat:number]];
    return strFormattedBaht;
}

+ (NSString *)formatDecimal:(float)number withMinFraction:(NSInteger)min andMaxFraction:(NSInteger)max
{
    NSNumberFormatter *formatterBaht = [[NSNumberFormatter alloc]init];
    [formatterBaht setNumberStyle:NSNumberFormatterDecimalStyle];
    formatterBaht.minimumFractionDigits = min;
    formatterBaht.maximumFractionDigits = max;
    NSString *strFormattedBaht = [formatterBaht stringFromNumber:[NSNumber numberWithFloat:number]];
    return strFormattedBaht;
}

+ (NSString *)trimString:(NSString *)text
{
    if([text length] != 0)
    {
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return text;
}

+ (NSString *)setPhoneNoFormat:(NSString *)text
{
    if(!text)
    {
        return @"";
    }
    if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    else if([text length] > 10)
    {
        NSString *strPhoneNo = @"";
        if([text rangeOfString:@","].location != NSNotFound)
        {
            NSArray *arrPhoneNo = [text componentsSeparatedByString:@","];
            for(int i=0; i<[arrPhoneNo count]; i++)
            {
                if(i==0)
                {
                    strPhoneNo = [self setPhoneNoFormat:arrPhoneNo[i]];
                }
                else
                {
                    strPhoneNo = [NSString stringWithFormat:@"%@,%@",strPhoneNo,[self setPhoneNoFormat:arrPhoneNo[i]]];
                }
            }
            return strPhoneNo;
        }
    }
    return text;
}
+ (NSString *)removeDashAndSpaceAndParenthesis:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@")" withString:@""];
    return text;
}
+ (NSString *)removeComma:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
    return text;
}
+ (NSString *)removeApostrophe:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return text;
}
+ (NSString *)removeKeyword:(NSArray *)arrKeyword text:(NSString *)text
{
    for(NSString *keyword in arrKeyword)
    {
        text = [text stringByReplacingOccurrencesOfString:keyword withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    }
    
    return text;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

+ (NSString *)makeFirstLetterLowerCase:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter lowercaseString],theRestLetters];
}

+ (NSString *)makeFirstLetterUpperCase:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter uppercaseString],theRestLetters];
}

+ (NSString *)makeFirstLetterUpperCaseOtherLower:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter uppercaseString],[theRestLetters lowercaseString]];
}

+ (NSString *)getPrimaryKeyFromClassName:(NSString *)className
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [className substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[className length]-1);
    NSString *theRestLetter = [className substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@ID",[firstLetter lowercaseString],theRestLetter];
}

+ (NSString *)getMasterClassName:(NSInteger)i
{
    NSArray *arrMasterClass = @[@"Setting"];
    
    
    return arrMasterClass[i];
}

+ (NSString *)getMasterClassName:(NSInteger)i from:(NSArray *)arrClassName
{
    return arrClassName[i];
}

+ (BOOL)isNumeric:(NSString *)text
{
    if([text isKindOfClass:[NSString class]])
    {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            // newString consists only of the digits 0 through 9
            return YES;
        }
    }
    
    return NO;
}

+(NSString *)getSqlFailTitle
{
    return @"Error occur";
}
+(NSString *)getSqlFailMessage
{
    return @"Please check recent transactions again";
}

+(NSString *)getErrorOccurTitle
{
//    return @"Connection lost";
    return @"Error occured";
}

+(NSString *)getErrorOccurMessage
{
//    return @"The network connection was lost";
    return @"Please try again. If error still exists, please contact Jummum support";
}

+(NSInteger)getNumberOfRowForExecuteSql
{
    return 30;
}

+(NSInteger)getScanTimeInterVal
{
    return 4;
}

+(NSInteger)getScanTimeInterValCaseBlur
{
    return 2;
}

+ (float)floatValue:(NSString *)text
{
    return [[self removeComma:text] floatValue];
}

+ (NSInteger)getLastDayOfMonth:(NSDate *)datetime;
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange =
    [currentCalendar
     rangeOfUnit:NSCalendarUnitDay
     inUnit:NSCalendarUnitMonth
     forDate:datetime];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    
    return daysRange.length;
}

+ (BOOL)duplicate:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    if([className isEqualToString:@"Menu"])
    {
        NSInteger branchID = [[object valueForKey:@"branchID"] integerValue];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and _modifiedUser = %@ and _branchID = %ld",propertyNamePredicate,value,modifiedUser,branchID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        
        return [filterArray count]>0;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and _modifiedUser = %@",propertyNamePredicate,value,modifiedUser];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        
        return [filterArray count]>0;
    }
    
}

+ (BOOL)duplicateID:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray count]>0;
}

+ (void)itemsDownloaded:(NSArray *)items
{
    for(int j=0; j<[items count]; j++)
    {
        NSArray *arrTable = items[j];
        if([arrTable count]>0)
        {
            NSObject *object = arrTable[0];
            Class classDB = [object class];
            NSString *className = NSStringFromClass(classDB);
            Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
            SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
            NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
            [dataList removeAllObjects];
            for(NSMutableArray *item in items[j])
            {
                [dataList addObject:item];
            }
        }
    }
}

+ (NSDate *)addDay:(NSDate *)dateFrom numberOfDay:(NSInteger)days
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *addedDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateFrom options:0];
    return addedDate;
}

+ (NSDate *)addSecond:(NSDate *)dateFrom numberOfSecond:(NSInteger)second
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.second = second;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *addedDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateFrom options:0];
    return addedDate;
}

+ (void)setUserDefaultPreOrderEventID:(NSString *) strSelectedEventID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSMutableDictionary *dicPreOrderEventIDByUser = [[defaults dictionaryForKey:@"PreOrderEventIDByUser"] mutableCopy];
    if(!dicPreOrderEventIDByUser)
    {
        dicPreOrderEventIDByUser = [[NSMutableDictionary alloc]init];
    }
    [dicPreOrderEventIDByUser setValue:strSelectedEventID forKey:username];
    [defaults setObject:dicPreOrderEventIDByUser forKey:@"PreOrderEventIDByUser"];
}

+ (NSString *)getUserDefaultPreOrderEventID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSMutableDictionary *dicPreOrderEventIDByUser = [[defaults dictionaryForKey:@"PreOrderEventIDByUser"] mutableCopy];
    if(!dicPreOrderEventIDByUser)
    {
        dicPreOrderEventIDByUser = [[NSMutableDictionary alloc]init];
    }
    NSString *strEventID = [dicPreOrderEventIDByUser objectForKey:username];
    if(!strEventID)
    {
        strEventID = @"0";
        [dicPreOrderEventIDByUser setValue:strEventID forKey:username];
        [defaults setObject:dicPreOrderEventIDByUser forKey:@"PreOrderEventIDByUser"];
    }
    
    
    return strEventID;
    
}

+ (NSArray *)intersectArray1:(NSArray *)array1 array2:(NSArray *)array2
{
    NSMutableSet *set1 = [NSMutableSet setWithArray: array1];
    NSSet *set2 = [NSSet setWithArray: array2];
    [set1 intersectSet: set2];
    NSArray *resultArray = [set1 allObjects];
    return resultArray;
}

+(BOOL)isStringEmpty:(NSString *)text
{
    if(!text || [[Utility trimString:text] isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}

+ (NSDate *)notIdentifiedDate
{
    return [Utility stringToDate:@"1900-01-01 00:00:00" fromFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (BOOL)isDateColumn:(NSString *)columnName
{
    if([columnName length] < 4)
    {
        return NO;
    }
    NSRange needleRange = NSMakeRange([columnName length]-4,4);
    return [[columnName substringWithRange:needleRange] isEqualToString:@"Date"];
}

+ (NSString *)getDay:(NSInteger)dayOfWeekIndex
{
    NSArray *days = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    return days[dayOfWeekIndex-1];
}

+(NSDate *)getPreviousMonthFirstDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 1;
    comps.month = -1;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    return  date;
}

+(NSDate *)getPreviousMonthLastDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 0;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    return date;
    
}

+(NSDate *)getPrevious14Days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = -14;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    
    return date;
}

+(NSDate *)getPreviousOrNextDay:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    
    return date;
}

+(NSDate *)getPreviousOrNextDay:(NSInteger)days fromDate:(NSDate *)fromDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:fromDate options:0];
    
    
    return date;
}

+(NSDate *)getPrevious30Min:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.minute = -30;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:inputDate options:0];
    
    
    return date;
}

+ (void) setExpectedSales:(float)expectedSales
{
    [[NSUserDefaults standardUserDefaults] setFloat:expectedSales forKey:@"expectedSales"];
}

+ (float) expectedSales
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"expectedSales"];
}

+(NSDate *)setStartOfTheDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *startOfTheDayDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    return startOfTheDayDate;
}

+(NSDate *)setEndOfTheDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *endOfTheDayDate = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    return endOfTheDayDate;
}

+(NSDate *)getLatestMonday
{
    NSDate *today = [Utility currentDateTime];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:today];
    NSInteger weekday = [comps weekday];
    NSInteger days = 0;
    switch (weekday) {
        case 1:
            days = -6;
            break;
        case 2:
            days = 0;
            break;
        case 3:
            days = -1;
            break;
        case 4:
            days = -2;
            break;
        case 5:
            days = -3;
            break;
        case 6:
            days = -4;
            break;
        case 7:
            days = -5;
            break;
        default:
            break;
    }
    
    
    return [self getPreviousOrNextDay:days];
}

+(NSDate *)getNextSunday
{
    return [self getPreviousOrNextDay:6 fromDate:[self getLatestMonday]];
}

+(int)hexStringToInt:(NSString *)hexString
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}


+(NSArray *)jsonToArray:(NSArray *)arrDataJson arrClassName:(NSArray *)arrClassName
{
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    
    
    for(int i=0; i<[arrDataJson count]; i++)
    {
        //arrdatatemp <= arrdata
        NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
        NSArray *arrData = arrDataJson[i];
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
    
    return arrItem;
}

+(NSMutableArray *)sortDataByColumn:(NSMutableArray *)dataList numOfColumn:(NSInteger)numOfColumn
{
    NSMutableArray *sortDataList = [[NSMutableArray alloc]init];
    NSInteger numOfRowPerColumn = ceilf(1.0*[dataList count]/numOfColumn);
    for(int i=0; i<numOfRowPerColumn; i++)
    {
        for(int j=0; j<numOfColumn; j++)
        {
            if(i+j*numOfRowPerColumn >= [dataList count])
            {
                continue;
            }
            else
            {
                [sortDataList addObject:dataList[i+j*numOfRowPerColumn]];
            }
        }
    }
    return sortDataList;
    
}

+(NSString *)getFirstLetter:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    return firstLetter;
}

+(NSString *)getTextOmitFirstLetter:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *resultText = [text substringWithRange:needleRange];
    
    
    return resultText;
}

+(NSString *)removeSpace:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString *)replaceNewLineForDB:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];//replace ด้วยอะไรก้ได้ ที่ไม่ใช่ new line
}

+(NSString *)replaceNewLineForApp:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
}

+(NSString *)insertDashForPhoneNo:(NSString *)text
{
    int i=0;
    NSString *strPhoneNo;
    NSArray* phoneNoList = [text componentsSeparatedByString: @","];
    for(NSString *item in phoneNoList)
    {
        if(i==0)
        {
            strPhoneNo = [Utility insertDash:item];
        }
        else
        {
            strPhoneNo = [NSString stringWithFormat:@"%@,%@",strPhoneNo,[Utility insertDash:item]];
        }
    }
    return strPhoneNo;
}

+ (NSString *)insertDash:(NSString *)text
{
    if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    return text;
}

+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key
{
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:key];
}

+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key
{
    return [[NSString alloc] initWithData:[ciphertext AES128DecryptedDataWithKey:key]
                                 encoding:NSUTF8StringEncoding];
}

+(NSString*)addPrefixBahtSymbol:(NSString *)strAmount
{
    return [NSString stringWithFormat:@"฿ %@",strAmount];
}

+(BOOL)isExpiredDateValid:(NSDate *)date
{
    NSDate *currentDate = [self currentDateTime];
    currentDate = [Utility setStartOfTheDay:currentDate];
    NSComparisonResult result = [currentDate compare:date];
    if(result != NSOrderedAscending)
    {
        return NO;
    }
    return YES;
}

+(NSString *)hashText:(NSString *)text
{
    NSUInteger fieldHash = [text hash];
    NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
    
    return fieldString;
}

+(NSString *)hashTextSHA256:(NSString *)text
{
    NSString *salted = [NSString stringWithFormat:@"%@%@",text,SALT_HASH];
    NSString *fieldString = [KeychainWrapper computeSHA256DigestForString:salted];
    return fieldString;
}

+(BOOL)validateStrongPassword:(NSString *)password
{
    NSString *passwordRegex = @"(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [predicate evaluateWithObject:password];
}

+(void)addToSharedDataList:(NSArray *)items
{
    for(int j=0; j<[items count]; j++)
    {
        NSMutableArray *dataGetList = items[j];
        for(int k=0; k<[dataGetList count]; k++)
        {
            NSObject *object = dataGetList[k];
            NSString *className = NSStringFromClass([object class]);
            NSString *strNameID = [Utility getPrimaryKeyFromClassName:className];
            
            
            Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
            SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
            NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
            
            
            if(![Utility duplicate:object])
            {
                [dataList addObject:object];
            }
        }
    }
}

+(NSString *)hideCreditCardNo:(NSString *)creditCardNo
{
    NSRange needleRange = NSMakeRange(12,4);
    NSString *last4Digit = [creditCardNo substringWithRange:needleRange];
    return [NSString stringWithFormat:@"XXXX XXXX XXXX %@",last4Digit];
}

+(void)updateSharedObject:(NSArray *)arrOfObjectList
{
    for(NSArray *itemList in arrOfObjectList)
    {
        for(NSObject *object in itemList)
        {
            [self addUpdateObject:object];
        }
    }
}

+ (void)updateSharedDataList:(NSMutableArray *)itemList className:(NSString *)className branchID:(NSInteger)branchID
{
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"branchID = %ld",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];

    [dataList removeObjectsInArray:filterArray];
    [dataList addObjectsFromArray:itemList];
}

+ (void)addUpdateObject:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];


    NSArray *filterArray;
    if ([object respondsToSelector:NSSelectorFromString(@"branchID")])
    {
        NSNumber *objBranchID = [object valueForKey:@"branchID"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and branchID = %ld",propertyNamePredicate,value,[objBranchID integerValue]];
        filterArray = [dataList filteredArrayUsingPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
        filterArray = [dataList filteredArrayUsingPredicate:predicate];
    }
    
    
    
    if([filterArray count]==0)
    {
        [dataList addObject:object];
    }
    else
    {
        NSObject *filterObject = filterArray[0];
        NSDate *dateObject = [object valueForKey:@"modifiedDate"];
        NSDate *dateFilterObject = [filterObject valueForKey:@"modifiedDate"];
        NSComparisonResult result = [dateFilterObject compare:dateObject];
        if(result == NSOrderedAscending)
        {
            //update
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                NSString *key = [NSString stringWithUTF8String:name];
                
                
                [filterObject setValue:[object valueForKey:key] forKey:key];
            }
        }
    }
}

+(void)createCacheFoler:(NSString *)folderName
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0]; // Get Caches folder
    NSString *dataPath = [cachesDirectory stringByAppendingPathComponent:folderName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
        if(error)
        {
            NSLog(@"create folder error:%@",error.description);
        }
        else
        {
            NSLog(@"create folder success:%@",dataPath);
        }
}

+(UIImage *)getImageFromCache:(NSString *)imageName
{
    NSString *strPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",strPath,imageName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    return image;
}

+(void)saveImageInCache:(UIImage *)image imageName:(NSString *)imageName
{
    NSString *strPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",strPath,imageName];
    BOOL writeSuccess =  [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

+(void)deleteFileInCache:(NSString *)fileName
{
    NSString *strPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",strPath,fileName];
    
    NSLog(@"delete filename:%@",filePath);
    NSError *error;
    
    if([[NSFileManager defaultManager] isDeletableFileAtPath:filePath])
    {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
        if (error)
        {
          // file deletion failed
          NSLog(@"file deletion failed: %@, %@, %@",error.localizedDescription,error.description,error.description);
        }
    }
    else
    {
        NSLog(@"not deletable");
    }
}

+(NSString *)formatPhoneNo:(NSString *)phoneNo
{
    NSString *formatPhoneNo = @"";
//    NSString *phoneNo = @"0813072993";
    for(int i=0; i<[phoneNo length]; i++)
    {
        NSRange needleRange = NSMakeRange(i,1);
        NSString *eachDigit = [phoneNo substringWithRange:needleRange];
        if(i == 3 || i == 6)
        {
            formatPhoneNo = [NSString stringWithFormat:@"%@-",formatPhoneNo];
        }
        formatPhoneNo = [NSString stringWithFormat:@"%@%@",formatPhoneNo,eachDigit];
    }
    
    return formatPhoneNo;
}
@end


