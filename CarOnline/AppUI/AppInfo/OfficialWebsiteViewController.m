//
//  OfficialWebsiteViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OfficialWebsiteViewController.h"

@interface OfficialWebsiteViewController ()

@end

@implementation OfficialWebsiteViewController

- (void)configOwnViews
{
    NSURL *url = [NSURL URLWithString:@"http://www.igpsobd.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
