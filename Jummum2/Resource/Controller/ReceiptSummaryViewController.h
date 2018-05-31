//
//  ReceiptSummaryViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface ReceiptSummaryViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
-(IBAction)unwindToReceiptSummary:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;

@end
