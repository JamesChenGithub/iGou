//
//  GetGpsData.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"


//{"Body":{"ID":"","VehicleNumbers":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
@interface GetGpsData : BaseRequest

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *VehicleNumbers;

@end

//<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><GetGpsDataResponse xmlns="http://tempuri.org/"><GetGpsDataResult>{"Head":{"ResultCode":"00","ResultInfo":""},"Body":{"VehicleGPSList":[{"ID":828980,"VehicleNumber":"253501101103709","VehicleSpeed":0,"Longitude":114.110640666667,"Latidude":22.6170116666667,"Date":"2014-08-03 10:12:28","Status":"0","Direction":null,"DirectionDegree":17,"DeviceName":"TEST709","Address":"中国广东省深圳市龙岗区大靓花园三区一巷3号","SpeedAlert":90,"Distance":3260.15}]}}</GetGpsDataResult></GetGpsDataResponse></soap:Body></soap:Envelope>

@interface GetGpsDataResponseBody : BaseResponseBody

@property (nonatomic, strong) NSMutableArray *VehicleGPSList;

@end
