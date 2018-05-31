//
//  TosAndPrivacyPolicyViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 3/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "TosAndPrivacyPolicyViewController.h"

@interface TosAndPrivacyPolicyViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation TosAndPrivacyPolicyViewController
@synthesize webViewContainer;
@synthesize lblNavTitle;
@synthesize pageType;


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.webView = [self createWebView];
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
//    self.webView.frame = view.frame;
    self.webView.center = [view convertPoint:view.center fromView:view.superview];
//    self.webView.layer.borderWidth = 1;
}

-(void)webViewLoadUrl:(NSString *)stringUrl
{
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(pageType == 1)
    {
        lblNavTitle.text = @"ข้อกำหนดและเงื่อนไขของ Jummum";
        [self webViewLoadUrl:[Utility url:urlTermsOfService]];
    }
    else
    {
        lblNavTitle.text = @"นโยบายความเป็นส่วนตัว";
        [self webViewLoadUrl:[Utility url:urlPrivacyPolicy]];
    }
    
    [self addWebView:webViewContainer];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

@end
