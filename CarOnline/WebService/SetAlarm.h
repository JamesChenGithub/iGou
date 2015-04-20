//
//  SetAlarm.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface SetAlarm : OBDBaseRequest

@property (nonatomic, copy) NSString *AlertSettingType;
@property (nonatomic, assign) BOOL AlertSettingValue;

@end
