//
//  GetDevInfo.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetDevInfo : OBDBaseRequest

@end

//"Body": {
//    "IMEI": "253501101103709",
//    "DeviceType": null,
//    "DeviceName": "TEST709",
//    "SIMNumber": null,
//    "SOSNumber": "13714401039",
//    "UpdatePeriod": "10"
//}

@interface GetDevInfoResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *IMEI;
@property (nonatomic, copy) NSString *DeviceType;
@property (nonatomic, copy) NSString *DeviceName;
@property (nonatomic, copy) NSString *SIMNumber;
@property (nonatomic, copy) NSString *SOSNumber;
@property (nonatomic, copy) NSString *UpdatePeriod;

@end
