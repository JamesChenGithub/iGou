//
//  HelpInfoViewController.m
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "HelpInfoViewController.h"

@interface HelpInfoViewController ()

@end

@implementation HelpInfoViewController

- (void)addOwnViews
{
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)configOwnViews
{
    NSURL *url = [NSURL URLWithString:@"http://www.igpsobd.com/help.htm"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)layoutOnIPhone
{
    _webView.frame = self.view.bounds;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[HUDHelper sharedInstance] tipMessage:kAppInfo_Help_LoadFail_Str];
}

@end
