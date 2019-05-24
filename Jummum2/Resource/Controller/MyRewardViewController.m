//
//  MyRewardViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MyRewardViewController.h"
#import "RewardRedemptionViewController.h"
#import "CustomTableViewCellReward.h"
#import "RewardRedemption.h"
#import "Branch.h"
#import "Setting.h"
#import "Time.h"



@interface MyRewardViewController ()
{
    NSMutableArray *_rewardRedemptionList;
    NSMutableArray *_rewardPointList;
    NSMutableArray *_promoCodeList;
    BOOL _lastItemReached;
    NSInteger _page;
    NSInteger _perPage;
    
    
    
    NSMutableArray *_rewardRedemptionUsedList;
    NSMutableArray *_rewardPointUsedList;
    NSMutableArray *_promoCodeUsedList;
    BOOL _lastItemReachedUsed;
    NSInteger _pageUsed;
    NSInteger _perPageUsed;
    
    
    
    NSMutableArray *_rewardRedemptionExpiredList;
    NSMutableArray *_rewardPointExpiredList;
    NSMutableArray *_promoCodeExpiredList;
    BOOL _lastItemReachedExpired;
    NSInteger _pageExpired;
    NSInteger _perPageExpired;
    

    RewardRedemption *_rewardRedemption;
    RewardPoint *_rewardPointSpent;
    PromoCode *_promoCode;
}
@end

@implementation MyRewardViewController
static NSString * const reuseIdentifierReward = @"CustomTableViewCellReward";


@synthesize lblNavTitle;
@synthesize segConValue;
@synthesize tbvData;
@synthesize rewardPoint;
@synthesize topViewHeight;


-(IBAction)unwindToMyReward:(UIStoryboardSegue *)segue
{
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segConValue setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    
    [segConValue setTitle:[Language getText:@"ปัจจุบัน"] forSegmentAtIndex:0];
    [segConValue setTitle:[Language getText:@"ใช้ไปแล้ว"] forSegmentAtIndex:1];
    [segConValue setTitle:[Language getText:@"หมดอายุ"] forSegmentAtIndex:2];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSString *title = [Language getText:@"รางวัลของฉัน"];
    lblNavTitle.text = title;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    [tbvData setSeparatorColor:cTextFieldBorder];
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReward bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReward];
    }
    
    
    _rewardPointList = [[NSMutableArray alloc]init];
    _promoCodeList = [[NSMutableArray alloc]init];
    _rewardRedemptionList = [[NSMutableArray alloc]init];
    _page = 1;
    _perPage = 10;
    _lastItemReached = NO;
    
    
    _rewardPointUsedList = [[NSMutableArray alloc]init];
    _promoCodeUsedList = [[NSMutableArray alloc]init];
    _rewardRedemptionUsedList = [[NSMutableArray alloc]init];
    _pageUsed = 1;
    _perPageUsed = 10;
    _lastItemReachedUsed = NO;
    

    _rewardPointExpiredList = [[NSMutableArray alloc]init];
    _promoCodeExpiredList = [[NSMutableArray alloc]init];
    _rewardRedemptionExpiredList = [[NSMutableArray alloc]init];
    _pageExpired = 1;
    _perPageExpired = 10;
    _lastItemReachedExpired = NO;
    
    
    [self loadingOverlayView];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    [self.homeModel downloadItems:dbRewardPointSpent withData:@[@"",@(_page),@(_perPage),userAccount]];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(segConValue.selectedSegmentIndex == 0)
    {
        if([_rewardRedemptionList count] > 0)
        {
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 1;
        }
        else
        {
            NSString *message = [Setting getValue:@"081m" example:@"คุณยังไม่มีรางวัล"];
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = message;
            noDataLabel.textColor        = cSystem4;
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
    else if(segConValue.selectedSegmentIndex == 1)
    {
        if([_rewardRedemptionUsedList count] > 0)
        {
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 1;
        }
        else
        {
            NSString *message = [Language getText:@"คุณยังไม่มีรางวัล"];
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = message;
            noDataLabel.textColor        = cSystem4;
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
    else if(segConValue.selectedSegmentIndex == 2)
    {
        if([_rewardRedemptionExpiredList count] > 0)
        {
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 1;
        }
        else
        {
            NSString *message = [Language getText:@"คุณยังไม่มีรางวัล"];
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = message;
            noDataLabel.textColor        = cSystem4;
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(segConValue.selectedSegmentIndex == 0)
    {
        return [_rewardRedemptionList count];
    }
    else if(segConValue.selectedSegmentIndex == 1)
    {
        return [_rewardRedemptionUsedList count];
    }
    else if(segConValue.selectedSegmentIndex == 2)
    {
        return [_rewardRedemptionExpiredList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(segConValue.selectedSegmentIndex == 0)
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _rewardRedemptionList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        
        
    
        NSString *strPoint = [Utility formatDecimal:rewardRedemption.point];
        cell.lblRemark.text = [NSString stringWithFormat:@"%@ points",strPoint];
        [cell.lblRemark sizeToFit];
        cell.lblRemarkWidth.constant = cell.lblRemark.frame.size.width;
        
        
        Branch *branch = [Branch getBranch:rewardRedemption.mainBranchID];
        NSString *noImageFileName = [NSString stringWithFormat:@"/JMM/%@/Image/NoImage.jpg",branch.dbName];
        NSString *imageFileName = [NSString stringWithFormat:@"/JMM/%@/Image/Logo/%@",branch.dbName,branch.imageUrl];
        imageFileName = [Utility isStringEmpty:branch.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgVwValue.image = image;
                 }
             }];
        }
        [self setImageDesign:cell.imgVwValue];
        
        
        
        if(rewardRedemption.withInPeriod == 0)
        {
            NSString *message = [Language getText:@"ใช้ได้ 1 ครั้ง ภายใน %@"];
            cell.lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }

        
        
        if (!_lastItemReached && item == [_rewardRedemptionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
//            RewardPoint *rewardPointSpent = _rewardPointList[item];
            [self.homeModel downloadItems:dbRewardPointSpent withData:@[@"",@(_page),@(_perPage),userAccount]];
        }
        
        
        return cell;
    }
    else if(segConValue.selectedSegmentIndex == 1)
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _rewardRedemptionUsedList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        
        
        NSString *strPoint = [Utility formatDecimal:rewardRedemption.point];
        cell.lblRemark.text = [NSString stringWithFormat:@"%@ points",strPoint];
        [cell.lblRemark sizeToFit];
        cell.lblRemarkWidth.constant = cell.lblRemark.frame.size.width;
        
        
        
        Branch *branch = [Branch getBranch:rewardRedemption.mainBranchID];
        NSString *noImageFileName = [NSString stringWithFormat:@"/JMM/%@/Image/NoImage.jpg",branch.dbName];
        NSString *imageFileName = [NSString stringWithFormat:@"/JMM/%@/Image/Logo/%@",branch.dbName,branch.imageUrl];
        imageFileName = [Utility isStringEmpty:branch.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgVwValue.image = image;
                 }
             }];
        }
        [self setImageDesign:cell.imgVwValue];
        
        
        NSString *message = [Language getText:@"ใช้ไปเมื่อ %@"];
        PromoCode *promoCode = _promoCodeUsedList[item];
        cell.lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:promoCode.modifiedDate toFormat:@"d MMM yyyy HH:mm"]];
        
        
        
        
        if (!_lastItemReachedUsed && item == [_rewardRedemptionUsedList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
//            RewardPoint *rewardPointSpent = _rewardPointUsedList[item];
            [self.homeModel downloadItems:dbRewardPointSpentUsed withData:@[@"",@(_pageUsed),@(_perPageUsed),userAccount]];
        }
        
        
        return cell;
    }
    else if(segConValue.selectedSegmentIndex == 2)
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _rewardRedemptionExpiredList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        
        
        NSString *strPoint = [Utility formatDecimal:rewardRedemption.point];
        cell.lblRemark.text = [NSString stringWithFormat:@"%@ points",strPoint];
        [cell.lblRemark sizeToFit];
        cell.lblRemarkWidth.constant = cell.lblRemark.frame.size.width;
        
        
        
        Branch *branch = [Branch getBranch:rewardRedemption.mainBranchID];
        NSString *noImageFileName = [NSString stringWithFormat:@"/JMM/%@/Image/NoImage.jpg",branch.dbName];
        NSString *imageFileName = [NSString stringWithFormat:@"/JMM/%@/Image/Logo/%@",branch.dbName,branch.imageUrl];
        imageFileName = [Utility isStringEmpty:branch.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgVwValue.image = image;
                 }
             }];
        }
        [self setImageDesign:cell.imgVwValue];
        
        
        if(rewardRedemption.withInPeriod == 0)
        {
            NSString *message = [Language getText:@"หมดอายุเมื่อ %@"];
            cell.lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }
        else
        {
            NSString *message = [Language getText:@"หมดอายุเมื่อ %@"];
            RewardPoint *rewardPoint = _rewardPointExpiredList[item];
            NSDate *expiredDate = [Utility addSecond:rewardPoint.modifiedDate numberOfSecond:rewardRedemption.withInPeriod];
            cell.lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:expiredDate toFormat:@"d MMM yyyy HH:mm"]];
        }
        
        
        
        
        if (!_lastItemReachedExpired && item == [_rewardRedemptionExpiredList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
//            RewardPoint *rewardPointSpent = _rewardPointExpiredList[item];
            [self.homeModel downloadItems:dbRewardPointSpentExpired withData:@[@"",@(_pageExpired),@(_perPageExpired),userAccount]];
        }
        
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if (section == 0)
        {
            return CGFLOAT_MIN;
        }
        
        return tableView.sectionHeaderHeight;
    }
    
    return CGFLOAT_MIN;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;

    
    if(segConValue.selectedSegmentIndex == 0)
    {
        _rewardRedemption = _rewardRedemptionList[item];
        _rewardPointSpent = _rewardPointList[item];
        _promoCode = _promoCodeList[item];
    }
    else if(segConValue.selectedSegmentIndex == 1)
    {
        _rewardRedemption = _rewardRedemptionUsedList[item];
        _rewardPointSpent = _rewardPointUsedList[item];
        _promoCode = _promoCodeUsedList[item];
    }
    else if(segConValue.selectedSegmentIndex == 2)
    {
        _rewardRedemption = _rewardRedemptionExpiredList[item];
        _rewardPointSpent = _rewardPointExpiredList[item];
        _promoCode = _promoCodeExpiredList[item];
    }
    [self performSegueWithIdentifier:@"segRewardRedemption" sender:self];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReward" sender:self];
}

- (IBAction)segmentControlChanged:(id)sender
{
    if(segConValue.selectedSegmentIndex == 1)
    {
        if([_rewardRedemptionUsedList count] == 0)
        {
            [self loadingOverlayView];
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            [self.homeModel downloadItems:dbRewardPointSpentUsed withData:@[@"",@(_pageUsed),@(_perPageUsed),userAccount]];
            [self loadingOverlayView];
        }
        else
        {
            //sort by หมดอายุก่อนหลัง
            //ให้เช็คว่า แยกเป็น 2 กรณี 1.within=0-->sort by rewardRedemption.usingEndDate desc, rewardPoint.modifiedDate Desc 2.countDown-->sort by within+reward.modifiedDate>rewardRedemption.usingEndDate?rewardRedemption.usingEndDate:within+reward.modifiedDate
            for(int i=0; i<[_rewardRedemptionUsedList count]; i++)
            {
                RewardRedemption *rewardRedemption = _rewardRedemptionUsedList[i];
                RewardPoint *rewardPoint = _rewardPointUsedList[i];

                
                if(rewardRedemption.withInPeriod == 0)
                {
                    rewardRedemption.sortDate = [Utility setEndOfTheDay:rewardRedemption.usingEndDate];
                }
                else
                {
                    NSDate *modifiedDateAddWithInPeriod = [Utility addSecond:rewardPoint.modifiedDate numberOfSecond:rewardRedemption.withInPeriod];
                    
                    NSTimeInterval seconds = [modifiedDateAddWithInPeriod timeIntervalSinceDate:[Utility setEndOfTheDay:rewardRedemption.usingEndDate]];
                    if(seconds > 0)
                    {
                        rewardRedemption.sortDate = [Utility setEndOfTheDay:rewardRedemption.usingEndDate];
                    }
                    else
                    {
                        rewardRedemption.sortDate = modifiedDateAddWithInPeriod;
                    }
                }
            }
            _rewardRedemptionUsedList = [RewardRedemption sort:_rewardRedemptionUsedList];
            
            
            for(PromoCode *item in _promoCodeUsedList)
            {
                RewardRedemption *rewardRedemption = [RewardRedemption getRewardRedemption:item.rewardRedemptionID];
                item.rewardRedemptionSortDate = rewardRedemption.sortDate;
            }
            _promoCodeUsedList = [PromoCode sort:_promoCodeUsedList];
            
            
            for(RewardPoint *item in _rewardPointUsedList)
            {
                PromoCode *promoCode = [PromoCode getPromoCode:item.promoCodeID];
                item.rewardRedemptionSortDate = promoCode.rewardRedemptionSortDate;
            }
            _promoCodeUsedList = [PromoCode sort:_promoCodeUsedList];
            
            
            [tbvData reloadData];
        }
    }
    else if(segConValue.selectedSegmentIndex == 2)
    {
        if([_rewardRedemptionExpiredList count] == 0)
        {
            [self loadingOverlayView];
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            [self.homeModel downloadItems:dbRewardPointSpentExpired withData:@[@"",@(_pageExpired),@(_perPageExpired),userAccount]];
            [self loadingOverlayView];
        }
        else
        {            
            [tbvData reloadData];
        }
    }
    else
    {
        [tbvData reloadData];
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    [self removeOverlayViews];
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbRewardPointSpent)
    {
        if(_page == 1)
        {
            _rewardPointList = items[0];
            _promoCodeList = items[1];
            _rewardRedemptionList = items[2];
        }
        else
        {
            NSInteger remaining = [_rewardPointList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_rewardPointList removeLastObject];
                [_promoCodeList removeLastObject];
                [_rewardRedemptionList removeLastObject];
            }
            
            [_rewardPointList addObjectsFromArray:items[0]];
            [_promoCodeList addObjectsFromArray:items[1]];
            [_rewardRedemptionList addObjectsFromArray:items[2]];
            
            
//            //set timer ของตัวที่มาใหม่
//            NSMutableArray *rewardPointList = items[0];
//            NSMutableArray *promoCodeList = items[1];
//            NSMutableArray *rewardRedemptionList = items[2];
//            for(int i=0; i<[rewardPointList count]; i++)
//            {
//                RewardRedemption *rewardRedemption = rewardRedemptionList[i];
//                RewardPoint *rewardPoint = rewardPointList[i];
//                PromoCode *promoCode = promoCodeList[i];
//
//
//                if(rewardRedemption.withInPeriod == 0)//1 time trigger
//                {
//                    NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
//                    NSInteger timeToCountDownUsingEndDate = seconds2>0?seconds2:0;
//
//
//                    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeToCountDownUsingEndDate target:self selector:@selector(updateTimer2:) userInfo:@[rewardRedemption,rewardPoint,promoCode] repeats:NO];
//                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//                }
//                else//trigger every sec
//                {
//                    NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPoint.modifiedDate];
//                    NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
//
//
//
//                    Time *time = [[Time alloc]init];
//                    time.countDown = timeToCountDown;
//
//
//                    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:@[rewardRedemption, time, rewardPoint, promoCode] repeats:YES];
//                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//                }
//            }
        }
        //set timer ของตัวที่มาใหม่
        NSMutableArray *rewardPointList = items[0];
        NSMutableArray *promoCodeList = items[1];
        NSMutableArray *rewardRedemptionList = items[2];
        for(int i=0; i<[rewardPointList count]; i++)
        {
            RewardRedemption *rewardRedemption = rewardRedemptionList[i];
            RewardPoint *rewardPoint = rewardPointList[i];
            PromoCode *promoCode = promoCodeList[i];


            if(rewardRedemption.withInPeriod == 0)//1 time trigger
            {
                NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
                NSInteger timeToCountDownUsingEndDate = seconds2>0?seconds2:0;
                
                
                [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeToCountDownUsingEndDate target:self selector:@selector(updateTimer2:) userInfo:@[rewardRedemption,rewardPoint,promoCode] repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
            else//trigger every sec
            {
                NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPoint.modifiedDate];
                NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
                


                Time *time = [[Time alloc]init];
                time.countDown = timeToCountDown;
                
                
                [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:@[rewardRedemption, time, rewardPoint, promoCode] repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
        }
        
        if([items[0] count] < _perPage)
        {
            _lastItemReached = YES;
        }
        else
        {
            _page += 1;
        }
        
    }
    else if(homeModel.propCurrentDB == dbRewardPointSpentUsed)
    {
        if(_pageUsed == 1)
        {
            _rewardPointUsedList = items[0];
            _promoCodeUsedList = items[1];
            _rewardRedemptionUsedList = items[2];
        }
        else
        {
            NSInteger remaining = [_rewardPointUsedList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_rewardPointUsedList removeLastObject];
                [_promoCodeUsedList removeLastObject];
                [_rewardRedemptionUsedList removeLastObject];
            }
            
            [_rewardPointUsedList addObjectsFromArray:items[0]];
            [_promoCodeUsedList addObjectsFromArray:items[1]];
            [_rewardRedemptionUsedList addObjectsFromArray:items[2]];
        }
        
        
        if([items[0] count] < _perPageUsed)
        {
            _lastItemReachedUsed = YES;
        }
        else
        {
            _pageUsed += 1;
        }
    }
    else if(homeModel.propCurrentDB == dbRewardPointSpentExpired)
    {
        if(_pageExpired == 1)
        {
            _rewardPointExpiredList = items[0];
            _promoCodeExpiredList = items[1];
            _rewardRedemptionExpiredList = items[2];
        }
        else
        {
            NSInteger remaining = [_rewardPointExpiredList count]%_perPageExpired;
            for(int i=0; i<remaining; i++)
            {
                [_rewardPointExpiredList removeLastObject];
                [_promoCodeExpiredList removeLastObject];
                [_rewardRedemptionExpiredList removeLastObject];
            }
            
            [_rewardPointExpiredList addObjectsFromArray:items[0]];
            [_promoCodeExpiredList addObjectsFromArray:items[1]];
            [_rewardRedemptionExpiredList addObjectsFromArray:items[2]];
        }
        
        
        if([items[0] count] < _perPageExpired)
        {
            _lastItemReachedExpired = YES;
        }
        else
        {
            _pageExpired += 1;
        }
    }
    
    [tbvData reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segRewardRedemption"])
    {
        RewardRedemptionViewController *vc = segue.destinationViewController;
        vc.rewardPoint = rewardPoint;
        vc.rewardRedemption = _rewardRedemption;
        vc.rewardPointSpent = _rewardPointSpent;
        vc.promoCode = _promoCode;
        vc.fromMenuMyReward = 1;
    }
}

-(void)updateTimer:(NSTimer *)timer
{
    NSArray *dataList = timer.userInfo;
    RewardRedemption *rewardRedemptionSelected = dataList[0];
    
    
    //timer not in list(when download new and remove old) -> invalidate
    NSInteger index = [RewardRedemption getIndexOfObject:rewardRedemptionSelected rewardRedemptionList:_rewardRedemptionList];
    if(index == -1)
    {
        [timer invalidate];
        return;
    }
    
    
    Time *time = dataList[1];
    time.countDown--;
    time.countDown = time.countDown < 0?0:time.countDown;
    RewardPoint *rewardPointSelected = dataList[2];
    PromoCode *promoCodeSelected = dataList[3];
    
    
    
    [self populateLabelwithTime:time.countDown rewardRedemption:rewardRedemptionSelected];
    if(time.countDown == 0)
    {
        [timer invalidate];
        
        

        [_rewardPointExpiredList insertObject:rewardPointSelected atIndex:0];
        [_promoCodeExpiredList insertObject:promoCodeSelected atIndex:0];
        [_rewardRedemptionExpiredList insertObject:rewardRedemptionSelected atIndex:0];
        [_rewardPointList removeObject:rewardPointSelected];
        [_promoCodeList removeObject:promoCodeSelected];
        [_rewardRedemptionList removeObject:rewardRedemptionSelected];
        
        
        [tbvData reloadData];
    }
}

-(void)updateTimer2:(NSTimer *)timer//---> สำหรับหมดอายุ ตาม enddate , พดหมดอายุก็ย้ายไป ถูกใช้แล้ว
{
    NSArray *dataList = timer.userInfo;
    RewardRedemption *rewardRedemptionSelected = dataList[0];
    RewardPoint *rewardPointSelected = dataList[1];
    PromoCode *promoCodeSelected = dataList[2];
    
    
    [_rewardPointExpiredList insertObject:rewardPointSelected atIndex:0];
    [_promoCodeExpiredList insertObject:promoCodeSelected atIndex:0];
    [_rewardRedemptionExpiredList insertObject:rewardRedemptionSelected atIndex:0];
    [_rewardPointList removeObject:rewardPointSelected];
    [_promoCodeList removeObject:promoCodeSelected];
    [_rewardRedemptionList removeObject:rewardRedemptionSelected];
    
    
    [tbvData reloadData];
}

- (void)populateLabelwithTime:(NSInteger)seconds rewardRedemption:(RewardRedemption *)rewardRedemptionSelected
{
    if(segConValue.selectedSegmentIndex == 0)
    {
        NSInteger minutes = seconds / 60;
        NSInteger hours = minutes / 60;
        
        seconds -= minutes * 60;
        minutes -= hours * 60;
        
        
        
        NSInteger index = [RewardRedemption getIndexOfObject:rewardRedemptionSelected rewardRedemptionList:_rewardRedemptionList];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        CustomTableViewCellReward *cell = [tbvData cellForRowAtIndexPath:indexPath];
        cell.lblCountDown.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
        
    }
}
@end
