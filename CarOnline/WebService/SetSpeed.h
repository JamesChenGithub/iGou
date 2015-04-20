//
//  SetSpeed.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface SetSpeed : OBDBaseRequest

@property (nonatomic, assign) CGFloat SpeedAlert;
@property (nonatomic, assign) BOOL IsEnable;

@end
