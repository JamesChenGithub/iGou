//
//  CheckUpdates.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface CheckUpdates : BaseRequest

@end

@interface CheckUpdatesResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *DownLoadUrl;
@property (nonatomic, assign) NSInteger CurrentVersion;
@property (nonatomic, copy) NSString *CurrentVersionCode;
@property (nonatomic, copy) NSString *updateInfo;

@end
