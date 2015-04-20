//
//  GetOBDData.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetOBDData : OBDBaseRequest

@end

@interface GetOBDDataResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *VIN;
@property (nonatomic, copy) NSString *Value;

@end
