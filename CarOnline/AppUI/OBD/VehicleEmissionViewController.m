//
//  VehicleEmissionViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "VehicleEmissionViewController.h"

@interface VehicleEmissionViewController ()

@property (nonatomic, strong) GetOBDEmissionResponseBody *responseBody;

@end

@implementation VehicleEmissionViewController



- (void)reloadAfterGetOBDEmission:(GetOBDEmissionResponseBody *)body
{
    self.responseBody = body;
//    "ExamineStatus":1,
//    "CatalyzeStatus":1,
//    "EGRStatus":0,
//    "EVARStatus":0,
//    "MercuryStatus":0,
//    "HotSensorStatus":0,
//    "HotCatalyzeStatus":0,
//    "FireStatus":0
    
    // 请求到排放的处理
    _data = [NSMutableArray array];
    KeyValue *kv = [KeyValue key:kOBDEmission_ExamineStatus_Str  value:body.ExamineStatus ? kOBD_Result_Unqualified_Str : kOBD_Result_Qualified_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_CatalyzeStatus_Str value:body.CatalyzeStatus ? kOBD_Result_Abnormal_Str : kOBD_Result_Normal_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_EGRStatus_Str value:body.EGRStatus ? kOBD_Result_Abnormal_Str : kOBD_Result_Normal_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_EVAP_Str value:body.EVARStatus ? kOBD_Result_Abnormal_Str : kOBD_Result_Normal_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_MercuryStatus_Str value:body.MercuryStatus ? kOBD_Result_Abnormal_Str : kOBD_Result_Normal_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_HotSensorStatus_Str value:body.HotSensorStatus ? kOBD_Result_Abnormal_Str : kOBD_Result_Normal_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_HotCatalyzeStatus_Str value:body.HotCatalyzeStatus ?  kOBD_Result_Abnormal_Str : kOBD_Result_Normal_Str];
    [_data addObject:kv];

    kv = [KeyValue key:kOBDEmission_FireStatus_Str value:body.FireStatus ? kOBDEmission_FireStatus_YES_Str : kOBDEmission_FireStatus_NO_Str];
    [_data addObject:kv];
    
    [_tableView reloadData];
    
}

//- (void)configOwnViews
//{
//    __weak typeof(self) weakSelf = self;
//    GetOBDEmission *goe = [[GetOBDEmission alloc] initWithHandler:^(BaseRequest *request) {
//        GetOBDEmissionResponseBody *body = (GetOBDEmissionResponseBody *)request.response.Body;
//        [weakSelf reloadAfterGetOBDEmission:body];
//    }];
//    [[WebServiceEngine sharedEngine] asyncRequest:goe];
//}


- (BOOL)isNormalAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return !self.responseBody.ExamineStatus;
            break;
        case 1:
            return !self.responseBody.CatalyzeStatus;
            break;
        case 2:
            return !self.responseBody.EGRStatus;
            break;
        case 3:
            return !self.responseBody.EVARStatus;
            break;
        case 4:
            return !self.responseBody.MercuryStatus;
            break;
        case 5:
            return !self.responseBody.HotSensorStatus;
            break;
        case 6:
            return !self.responseBody.HotCatalyzeStatus;
            break;
        case 7:
            return !self.responseBody.FireStatus;
            break;
            
            
        default:
            return YES;
            break;
    }
}



@end
