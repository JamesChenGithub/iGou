//
//  SetSpeed.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "SetSpeed.h"

@implementation SetSpeed

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    [dic addCGFloat:self.SpeedAlert forKey:@"SpeedAlert"];
    [dic addInteger:self.IsEnable forKey:@"IsEnable"];
    return dic;
}

@end
