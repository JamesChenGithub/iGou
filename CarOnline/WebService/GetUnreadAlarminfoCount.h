//
//  GetUnreadAlarminfoCount.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetUnreadAlarminfoCount : BaseRequest

@property (nonatomic, copy) NSString *AlertId;
@property (nonatomic, copy) NSString *VehicleNumbers;

@end

@interface GetUnreadAlarminfoCountResponseBody : BaseResponseBody

@property (nonatomic, assign) NSInteger AlertCount;

@end
