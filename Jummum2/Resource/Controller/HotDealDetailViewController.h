//
//  HotDealDetailViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 26/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "HotDeal.h"


@interface HotDealDetailViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) HotDeal *hotDeal;


- (IBAction)goBack:(id)sender;

@end
