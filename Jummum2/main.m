//
//  main.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 15/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


NSString *globalPingAddress;
NSString *globalDomainName;
NSString *globalSubjectNoConnection;
NSString *globalDetailNoConnection;
BOOL globalRotateFromSeg;
BOOL globalFinishLoadSharedData;
NSString *globalKey;
NSString *globalModifiedUser;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
