//
//  DelAlarmInfo.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "DelAlarmInfo.h"

@implementation DelAlarmInfo

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.AlertId forKey:@"AlertId"];
    [dic addString:self.MessageType forKey:@"MessageType"];
    return dic;
}

@end
