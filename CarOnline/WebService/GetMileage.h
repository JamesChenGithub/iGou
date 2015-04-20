//
//  GetMileage.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetMileage : OBDBaseRequest

@end

@interface GetMileageResponseBody : BaseResponseBody

@property (nonatomic, assign) NSInteger Mileage;

@end
