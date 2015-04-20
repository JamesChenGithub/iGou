//
//  GetElectronicFence.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetElectronicFence : OBDBaseRequest

@end

//{"Head":{"ResultCode":"00","ResultInfo":""},"Body":{"Enclosure":4207.33,"Lng":"114.110904","Lat":"22.61701","IsEnable":1}}

@interface GetElectronicFenceResponseBody : BaseResponseBody

@property (nonatomic, assign) CGFloat Enclosure;
@property (nonatomic, assign) double Lng;
@property (nonatomic, assign) double Lat;
@property (nonatomic, assign) BOOL IsEnable;

@end