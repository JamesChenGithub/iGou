//
//  SetDevInfo.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

//"Body": {
//    "DeviceName": "-1",
//    "SOSNumber": "13714401039",
//    "VehicleNumber": "253501101103709",
//    "UpdatePeriod": -1
//},

@interface SetDevInfo : OBDBaseRequest

@property (nonatomic, copy) NSString *DeviceName;
@property (nonatomic, copy) NSString *SOSNumber;
@property (nonatomic, assign) NSInteger UpdatePeriod;

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail deviceName:(NSString *)name;
- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail SOSNumber:(NSString *)SOS;
- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail updatePeriod:(NSInteger)dur;


@end
