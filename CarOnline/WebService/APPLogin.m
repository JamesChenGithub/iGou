//
//  APPLogin.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "APPLogin.h"

@implementation APPLogin


//// @Override by subclass
//- (NSDictionary *)headDictionary;

// @Override by subclass
- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.UserName forKey:@"UserName"];
    [dic addString:self.Password forKey:@"Password"];
    return dic;
}

- (Class)responseBodyClass
{
    return [APPLoginResponseBody class];
}

@end

@implementation APPLoginResponseBody


@end
