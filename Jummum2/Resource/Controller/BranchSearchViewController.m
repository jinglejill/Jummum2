//
//  BranchSearchViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 28/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "BranchSearchViewController.h"
#import "CustomerTableSearchViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "MenuSelectionViewController.h"
#import "CustomTableViewCellMenu.h"
#import "Branch.h"


@interface BranchSearchViewController ()
{
    NSMutableArray *_branchList;
    Branch *_selectedBranch;
    NSMutableArray *_filterBranchList;
    NSInteger _fromReceiptSummaryMenu;
    CustomerTable *_customerTable;
}


@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation BranchSearchViewController
static NSString * const reuseIdentifierMenu = @"CustomTableViewCellMenu";


@synthesize tbvBranch;
@synthesize sbText;


-(IBAction)unwindToBranchSearch:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isMemberOfClass:[CreditCardAndOrderSummaryViewController class]])
    {
        CreditCardAndOrderSummaryViewController *vc = segue.sourceViewController;
        _fromReceiptSummaryMenu = vc.fromReceiptSummaryMenu;
        _customerTable = vc.customerTable;
        _selectedBranch = vc.branch;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_fromReceiptSummaryMenu)
    {
        _fromReceiptSummaryMenu = 0;
        [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
    }
}

-(void)loadView
{
    [super loadView];
    
    _branchList = [Branch getBranchList];
    _filterBranchList = _branchList;
    
    
    
//    ///test
//    {
//        
//        NSMutableArray *dataList = [SharedTestMemberMini sharedTestMemberMini].testMemberMiniList;
//        for(int i=0; i<[dataList count]; i++)
//        {
//            NSMutableArray *passwordList = [[NSMutableArray alloc]init];
//            NSMutableArray *memberIDList = [[NSMutableArray alloc]init];
//            TestMemberMini *item = dataList[i];
//            
//            
//            NSString *searchedString = item.content;
//            NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
//            NSString *pattern = @"#start#(.+)#end#";
//            NSError  *error = nil;
//            
//            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
//            NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
//            int j=1;
//            for (NSTextCheckingResult* match in matches)
//            {
//                NSString* matchText = [searchedString substringWithRange:[match range]];
//                
//                
//                
//                NSRange needleRange = NSMakeRange(7,[matchText length]-7);
//                NSString *strTrimText = [matchText substringWithRange:needleRange];
//                
//                
//                needleRange = NSMakeRange(0,[strTrimText length]-5);
//                strTrimText = [strTrimText substringWithRange:needleRange];
//                if(j%2 == 1)
//                {
//                    [passwordList addObject:strTrimText];
//                }
//                else
//                {
//                    [memberIDList addObject:strTrimText];
//                }
//                j++;
//            }
//            
//            
//            
//            NSMutableArray *testPasswordList = [[NSMutableArray alloc]init];
//            
//            for(int i=0; i<[passwordList count]; i++)
//            {
//                TestPassword *testPassword = [[TestPassword alloc]init];
//                testPassword.password = passwordList[i];
//                testPassword.memberID = [memberIDList[i] integerValue];
//                
//                [testPasswordList addObject:testPassword];
//            }
//            
//            
//            [self.homeModel insertItems:dbTestPasswordList withData:testPasswordList actionScreen:@"insert into TestPassword"];
//        }
//        
//        
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbvBranch.delegate = self;
    tbvBranch.dataSource = self;
    sbText.delegate = self;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenu bundle:nil];
        [tbvBranch registerNib:nib forCellReuseIdentifier:reuseIdentifierMenu];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvBranch])
    {
        return [_filterBranchList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvBranch])
    {
        CustomTableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMenu];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        Branch *branch = _filterBranchList[item];
        
        
        
        cell.lblPrice.hidden = YES;
        cell.lblSpecialPrice.hidden = YES;
        cell.lblQuantity.hidden = YES;
        cell.imgTriangle.hidden = YES;
        cell.lblMenuName.text = branch.name;
        NSString *imageFileName = [Utility isStringEmpty:branch.imageUrl]?@"NoImage.jpg":branch.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 cell.imgMenuPic.image = image;
             }
         }];
        cell.imgMenuPic.contentMode = UIViewContentModeScaleAspectFit;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvBranch])
    {
        return 90;
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:tbvBranch])
    {
        Branch *branch = _filterBranchList[indexPath.item];
        _selectedBranch = branch;
        [self performSegueWithIdentifier:@"segCustomerTableSearch" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCustomerTableSearch"])
    {
        CustomerTableSearchViewController *vc = segue.destinationViewController;
        vc.branch = _selectedBranch;
    }
    else if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.branch = _selectedBranch;
        vc.customerTable = _customerTable;
    }
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterBranchList = _branchList;
        [tbvBranch reloadData];
    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_name contains[c] %@)", searchText];        
        _filterBranchList = [[_branchList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:@""];
        [tbvBranch reloadData];
    }
    else
    {
        // if text length == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self cancelSearching];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    //    [self.searchBar setShowsCancelButton:YES animated:YES];
    [sbText setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
    [sbText setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    self.searchBarActive = NO;
    [sbText resignFirstResponder];
    sbText.text  = @"";
    [self filterContentForSearchText:sbText.text scope:@""];
    
}

- (IBAction)goBackHome:(id)sender
{

}
@end
