//
//  Utility.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
//#import "RNEncryptor.h"
//#import "RNDecryptor.h"
#import <objc/runtime.h>
#import "ChristmasConstants.h"



#define mRedThemeColor      [UIColor colorWithRed:255/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define mGrayColor          [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1]
#define mLightGrayColor     [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define mDarkGrayColor      [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]
#define mYellowColor        [UIColor colorWithRed:255/255.0 green:255/255.0 blue:253/255.0 alpha:1]
#define mBlueColor          [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1]
#define mLightBlueColor     [UIColor colorWithRed:211/255.0 green:229/255.0 blue:249/255.0 alpha:1]
#define mBlueBackGroundColor     [UIColor colorWithRed:220/255.0 green:239/255.0 blue:244/255.0 alpha:1]
#define mLightGreen         [UIColor colorWithRed:193/255.0 green:245/255.0 blue:192/255.0 alpha:1]
#define mLightYellowColor   [UIColor colorWithRed:248/255.0 green:247/255.0 blue:123/255.0 alpha:1]
#define mLightPink          [UIColor colorWithRed:242/255.0 green:209/255.0 blue:248/255.0 alpha:1]
#define mRed                [UIColor colorWithRed:255/255.0 green:56/255.0 blue:36/255.0 alpha:1]

#define mColVwBgColor       [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define mGreen              [UIColor colorWithRed:0/255.0 green:168/255.0 blue:136/255.0 alpha:1]
#define mSeparatorLine      [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]
#define mPlaceHolder     [UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1]
#define mButtonColor     [UIColor colorWithRed:30/255.0 green:177/255.0 blue:237/255.0 alpha:1]
#define mNotActiveColor     [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1]
#define mOrange     [UIColor colorWithRed:246/255.0 green:139/255.0 blue:31/255.0 alpha:1]
#define mPink     [UIColor colorWithRed:238/255.0 green:69/255.0 blue:123/255.0 alpha:1]
#define mButtonText     [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1]
#define mSelectionStyleGray     [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]
#define mPlaceHolder     [UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1]
#define cSystem1     [UIColor colorWithRed:255/255.0 green:60/255.0 blue:75/255.0 alpha:1]
#define cSystem2     [UIColor colorWithRed:100/255.0 green:220/255.0 blue:200/255.0 alpha:1]
#define cSystem3     [UIColor colorWithRed:0/255.0 green:90/255.0 blue:80/255.0 alpha:1]
#define cSystem4     [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]
#define cSystem5     [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1]
#define cSystem4_10     [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]
#define cSystem1_20     [UIColor colorWithRed:255/255.0 green:215/255.0 blue:218/255.0 alpha:1]
#define cSystem1_30     [UIColor colorWithRed:255/255.0 green:196/255.0 blue:200/255.0 alpha:1]
#define cSystem2_20     [UIColor colorWithRed:223/255.0 green:247/255.0 blue:243/255.0 alpha:1]
#define cSystem2_30     [UIColor colorWithRed:208/255.0 green:244/255.0 blue:238/255.0 alpha:1]
#define cRibbon     [UIColor colorWithRed:246/255.0 green:166/255.0 blue:171/255.0 alpha:1]


#define cTextFieldBorder     [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]




enum enumMessage
{
    skipMessage1,
    incorrectPasscode,
    skipMessage2,
    emailSubjectAdd,
    emailBodyAdd,
    emailSubjectReset,
    emailBodyReset,
    emailInvalid,
    emailExisted,
    wrongEmail,
    wrongPassword,
    newPasswordNotMatch,
    changePasswordSuccess,
    emailSubjectChangePassword,
    emailBodyChangePassword,
    newPasswordEmpty,
    passwordEmpty,
    passwordChanged,
    emailSubjectForgotPassword,
    emailBodyForgotPassword,
    forgotPasswordReset,
    forgotPasswordMailSent,
    locationEmpty,
    periodFromEmpty,
    periodToEmpty,
    deleteSubject,
    confirmDeleteUserAccount,
    confirmDeleteEvent,
    periodToLessThanPeriodFrom,
    noEventChosenSubject,
    noEventChosenDetail,
    codeMismatch,
    passwordIncorrect,
    emailIncorrect
};
enum enumSetting
{
    vZero,
    vOne,
    vFormatDateDB,
    vFormatDateDisplay,
    vFormatDateTimeDB,
    vBrand,
    vPasscode,
    vAllowUserCount,
    vAdminDeviceToken,
    vAdminEmail,
    vExpiredDate
};
enum mainTab
{
    mainTabHotDeal = 0,
    mainTabReward = 1,
    mainTabQrScan = 2,
    mainTabHistory = 3,
    mainTabMe = 4
};
enum enumDB
{
    dbUserAccount,
    dbUserAccountForgotPassword,
    dbUserAccountValidate,
    dbMessage,
    dbMaster,
    dbMasterWithProgressBar,
    dbLogIn,
    dbLogOut,
    dbLogInUserAccount,
    dbPushSync,
    dbPushSyncUpdateByDeviceToken,
    dbDevice,
    dbPushSyncUpdateTimeSynced,
    dbWriteLog,
    dbMenu,
    dbMenuList,
    dbPic,
    dbPicList,
    dbMenuPic,
    dbMenuPicList,
    dbMenuType,
    dbMenuTypeList,
    dbNote,
    dbNoteList,
    dbReceiptOrderTakingOrderNote,
    dbOmiseCheckOut,
    dbCustomerTable,
    dbReceiptSummaryPage,
    dbReceipt,
    dbReceiptAndLuckyDraw,
    dbPromotion,
    dbRewardPoint,
    dbRewardPointList,
    dbRewardPointSpent,
    dbRewardPointSpentMore,
    dbRewardPointSpentUsed,
    dbRewardPointSpentUsedMore,
    dbRewardPointSpentExpired,
    dbRewardPointSpentExpiredMore,
    dbPushReminder,
    dbHotDeal,
    dbHotDealList,
    dbHotDealWithBranchID,
    dbRewardRedemption,
    dbRewardRedemptionList,
    dbPromoCode,
    dbPromoCodeList,
    dbUserRewardRedemptionUsed,
    dbUserRewardRedemptionUsedList,
    dbDisputeReason,
    dbDisputeReasonList,
    dbDispute,
    dbDisputeList,
    dbDisputeCancel,
    dbBranch,
    dbBranchAndCustomerTableQR,
    dbBranchSearch,
    dbComment,
    dbCommentList,
    dbRecommendShop,
    dbRecommendShopList,
    dbRating,
    dbRatingList,
    dbReceiptDisputeRating,
    dbReceiptDisputeRatingUpdateAndReload,
    dbReceiptBuffetEnded,
    dbMenuNote,
    dbMenuNoteList,    
    dbMenuBelongToBuffet,
    dbSettingWithKey,
    dbPromotionAndRewardRedemption,
    dbLuckyDrawTicket,
    dbLuckyDrawTicketList,
    dbRewardRedemptionLuckyDraw,
    dbBuffetMenuMap,
    dbBuffetMenuMapList,
    dbOrderJoiningShareQr,
    dbOrderJoiningScanQr,
    dbOrderJoining,
    dbSaveOrder,
    dbOrderItAgain,
    dbReceiptAndPromoCode,
    dbTransferForm,
    dbTransferFormList,
    dbBank,
    dbBankList,
    dbTransferFormAndBankList

    
};

enum enumUrl
{
    urlSendEmail,
    urlMasterGet,
    urlUploadPhoto,
    urlDownloadPhoto,
    urlDownloadFile,
    urlQRToPayDownload,
    urlLogInUserAccountInsert,
    urlLogInInsert,
    urlLogOutInsert,
    urlPushSyncSync,
    urlPushSyncUpdateByDeviceToken,
    urlPushSyncUpdateTimeSynced,
    urlWriteLog,
    urlMenuInsert,
    urlMenuUpdate,
    urlMenuDelete,
    urlMenuInsertList,
    urlMenuUpdateList,
    urlMenuDeleteList,
    urlMenuGetList,
    urlMenuNoteGetList,
    urlPicInsert,
    urlPicUpdate,
    urlPicDelete,
    urlPicInsertList,
    urlPicUpdateList,
    urlPicDeleteList,
    urlMenuPicInsert,
    urlMenuPicUpdate,
    urlMenuPicDelete,
    urlMenuPicInsertList,
    urlMenuPicUpdateList,
    urlMenuPicDeleteList,
    urlOmiseCheckOut,
    urlReceiptOrderTakingOrderNoteInsert,
    urlCustomerTableGetList,
    urlReceiptSummaryGetList,
    urlPromotionGetList,
    urlFacebookComment,
    urlUserAccountValidate,
    urlUserAccountInsert,
    urlUserAccountUpdate,
    urlUserAccountForgotPasswordInsert,
    urlUserAccountGet,
    urlTermsOfService,
    urlPrivacyPolicy,
    urlRewardPointInsert,
    urlRewardPointUpdate,
    urlRewardPointDelete,
    urlRewardPointInsertList,
    urlRewardPointUpdateList,
    urlRewardPointDeleteList,
    urlRewardPointGet,
    urlRewardPointSpentGetList,
    urlRewardPointSpentMoreGetList,
    urlRewardPointSpentUsedGetList,
    urlRewardPointSpentUsedMoreGetList,
    urlRewardPointSpentExpiredGetList,
    urlRewardPointSpentExpiredMoreGetList,
    urlPushReminder,
    urlHotDealInsert,
    urlHotDealUpdate,
    urlHotDealDelete,
    urlHotDealInsertList,
    urlHotDealUpdateList,
    urlHotDealDeleteList,
    urlHotDealGetList,
    urlRewardRedemptionWithBranchGetList,
    urlRewardRedemptionInsert,
    urlRewardRedemptionUpdate,
    urlRewardRedemptionDelete,
    urlRewardRedemptionInsertList,
    urlRewardRedemptionUpdateList,
    urlRewardRedemptionDeleteList,
    urlPromoCodeInsert,
    urlPromoCodeUpdate,
    urlPromoCodeDelete,
    urlPromoCodeInsertList,
    urlPromoCodeUpdateList,
    urlPromoCodeDeleteList,
    urlUserRewardRedemptionUsedInsert,
    urlUserRewardRedemptionUsedUpdate,
    urlUserRewardRedemptionUsedDelete,
    urlUserRewardRedemptionUsedInsertList,
    urlUserRewardRedemptionUsedUpdateList,
    urlUserRewardRedemptionUsedDeleteList,
    urlReceiptMaxModifiedDateGetList,
    urlReceiptGet,
    urlReceiptWithModifiedDateGet,
    urlReceiptUpdate,
    urlDisputeReasonInsert,
    urlDisputeReasonUpdate,
    urlDisputeReasonDelete,
    urlDisputeReasonInsertList,
    urlDisputeReasonUpdateList,
    urlDisputeReasonDeleteList,
    urlDisputeReasonGetList,
    urlDisputeInsert,
    urlDisputeUpdate,
    urlDisputeDelete,
    urlDisputeInsertList,
    urlDisputeUpdateList,
    urlDisputeDeleteList,
    urlDisputeGetList,
    urlDisputeCancelInsert,
    urlBranchGetList,
    urlBranchAndCustomerTableGet,
    urlBranchAndCustomerTableQRGet,
    urlBranchSearchGetList,
    urlBranchSearchMoreGetList,
    urlCommentInsert,
    urlCommentUpdate,
    urlCommentDelete,
    urlCommentInsertList,
    urlCommentUpdateList,
    urlCommentDeleteList,
    urlRecommendShopInsert,
    urlRecommendShopUpdate,
    urlRecommendShopDelete,
    urlRecommendShopInsertList,
    urlRecommendShopUpdateList,
    urlRecommendShopDeleteList,
    urlRatingInsert,
    urlRatingUpdate,
    urlRatingDelete,
    urlRatingInsertList,
    urlRatingUpdateList,
    urlRatingDeleteList,
    urlReceiptDisputeRatingGet,
    urlMenuNoteInsert,
    urlMenuNoteUpdate,
    urlMenuNoteDelete,
    urlMenuNoteInsertList,
    urlMenuNoteUpdateList,
    urlMenuNoteDeleteList,
    urlOpeningTimeMenuBelongToBuffetGet,
    urlContactUs,
    urlMenuBelongToBuffetGetList,
    urlBuffetOrderInsertList,
    urlSettingWithKeyGet,
    urlPromotionAndRewardRedemption,
    urlMenuGet,
    urlLuckyDrawTicketInsert,
    urlLuckyDrawTicketUpdate,
    urlLuckyDrawTicketDelete,
    urlLuckyDrawTicketInsertList,
    urlLuckyDrawTicketUpdateList,
    urlLuckyDrawTicketDeleteList,
    urlRewardRedemptionLuckyDrawGet,
    urlBuffetMenuMapInsert,
    urlBuffetMenuMapUpdate,
    urlBuffetMenuMapDelete,
    urlBuffetMenuMapInsertList,
    urlBuffetMenuMapUpdateList,
    urlBuffetMenuMapDeleteList,
    urlReceiptSummaryPageGetList,
    urlOrderJoiningShareQrGet,
    urlOrderJoiningScanQrInsert,
    urlOrderJoiningPageGetList,
    urlSaveOrderInsertList,
    urlOrderItAgainGetList,
    urlReceiptAndLuckyDrawGetList,
    urlReceiptAndPromoCodeUpdate,
    urlTransferFormInsert,
    urlTransferFormUpdate,
    urlTransferFormDelete,
    urlTransferFormInsertList,
    urlTransferFormUpdateList,
    urlTransferFormDeleteList,
    urlBankInsert,
    urlBankUpdate,
    urlBankDelete,
    urlBankInsertList,
    urlBankUpdateList,
    urlBankDeleteList,
    urlBankGetList,
    urlTransferFormAndBankGetList

    
};

@interface Utility : NSObject<HomeModelProtocol>
+ (NSString *) randomStringWithLength: (int) len;
+ (NSString *)randomStrongPassword;
+ (BOOL) validateEmailWithString:(NSString*)email;
+ (NSString *) msg:(enum enumMessage)eMessage;
+ (NSString *) setting:(enum enumSetting)eSetting;
+ (NSString *) url:(enum enumUrl)eUrl;
+ (NSString *) appendRandomParam:(NSString *)url;
+ (void) setPingAddress:(NSString *)pingAddress;
+ (NSString *) pingAddress;
+ (void) setDomainName:(NSString *)domainName;
+ (NSString *) domainName;
+ (void) setSubjectNoConnection:(NSString *)subjectNoConnection;
+ (NSString *) subjectNoConnection;
+ (void) setDetailNoConnection:(NSString *)detailNoConnection;
+ (NSString *) detailNoConnection;
+ (void)setKey:(NSString *)key;
+ (NSString *) key;
+ (NSString *) deviceToken;
+ (NSInteger) deviceID;
+ (NSString *) dbName;
+(void)setBundleID:(NSString *)bundleID;
+(NSString *)bundleID;
+ (NSString *) formatDate:(NSString *)strDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
+ (NSDate *) stringToDate:(NSString *)strDate fromFormat:(NSString *)fromFormat;
+ (NSString *) dateToString:(NSDate *)date toFormat:(NSString *)toFormat;
+ (NSDate *) setDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSInteger) numberOfDaysFromDate:(NSDate *)dateFrom dateTo:(NSDate *)dateTo;
+ (NSDate *) dateFromDateTime:(NSDate *)dateTime;
+ (NSInteger) dayFromDateTime:(NSDate *)dateTime;
+ (NSDate *) GMTDate:(NSDate *)dateTime;
+ (NSDate *) currentDateTime;
+ (NSString *)percentEscapeString:(NSString *)string;
+ (NSString *)concatParameter:(NSDictionary *)condition;
+ (NSString *) getNoteDataString: (NSObject *)object;
+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo:(long)runningNo;
+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo3Digit:(long)runningNo;
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix;
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix runningNo:(long)runningNo;
+ (NSObject *) trimAndFixEscapeString: (NSObject *)object;
+ (NSString *)formatDecimal:(float)number;
+ (NSString *)formatDecimal:(float)number withMinFraction:(NSInteger)min andMaxFraction:(NSInteger)max;
+ (NSString *)trimString:(NSString *)text;
+ (NSString *)setPhoneNoFormat:(NSString *)text;
+ (NSString *)removeDashAndSpaceAndParenthesis:(NSString *)text;
+ (NSString *)removeComma:(NSString *)text;
+ (NSString *)removeApostrophe:(NSString *)text;
+ (NSString *)removeKeyword:(NSArray *)arrKeyword text:(NSString *)text;
+ (NSString *)modifiedUser;
+ (NSString *)modifiedVC;
+ (void)setModifiedUser:(NSString *)modifiedUser;
+ (NSData *)dataFromHexString:(NSString *)string;
+ (NSString *)makeFirstLetterLowerCase:(NSString *)text;
+ (NSString *)makeFirstLetterUpperCase:(NSString *)text;
+ (NSString *)makeFirstLetterUpperCaseOtherLower:(NSString *)text;
+ (NSString *)getPrimaryKeyFromClassName:(NSString *)className;
+ (NSString *)getMasterClassName:(NSInteger)i;
+ (NSString *)getMasterClassName:(NSInteger)i from:(NSArray *)arrClassName;
//+ (NSString *)getDecryptedHexString:(NSString *)hexString;
+ (BOOL)isNumeric:(NSString *)text;
+ (NSString *)getSqlFailTitle;
+ (NSString *)getSqlFailMessage;
+ (NSString *)getErrorOccurTitle;
+ (NSString *)getErrorOccurMessage;
+ (NSInteger)getNumberOfRowForExecuteSql;
+ (NSInteger)getScanTimeInterVal;
+ (NSInteger)getScanTimeInterValCaseBlur;
+ (BOOL)duplicate:(NSObject *)object;
+ (BOOL)duplicateID:(NSObject *)object;
+ (float)floatValue:(NSString *)text;
+ (NSInteger)getLastDayOfMonth:(NSDate *)datetime;
+ (void)itemsDownloaded:(NSArray *)items;
+ (NSDate *)addDay:(NSDate *)dateFrom numberOfDay:(NSInteger)days;
+ (NSDate *)addSecond:(NSDate *)dateFrom numberOfSecond:(NSInteger)second;
+ (NSString *)getUserDefaultPreOrderEventID;
+ (BOOL)alreadySynced:(NSInteger)pushSyncID;
+ (NSArray *)intersectArray1:(NSArray *)array1 array2:(NSArray *)array2;
+ (BOOL)isStringEmpty:(NSString *)text;
+ (NSDate *)notIdentifiedDate;
+ (BOOL)isDateColumn:(NSString *)columnName;
+ (NSString *)getDay:(NSInteger)dayOfWeekIndex;
+(NSDate *)getPreviousMonthFirstDate;
+(NSDate *)getPreviousMonthLastDate;
+(NSDate *)getPrevious14Days;
+(NSDate *)getPreviousOrNextDay:(NSInteger)days;
+(NSDate *)getPreviousOrNextDay:(NSInteger)days fromDate:(NSDate *)fromDate;
+(NSDate *)getPrevious30Min:(NSDate *)inputDate;
+ (void) setExpectedSales:(float)expectedSales;
+ (float) expectedSales;
+(NSDate *)setStartOfTheDay:(NSDate *)date;
+(NSDate *)setEndOfTheDay:(NSDate *)date;
+(NSDate *)getLatestMonday;
+(NSDate *)getNextSunday;
+(int)hexStringToInt:(NSString *)hexString;
+(NSArray *)jsonToArray:(NSArray *)arrDataJson arrClassName:(NSArray *)arrClassName;
+(NSMutableArray *)sortDataByColumn:(NSMutableArray *)dataList numOfColumn:(NSInteger)numOfColumn;
+(NSString *)getFirstLetter:(NSString *)text;
+(NSString *)getTextOmitFirstLetter:(NSString *)text;
+(NSString *)removeSpace:(NSString *)text;
+(NSString *)replaceNewLineForDB:(NSString *)text;
+(NSString *)replaceNewLineForApp:(NSString *)text;
+(NSString *)insertDashForPhoneNo:(NSString *)text;
+(NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key;
+(NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key;
+(NSString*)addPrefixBahtSymbol:(NSString *)strAmount;
+(BOOL)isExpiredDateValid:(NSDate *)date;
+(NSString *)hashText:(NSString *)text;
+(NSString *)hashTextSHA256:(NSString *)text;
+(BOOL)validateStrongPassword:(NSString *)password;
+(void)addToSharedDataList:(NSArray *)items;
+(NSString *)hideCreditCardNo:(NSString *)creditCardNo;
+ (void)updateSharedDataList:(NSMutableArray *)itemList className:(NSString *)className branchID:(NSInteger)branchID;
+(void)updateSharedObject:(NSArray *)arrOfObjectList;
+ (void)addUpdateObject:(NSObject *)object;
+(void)createCacheFoler:(NSString *)folderName;
+(UIImage *)getImageFromCache:(NSString *)imageName;
+(void)saveImageInCache:(UIImage *)image imageName:(NSString *)imageName;
+(void)deleteFileInCache:(NSString *)fileName;
+(NSString *)formatPhoneNo:(NSString *)phoneNo;

@end

