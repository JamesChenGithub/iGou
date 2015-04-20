//
//  SetElectronicFence.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

//{"Body":{"VehicleNumber":"253501101103709","Longitude":"114.110904","Latidude":"22.61701","IsEnable":0,"Enclosure":4207.33},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}


@interface SetElectronicFence : OBDBaseRequest


@property (nonatomic, assign) CGFloat Enclosure;
@property (nonatomic, assign) double Longitude;
@property (nonatomic, assign) double Latidude;
@property (nonatomic, assign) BOOL IsEnable;

@end
