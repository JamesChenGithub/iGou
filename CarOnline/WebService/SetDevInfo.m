//
//  SetDevInfo.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "SetDevInfo.h"

@implementation SetDevInfo

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    [dic addString:self.DeviceName forKey:@"DeviceName"];
    [dic addString:self.SOSNumber forKey:@"SOSNumber"];
    [dic addInteger:self.UpdatePeriod forKey:@"UpdatePeriod"];
    return dic;
}


- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail deviceName:(NSString *)name
{
    if (self = [self initWithHandler:succHandler failHandler:fail])
    {
        self.DeviceName = name;
        self.SOSNumber = @"-1";
        self.UpdatePeriod = -1;
    }
    return self;
}
- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail SOSNumber:(NSString *)SOS
{
    if (self = [self initWithHandler:succHandler failHandler:fail])
    {
        self.DeviceName = @"-1";
        self.SOSNumber = SOS;
        self.UpdatePeriod = -1;
    }
    return self;
}
- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail updatePeriod:(NSInteger)dur
{
    if (self = [self initWithHandler:succHandler failHandler:fail])
    {
        self.DeviceName = @"-1";
        self.SOSNumber = @"-1";
        self.UpdatePeriod = dur;
    }
    return self;
}

@end
