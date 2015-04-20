//
//  GetServ.h
//  CarOnline
//
//  Created by James on 14-9-24.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

@interface GetServ : BaseRequest

@end


//{"Body":{"serverName":"深圳市谷英技术有限公司","serverTp":"谷英","serverTelephone":"13534118825","serverEmail":"info@growwin.com.cn","serverPhone":"0755-29823518","serverAddress":"广东省深圳市宝安区龙华民清路光辉科技园2栋2单元3楼"},"Head":{"ResultCode":"00","ResultInfo":""}}

@interface GetServResponseBody : BaseResponseBody

@property (nonatomic, copy) NSString *serverName;
@property (nonatomic, copy) NSString *serverTp;
@property (nonatomic, copy) NSString *serverTelephone;
@property (nonatomic, copy) NSString *serverEmail;
@property (nonatomic, copy) NSString *serverPhone;
@property (nonatomic, copy) NSString *serverAddress;


@end
