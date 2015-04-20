//
//  GetDevList.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GetDevList.h"

@implementation GetDevList


//// @Override by subclass
//- (NSDictionary *)headDictionary;

// @Override by subclass
//- (NSDictionary *)bodyDictionary
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic addString:self.UserName forKey:@"UserName"];
//    [dic addString:self.Password forKey:@"Password"];
//    return dic;
//}

- (Class)responseBodyClass
{
    return [GetDevListResponseBody class];
}

- (void)handleResponseBody:(NSDictionary *)bodyDic
{
    if (_succHandler)
    {
        GetDevListResponseBody *body = [[GetDevListResponseBody alloc] init];
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSMutableArray *groupList = [bodyDic objectForKey:@"GroupList"];
        for (NSDictionary *groupListItemDic in groupList) {
            GroupListItem *item = [NSObject parse:[GroupListItem class] dictionary:groupListItemDic itemClass:[VehicleGPSListItem class]];
            if (item)
            {
                [array addObject:item];
            }
        }
        body.GroupList = array;
        self.self.response.Body = body;
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

@implementation GetDevListResponseBody


@end