//
//  GetAlarm.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetAlarm : OBDBaseRequest

@end


//DeviceName":"TEST709","IsDownAlert":1,"IsLowPressAlert":1,"IsFatiguedAlert":1,"IsNotFireAlert":1

@interface GetAlarmResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *DeviceName;

@property (nonatomic, assign) BOOL IsDownAlert;
@property (nonatomic, assign) BOOL IsLowPressAlert;
@property (nonatomic, assign) BOOL IsFatiguedAlert;
@property (nonatomic, assign) BOOL IsNotFireAlert;


@end
