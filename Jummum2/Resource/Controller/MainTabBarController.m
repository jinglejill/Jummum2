//
//  MainTabBarController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MainTabBarController.h"


@interface MainTabBarController ()

@end

@implementation MainTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Prompt-Regular" size:11.0f]} forState:UIControlStateNormal];
    
    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
