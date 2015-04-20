//
//  GetUnreadAlarminfoCount.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GetUnreadAlarminfoCount.h"

@implementation GetUnreadAlarminfoCount

- (instancetype)init
{
    if (self = [super init])
    {
        self.AlertId = [WebServiceEngine sharedEngine].startAlertId;
    }
    return self;
}

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.AlertId forKey:@"AlertId"];
    [dic addString:self.VehicleNumbers forKey:@"VehicleNumbers"];
    return dic;
}

- (Class)responseBodyClass
{
    return [GetUnreadAlarminfoCountResponseBody class];
}

@end

@implementation GetUnreadAlarminfoCountResponseBody


@end
