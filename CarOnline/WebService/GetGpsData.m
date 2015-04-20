//
//  GetGpsData.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GetGpsData.h"

@implementation GetGpsData

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.ID forKey:@"ID"];
    [dic addString:self.VehicleNumbers forKey:@"VehicleNumbers"];
    return dic;
}

- (Class)responseBodyClass
{
    return [GetGpsDataResponseBody class];
}

- (void)handleResponseBody:(NSDictionary *)bodyDic
{
    if (_succHandler)
    {
        
        self.self.response.Body = [NSObject parse:[self responseBodyClass] dictionary:bodyDic itemClass:[VehicleGPSListItem class]];
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

@implementation GetGpsDataResponseBody



@end
