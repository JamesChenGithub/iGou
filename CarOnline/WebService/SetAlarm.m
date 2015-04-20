//
//  SetAlarm.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "SetAlarm.h"

@implementation SetAlarm

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    [dic addString:self.AlertSettingType forKey:@"AlertSettingType"];
    [dic addBOOL:self.AlertSettingValue forKey:@"AlertSettingValue"];
    return dic;
}

@end
