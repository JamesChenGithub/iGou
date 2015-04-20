//
//  SetElectronicFence.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "SetElectronicFence.h"

@implementation SetElectronicFence

- (NSDictionary *)bodyDictionary
{
//    {"Body":{"VehicleNumber":"353501101103695","Longitude":"114.052182416667","Latidude":"22.6619095833333","IsEnable":0,"Enclosure":200.0},"Head":{"IMEI":"","MachineType":"0","Password":"123456","UserCode":"U00508","Version":0}}
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    [dic addCGFloat:self.Enclosure forKey:@"Enclosure"];
    [dic addString:[NSString stringWithFormat:@"%f", self.Latidude] forKey:@"Latidude"];
    [dic addString:[NSString stringWithFormat:@"%f",self.Longitude] forKey:@"Longitude"];
    [dic addInteger:self.IsEnable forKey:@"IsEnable"];
    
    return dic;
}

@end
