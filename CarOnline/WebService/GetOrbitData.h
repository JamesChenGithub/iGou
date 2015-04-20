//
//  GetOrbitData.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetOrbitData : OBDBaseRequest

@property (nonatomic, copy) NSString *EndOn;
@property (nonatomic, copy) NSString *StartOn;

@end

@interface GetOrbitDataResponseBody : BaseResponseBody

@property (nonatomic, strong) NSMutableArray *VehicleGPSList;

@end
