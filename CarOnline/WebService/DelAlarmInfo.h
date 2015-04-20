//
//  DelAlarmInfo.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface DelAlarmInfo : BaseRequest

@property (nonatomic, copy) NSString *AlertId;
@property (nonatomic, copy) NSString *MessageType;

@end
