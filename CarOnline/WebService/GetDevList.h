//
//  GetDevList.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

//<v:Envelope xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:d="http://www.w3.org/2001/XMLSchema" xmlns:c="http://schemas.xmlsoap.org/soap/encoding/" xmlns:v="http://schemas.xmlsoap.org/soap/envelope/"><v:Header /><v:Body><GetDevList xmlns="http://tempuri.org/"><str>{"Body":{},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}</str></GetDevList></v:Body></v:Envelope>

@interface GetDevList : BaseRequest

@end

//<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><GetDevListResponse xmlns="http://tempuri.org/"><GetDevListResult>{"Body":{"GroupList":[{"GroupCode":"3b47b1b0-ac5e-44f3-a17c-94104b23ef21","GroupName":"默认组","VehicleList":[{"VehicleNumber":"253501101103709","VehicleStatus":"0","Distance":0,"SpeedAlert":0,"Enclosure":0,"DeviceName":"TEST709"}]}]},"Head":{"ResultCode":"00","ResultInfo":""}}</GetDevListResult></GetDevListResponse></soap:Body></soap:Envelope>




@interface GetDevListResponseBody : BaseResponseBody

@property (nonatomic, strong) NSMutableArray *GroupList;

@end

