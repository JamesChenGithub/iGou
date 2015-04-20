//
//  GetAlarminfoList.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetAlarminfoList : BaseRequest

@property (nonatomic, copy) NSString *VehicleNumbers;
@property (nonatomic, assign) NSInteger StartRecord;
@property (nonatomic, assign) NSInteger PageSize;

@end

@interface GetAlarminfoListResponseBody : BaseResponseBody

@property (nonatomic, strong) NSMutableArray *AlertList;

@end
