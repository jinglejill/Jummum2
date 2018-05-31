//
//  TermsOfServiceViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 3/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "TermsOfServiceViewController.h"

@interface TermsOfServiceViewController ()
{

}
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation TermsOfServiceViewController
@synthesize webViewContainer;
@synthesize btnAccept;
@synthesize btnAcceptWidthConstant;
@synthesize btnDeclineWidthConstant;
@synthesize username;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    btnAcceptWidthConstant.constant = ceilf(self.view.frame.size.width/2.0);
    btnDeclineWidthConstant.constant = ceilf(self.view.frame.size.width/2.0);
}

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

    self.webView.frame = view.frame;
    self.webView.center = [view convertPoint:view.center fromView:view.superview];
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
    
    
    [self webViewLoadUrl:[Utility url:urlTermsOfService]];
    [self addWebView:webViewContainer];
}

- (IBAction)acceptTos:(id)sender
{
    NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
    if(!dicTosAgree)
    {
        dicTosAgree = [[NSMutableDictionary alloc]init];
    }
    dicTosAgree = [dicTosAgree mutableCopy];
    [dicTosAgree setValue:@(1) forKey:username];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[dicTosAgree copy] forKey:@"tosAgree"];
    [self performSegueWithIdentifier:@"segQrCodeScanTable" sender:self];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

- (IBAction)declineTos:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}
@end
