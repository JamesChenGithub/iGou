//
//  SetMaintenance.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

//"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"

@interface SetMaintenance : OBDBaseRequest

@property (nonatomic, copy) NSString *Code;
@property (nonatomic, copy) NSString *CodeValue;
@property (nonatomic, copy) NSString *Value;

@end
