//
//  SetSecurity.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "SetSecurity.h"

@implementation SetSecurity

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    [dic addBOOL:self.IsSecurity forKey:@"IsSecurity"];
    return dic;
}

@end
