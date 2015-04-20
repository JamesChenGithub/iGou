//
//  GetOBDEmission.m
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GetOBDEmission.h"

@implementation GetOBDEmission

- (Class)responseBodyClass
{
    return [GetOBDEmissionResponseBody class];
}




@end

@implementation GetOBDEmissionResponseBody

- (BOOL)isEmissionNormal
{
    BOOL isNormal = !_ExamineStatus && !_CatalyzeStatus && !_EGRStatus && !_EVARStatus && !_MercuryStatus && !_HotSensorStatus && !_HotCatalyzeStatus && !_FireStatus;
    return isNormal;
}

@end
