//
//  HotDealDetailViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 26/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Promotion.h"


@interface HotDealDetailViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) Promotion *promotion;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

- (IBAction)goBack:(id)sender;

@end
