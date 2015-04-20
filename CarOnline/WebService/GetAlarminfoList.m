//
//  GetAlarminfoList.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GetAlarminfoList.h"

@implementation GetAlarminfoList


- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler
{
    if (self = [super initWithHandler:succHandler])
    {
        _StartRecord = 1;
        _PageSize = 20;
    }
    return self;
}

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumbers forKey:@"VehicleNumbers"];
    [dic addInteger:self.StartRecord forKey:@"StartRecord"];
    [dic addInteger:self.PageSize forKey:@"PageSize"];
    return dic;
}

- (Class)responseBodyClass
{
    return [GetAlarminfoListResponseBody class];
}

- (void)handleResponseBody:(NSDictionary *)bodyDic
{
    if (_succHandler)
    {
        self.self.response.Body = [NSObject parse:[self responseBodyClass] dictionary:bodyDic itemClass:[AlertListItem class]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _succHandler(self);
        });
    }
    else
    {
        DebugLog(@"_succHandler 为空");
    }
}

@end


@implementation GetAlarminfoListResponseBody


@end