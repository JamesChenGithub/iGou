//
//  GetOBDEmission.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetOBDEmission : OBDBaseRequest


@end

//"Body":{"ExamineStatus":1,"CatalyzeStatus":1,"EGRStatus":0,"EVARStatus":0,"MercuryStatus":0,"HotSensorStatus":0,"HotCatalyzeStatus":0,"FireStatus":0}

@interface GetOBDEmissionResponseBody : BaseResponseBody

@property (nonatomic, assign) BOOL ExamineStatus;
@property (nonatomic, assign) BOOL CatalyzeStatus;
@property (nonatomic, assign) BOOL EGRStatus;
@property (nonatomic, assign) BOOL EVARStatus;
@property (nonatomic, assign) BOOL MercuryStatus;
@property (nonatomic, assign) BOOL HotSensorStatus;
@property (nonatomic, assign) BOOL HotCatalyzeStatus;
@property (nonatomic, assign) BOOL FireStatus;

- (BOOL)isEmissionNormal;


@end
