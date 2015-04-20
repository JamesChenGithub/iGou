//
//  APPLogin.h
//  CarOnline
//
//  Created by James on 14-8-6.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface APPLogin : BaseRequest

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *Password;

@end

@interface APPLoginResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserCode;
@property (nonatomic, copy) NSString *UserPhone;

@end
