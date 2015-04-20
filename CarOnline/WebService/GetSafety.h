//
//  GetSafety.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetSafety : OBDBaseRequest

@property (nonatomic, copy) NSString *VehicleNumber;

@end

@interface GetSafetyResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *Info;

@end
