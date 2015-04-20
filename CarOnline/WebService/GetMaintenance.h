//
//  GetMaintenance.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetMaintenance : OBDBaseRequest

@end



//"Body": {
//    "ISMileage": 1,
//    "ISDay": 1,
//    "MaintainMileage": 158.73,
//    "TotalMileage": 300,
//    "MaintanceDay": 20.79,
//    "TotalDay": 12
//}
@interface GetMaintenanceResponseBody : BaseResponseBody

@property (nonatomic, assign) BOOL ISMileage;
@property (nonatomic, assign) BOOL ISDay;
@property (nonatomic, assign) CGFloat MaintainMileage;
@property (nonatomic, assign) CGFloat TotalMileage;
@property (nonatomic, assign) CGFloat MaintanceDay;
@property (nonatomic, assign) CGFloat TotalDay;

@end
