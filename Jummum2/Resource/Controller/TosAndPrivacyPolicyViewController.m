//
//  TosAndPrivacyPolicyViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 3/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "TosAndPrivacyPolicyViewController.h"
#import "Setting.h"


@interface TosAndPrivacyPolicyViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation TosAndPrivacyPolicyViewController
@synthesize lblNavTitle;
@synthesize webViewContainer;
@synthesize pageType;
@synthesize topViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.webView = [self createWebView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.frame = CGRectMake(0, 0, webViewContainer.frame.size.width, webViewContainer.frame.size.height);
    
    
    self = [super initWithCoder:aDecoder];
    return self;
}

-(WKWebView *)createWebView
{
    WKWebViewConfiguration *configuration =
    [[WKWebViewConfiguration alloc] init];
    return [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
}

-(void)addWebView:(UIView *)view
{
    [view addSubview:self.webView];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    CGRect frame = self.webView.frame;
    frame.origin.x = view.frame.origin.x;
    frame.origin.y = view.frame.origin.y;
    frame.size.width = view.frame.size.width;
    frame.size.height = view.frame.size.height;
    self.webView.frame = frame;
    self.webView.center = [view convertPoint:view.center fromView:view.superview];
}

-(void)webViewLoadUrl:(NSString *)stringUrl
{
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *title = [Language getText:@"ข้อกำหนดและเงื่อนไขของ JUMMUM"];
    lblNavTitle.text = title;
    if(pageType == 1)
    {
        NSString *title = [Language getText:@"ข้อกำหนดและเงื่อนไขของ JUMMUM"];
        lblNavTitle.text = title;
    }
    else if(pageType == 2)
    {
        NSString *title = [Language getText:@"นโยบายความเป็นส่วนตัว"];
        lblNavTitle.text = title;
    }
    else if(pageType == 3)
    {
        NSString *title = [Language getText:@"ติดต่อ JUMMUM"];
        lblNavTitle.text = title;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(pageType == 1)
    {
        [self webViewLoadUrl:[Utility url:urlTermsOfService]];
    }
    else if(pageType == 2)
    {
        [self webViewLoadUrl:[Utility url:urlPrivacyPolicy]];
    }
    else if(pageType == 3)
    {     
        [self webViewLoadUrl:[Utility url:urlContactUs]];
    }
    
    [self addWebView:webViewContainer];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

@end
