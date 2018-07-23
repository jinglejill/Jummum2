//
//  AppDelegate.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "HomeModel.h"
#import "Utility.h"
#import "PushSync.h"
#import "SharedCurrentUserAccount.h"
#import <objc/runtime.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UILabel+FontAppearance.h"


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@interface AppDelegate (){
    HomeModel *_homeModel;
}

@end

extern BOOL globalRotateFromSeg;



@implementation AppDelegate
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)photoUploaded
{
    
}

void myExceptionHandler(NSException *exception)
{
    NSString *stackTrace = [[[exception callStackSymbols] valueForKey:@"description"] componentsJoinedByString:@"\\n"];
    stackTrace = [NSString stringWithFormat:@"%@,%@\\n%@\\n%@",[Utility modifiedUser],[Utility deviceToken],exception.reason,stackTrace];
//    NSLog(@"Stack Trace callStackSymbols: %@", stackTrace);
    
    [[NSUserDefaults standardUserDefaults] setValue:stackTrace forKey:@"exception"];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault]; // Change to your colour
    
    
    [Utility setFinishLoadSharedData:NO];
    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    
    
    globalRotateFromSeg = NO;
    
    // Override point for customization after application launch.
    NSString *strplistPath = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    
    // read property list into memory as an NSData  object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:strplistPath];
    NSError *strerrorDesc = nil;
    NSPropertyListFormat plistFormat;
    
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&plistFormat error:&strerrorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %lu", strerrorDesc, (unsigned long)plistFormat);
    }
    else
    {
        // assign values        
        [Utility setPingAddress:[temp objectForKey:@"PingAddress"]];
        [Utility setDomainName:[temp objectForKey:@"DomainName"]];
        [Utility setSubjectNoConnection:[temp objectForKey:@"SubjectNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setKey:[temp objectForKey:@"Key"]];
        
        
        
    }
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"JUMMUM4" forKey:BRANCH];
    
    
    
    //write exception of latest app crash to log file
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
    NSString *stackTrace = [[NSUserDefaults standardUserDefaults] stringForKey:@"exception"];
    if(!stackTrace)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    else if(![stackTrace isEqualToString:@""])
    {
        [_homeModel insertItems:dbWriteLog withData:stackTrace actionScreen:@"Logging"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    
//    
//    //write app version to log file
//    NSSetUncaughtExceptionHandler(&myExceptionHandler);
//    NSString *stackTrace2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"appVersion"];
//    if(!stackTrace2)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"appVersion"];
//    }
//    else if(![stackTrace2 isEqualToString:@""])
//    {
//        [_homeModel insertItems:dbWriteLog withData:stackTrace2 actionScreen:@"appVersion test"];
//        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"appVersion"];
//    }
//    
    
    
    //push notification
    //push notification
    {
        if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
        {
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
             {
                 if( !error )
                 {
                     [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                     NSLog( @"Push registration success." );
                 }
                 else
                 {
                     NSLog( @"Push registration FAILED" );
                     NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                     NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
                 }
             }];
            
            
            UNNotificationAction *notificationAction1 = [UNNotificationAction actionWithIdentifier:@"Print"
                                                                                             title:@"Print"
                                                                                           options:UNNotificationActionOptionForeground];
            UNNotificationAction *notificationAction2 = [UNNotificationAction actionWithIdentifier:@"View"
                                                                                             title:@"View"
                                                                                           options:UNNotificationActionOptionForeground];
            UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:@"Print"                                                                                                     actions:@[notificationAction1,notificationAction2] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
            
            
            // Register the notification categories.
            UNUserNotificationCenter* center2 = [UNUserNotificationCenter currentNotificationCenter];
            center2.delegate = self;
            [center2 setNotificationCategories:[NSSet setWithObjects:notificationCategory,nil]];
            
            
        }
        else
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }   
    }
    
    
    
    #if (TARGET_OS_SIMULATOR)
        NSString *token = @"simulator";
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    #endif


    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

#ifdef __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {

    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];

    return YES;
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return YES;
}
#endif


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    
    //Called when a notification is delivered to a foreground app.
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Received notification: %@", userInfo);
    
    
    NSDictionary *myAps;
    for(id key in userInfo)
    {
        myAps = [userInfo objectForKey:key];
    }
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        NSLog(@"decline action");
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        NSLog(@"answer action");
    }
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token---%@", token);

    
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    NSLog([error localizedDescription]);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"didRegisterUserNotificationSettings");
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if(![Utility finishLoadSharedData])
    {
        return;
    }
    
    
    NSLog(@"Received notification: %@", userInfo);

}

//- (void)itemsSynced:(NSArray *)items
//{
//    NSLog(@"items count: %ld",[items count]);
//    if([items count] == 0)
//    {
//        UINavigationController * navigationController = self.navController;
//        UIViewController *viewController = navigationController.visibleViewController;
//        SEL s = NSSelectorFromString(@"removeOverlayViews");
//        if([viewController respondsToSelector:s])
//        {
//            [viewController performSelector:s];
//        }
//
//        return;
//    }
//
//
//    NSMutableArray *pushSyncList = [[NSMutableArray alloc]init];
//
//
//    //type == exit
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//
//
//        if([type isEqualToString:@"exitApp"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//            NSString *title = @"มีการปรับปรุงแอพ";
//            NSString *message = @"กรุณาเปิดแอพใหม่อีกครั้งเพื่อใช้งาน";
//
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
//                                                                           message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//            NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
//            [attrStringTitle addAttribute:NSFontAttributeName
//                                    value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
//                                    range:NSMakeRange(0, title.length)];
//            [attrStringTitle addAttribute:NSForegroundColorAttributeName
//                                    value:cSystem4
//                                    range:NSMakeRange(0, title.length)];
//            [alert setValue:attrStringTitle forKey:@"attributedTitle"];
//
//
//            NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
//            [attrStringMsg addAttribute:NSFontAttributeName
//                                  value:[UIFont fontWithName:@"Prompt-Regular" size:15]
//                                  range:NSMakeRange(0, message.length)];
//            [attrStringMsg addAttribute:NSForegroundColorAttributeName
//                                  value:cSystem4
//                                  range:NSMakeRange(0, message.length)];
//            [alert setValue:attrStringMsg forKey:@"attributedMessage"];
//
//
//
//
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action)
//                                            {
//                                                exit(0);
//                                            }];
//
//            [alert addAction:defaultAction];
//            [self.vc presentViewController:alert animated:YES completion:nil];
//
//
//            UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
//            UIColor *color = cSystem1;
//            NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
//            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
//
//            UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
//            label.attributedText = attrString;
//        }
//    }
//
//
//
//
//
//
//    //type == alert
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
//        if([type isEqualToString:@"alert"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//            NSString *title = [Utility getSqlFailTitle];
//            NSString *message = [NSString stringWithFormat:@"%@ is fail",[(NSDictionary *)data objectForKey:@"alert"]];
//
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
//                                                                           message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//            NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
//            [attrStringTitle addAttribute:NSFontAttributeName
//                                    value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
//                                    range:NSMakeRange(0, title.length)];
//            [attrStringTitle addAttribute:NSForegroundColorAttributeName
//                                    value:cSystem4
//                                    range:NSMakeRange(0, title.length)];
//            [alert setValue:attrStringTitle forKey:@"attributedTitle"];
//
//
//            NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
//            [attrStringMsg addAttribute:NSFontAttributeName
//                                  value:[UIFont fontWithName:@"Prompt-Regular" size:15]
//                                  range:NSMakeRange(0, message.length)];
//            [attrStringMsg addAttribute:NSForegroundColorAttributeName
//                                  value:cSystem4
//                                  range:NSMakeRange(0, message.length)];
//            [alert setValue:attrStringMsg forKey:@"attributedMessage"];
//
//
//
//
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action)
//                                            {
//                                                SEL s = NSSelectorFromString(@"loadingOverlayView");
//                                                [self.vc performSelector:s];
//                                                [_homeModel downloadItems:dbMaster];
//                                            }];
//
//            [alert addAction:defaultAction];
//            [self.vc presentViewController:alert animated:YES completion:nil];
//
//
//            UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
//            UIColor *color = cSystem1;
//            NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
//            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
//
//            UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
//            label.attributedText = attrString;
//
//
//        }
//    }
//
//
//
//    //type == usernameconflict
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
//        if([type isEqualToString:@"usernameconflict"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//            //you have login in another device และ unwind to หน้า sign in
//            if(![self.vc isMemberOfClass:[LogInViewController class]])
//            {
//                NSString *title = @"";
//                NSString *message = @"Username นี้กำลังถูกใช้เข้าระบบที่เครื่องอื่น";
//
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
//                                                                               message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//                NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
//                [attrStringTitle addAttribute:NSFontAttributeName
//                                        value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
//                                        range:NSMakeRange(0, title.length)];
//                [attrStringTitle addAttribute:NSForegroundColorAttributeName
//                                        value:cSystem4
//                                        range:NSMakeRange(0, title.length)];
//                [alert setValue:attrStringTitle forKey:@"attributedTitle"];
//
//
//                NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
//                [attrStringMsg addAttribute:NSFontAttributeName
//                                      value:[UIFont fontWithName:@"Prompt-Regular" size:15]
//                                      range:NSMakeRange(0, message.length)];
//                [attrStringMsg addAttribute:NSForegroundColorAttributeName
//                                      value:cSystem4
//                                      range:NSMakeRange(0, message.length)];
//                [alert setValue:attrStringMsg forKey:@"attributedMessage"];
//
//
//
//
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action)
//                                                {
//                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
//                                                    [UIApplication sharedApplication].keyWindow.rootViewController = logInViewController;
//                                                }];
//
//                [alert addAction:defaultAction];
//                [self.vc presentViewController:alert animated:YES completion:nil];
//
//
//                UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
//                UIColor *color = cSystem1;
//                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
//                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
//
//                UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
//                label.attributedText = attrString;
//
//
//
//            }
//        }
//    }
//
//
//
//
//    //type == currentUserAccount
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
//        if([type isEqualToString:@"currentUserAccount"])
//        {
//            //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//            if([PushSync alreadySynced:[strPushSyncID integerValue]])
//            {
//                continue;
//            }
//            else
//            {
//                //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//                PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//                [PushSync addObject:pushSync];
//                [pushSyncList addObject:pushSync];
//            }
//
//
//            NSDictionary *jsonElement = data[0];
//            NSObject *object = [[NSClassFromString(@"UserAccount") alloc] init];
//
//            unsigned int propertyCount = 0;
//            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
//
//            for (unsigned int i = 0; i < propertyCount; ++i)
//            {
//                objc_property_t property = properties[i];
//                const char * name = property_getName(property);
//                NSString *key = [NSString stringWithUTF8String:name];
//
//
//                NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
//                if(!jsonElement[dbColumnName])
//                {
//                    continue;
//                }
//
//
//                if([Utility isDateColumn:dbColumnName])
//                {
//                    NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
//                    [object setValue:date forKey:key];
//                }
//                else
//                {
//                    [object setValue:jsonElement[dbColumnName] forKey:key];
//                }
//            }
//
//            [UserAccount setCurrentUserAccount:(UserAccount *)object];
//        }
//    }
//
//
//
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        NSString *action = [payload objectForKey:@"action"];
//        NSString *strPushSyncID = [payload objectForKey:@"pushSyncID"];
//        NSArray *data = [payload objectForKey:@"data"];
//
//
//        //เช็คว่าเคย sync pushsyncid นี้ไปแล้วยัง
//        if([PushSync alreadySynced:[strPushSyncID integerValue]])
//        {
//            continue;
//        }
//        else
//        {
//            //update shared ใช้ในกรณี เรียก homemodel > 1 อันต่อหนึ่ง click คำสั่ง ซึ่งทำให้เกิดการ เรียก function syncitems ตัวที่ 2 ก่อนเกิดการ update timesynced จึงทำให้เกิดการเบิ้ล sync
//            PushSync *pushSync = [[PushSync alloc]initWithPushSyncID:[strPushSyncID integerValue]];
//            [PushSync addObject:pushSync];
//            [pushSyncList addObject:pushSync];
//        }
//
//
//
//        if([data isKindOfClass:[NSArray class]])
//        {
//            [Utility itemsSynced:type action:action data:data];
//        }
//    }
//
//
//    //update pushsync ที่ sync แล้ว
//    if([pushSyncList count]>0)
//    {
//        NSLog(@"push sync list count: %ld",[pushSyncList count]);
//        [_homeModel updateItems:dbPushSyncUpdateTimeSynced withData:pushSyncList actionScreen:@"Update synced time"];
//    }
//
//
//    //ให้ refresh ข้อมูลที่ Show ที่หน้านั้นหลังจาก sync ข้อมูลมาใหม่ ตอนนี้ทำเฉพาะหน้า OrderTakingViewController ก่อน
//    NSMutableArray *arrAllType = [[NSMutableArray alloc]init];
//    for(int j=0; j<[items count]; j++)
//    {
//        NSDictionary *payload = items[j];
//        NSString *type = [payload objectForKey:@"type"];
//        [arrAllType addObject:type];
//    }
//    if([items count] > 0)
//    {
//        BOOL loadViewProcess = NO;
//        NSArray *arrReferenceTable;
//
//    }
//}

- (void)itemsUpdated
{
    
}

- (void)itemsInserted
{
    
}

- (void)itemsDeleted
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if(![Utility finishLoadSharedData])
    {
        return;
    }
    
    
    //load shared at the begining of everyday
    NSDictionary *todayLoadShared = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"todayLoadShared"];
    NSString *strCurrentDate = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy-MM-dd"];
    NSString *alreadyLoaded = [todayLoadShared objectForKey:strCurrentDate];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//-(void)itemsDownloaded:(NSArray *)items
//{
//
//    [Utility itemsDownloaded:items];
//    {
//        SEL s = NSSelectorFromString(@"loadViewProcess");
//        [self.vc performSelector:s];
//    }
//    {
//        SEL s = NSSelectorFromString(@"removeOverlayViews");
//        [self.vc performSelector:s];
//    }
//}

- (void) connectionFail
{
    //เอา font มาใส่
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    
    
    
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc showAlert:title message:message];
}


- (void)itemsFail
{
    NSString *title = [Utility getErrorOccurTitle];
    NSString *message = [Utility getErrorOccurMessage];
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc showAlert:title message:message];
}


@end
