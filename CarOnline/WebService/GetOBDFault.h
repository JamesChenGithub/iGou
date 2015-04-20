//
//  GetOBDFault.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetOBDFault : OBDBaseRequest

@property (nonatomic, copy) NSString *VehicleNumber;

@end

@interface GetOBDFaultResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *Value;

@end
