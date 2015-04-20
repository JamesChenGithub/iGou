//
//  SetMaintenance.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "SetMaintenance.h"

@implementation SetMaintenance

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    [dic addString:self.Code forKey:@"Code"];
    [dic addString:self.CodeValue forKey:@"CodeValue"];
    [dic addString:self.Value forKey:@"Value"];
    return dic;
}

@end
