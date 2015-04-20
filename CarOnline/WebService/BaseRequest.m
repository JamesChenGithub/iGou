//
//  BaseRequest.m
//  CarOnline
//
//  Created by James on 14-8-4.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseRequest.h"

// =========================================

@implementation BaseRequest

//- (instancetype)init
//{
//    if (self = [super init])
//    {
////        _uriKey = NSStringFromClass([self class]);
//    }
//    return self;
//}

- (NSString *)uriKey
{
    return [NSString stringWithFormat:@"%@Result", NSStringFromClass([self class])];
}

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler
{
    if (self = [self init])
    {
        self.succHandler = succHandler;
    }
    return self;
}

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail
{
    if (self = [self initWithHandler:succHandler]) {
        self.failHandler = fail;
    }
    return self;
}

//- (NSString *)uriKey
//{
//    return _uriKey;
//}

- (NSString *)uri
{
    // TODO : overwrite by subclass
    return @"/WebServer/APPWSDataApi.asmx";
}

- (NSString *)url
{
    if ([AppDelegate sharedAppDelegate].isChinese)
    {
//        return @"http://112.124.35.20/WebServer/APPWSDataApi.asmx";
        return @"http://www.igpsobd.com/webserver/wsgetdata.asmx";
    }
    else
    {
        return @"http://112.124.35.20:8010/WebServer/APPWSDataApi.asmx";
    }
    
    
    
}

- (NSString *)soapAction
{
    NSString *soapAction = [NSString stringWithFormat:@"http://tempuri.org/%@", NSStringFromClass([self class])];
    return soapAction;
}

- (NSDictionary *)headDictionary
{
    LoginUser *user = [WebServiceEngine sharedEngine].user;
    BOOL hasUserCode = user && ![NSString isEmpty:user.UserCode];
    BOOL hasPwd = user && ![NSString isEmpty:user.Password];
    
    NSDictionary *dic = @{@"Version" : [NSNumber numberWithInt:0],
                          @"MachineType" : [NSNumber numberWithInt:1],
                          @"UserCode" : hasUserCode ? user.UserCode : @"",
                          @"Password" : hasPwd ? user.Password : @"",
                          @"IMEI" : @""
                          };
    return dic;
}

- (NSDictionary *)bodyDictionary
{
    return nil;
}

- (NSString *)contentJSON
{
    NSDictionary *headDic = [self headDictionary];
    
    NSString *headJson = nil;
    
    if ([NSJSONSerialization isValidJSONObject:headDic])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:headDic options:NSJSONWritingPrettyPrinted error: &error];
        headJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if ([NSString isEmpty:headJson])
    {
        DebugLog(@"head json 不能为空");
        return nil;
    }
    
    
    NSDictionary *bodydic = [self bodyDictionary];
    NSString *bodyJson = @"{}";
    
    if ([NSJSONSerialization isValidJSONObject:bodydic])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodydic options:NSJSONWritingPrettyPrinted error: &error];
        bodyJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *contentJson = [NSString stringWithFormat:@"{\"Head\":%@, \"Body\":%@}", headJson, bodyJson];
    
    return contentJson;
}

- (NSData *)contentJSONData
{
    NSString *contentJson = [self contentJSON];
    return [contentJson dataUsingEncoding:NSUTF8StringEncoding];
}

- (BaseResponse *)response
{
    if (!_response)
    {
        _response = [[BaseResponse alloc] init];
    }
    return _response;
}

- (NSString *)toWebServiceXml
{
    NSString *json = [self contentJSON];
    
    if ([NSString isEmpty:json])
    {
        DebugLog(@"the Key or json is nil");
        return nil;
    }
    NSString *uriKey = NSStringFromClass([self class]);
    NSMutableString *xml = [NSMutableString string];
    [xml appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [xml appendString:@"<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"];
    [xml appendString:@"<soap12:Body>"];
    [xml appendFormat:@"<%@ xmlns=\"http://tempuri.org/\">", uriKey];
    [xml appendFormat:@"<str>%@</str>", json];
    [xml appendFormat:@"</%@></soap12:Body></soap12:Envelope>", uriKey];
    
    DebugLog(@"post XML is : %@", xml);
    return xml;

}

- (NSData *)toWebServiceXmlData
{
    NSString *xml = [self toWebServiceXml];
    return [xml dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)description
{
    return [self toWebServiceXml];
}

- (Class)responseClass;
{
    return [BaseResponse class];
}

- (Class)responseBodyClass
{
    return [BaseResponseBody class];
}

- (void)handleResponseBody:(NSDictionary *)bodyDic
{
    if (_succHandler)
    {
        // todo handle body
        self.response.Body = [NSObject parse:[self responseBodyClass] dictionary:bodyDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            _succHandler(self);
        });
        
    }
    else
    {
        DebugLog(@"_succHandler 为空");
    }
}

@end

@implementation OBDBaseRequest

- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler
{
    if (self = [super initWithHandler:succHandler])
    {
        self.VehicleNumber = [WebServiceEngine sharedEngine].vehicle.VehicleNumber;
    }
    return self;
}

- (NSDictionary *)bodyDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:self.VehicleNumber forKey:@"VehicleNumber"];
    return dic;
}


@end

// =========================================

@implementation BaseResponseHead

- (BOOL)success
{
    return [self.ResultCode isEqualToString:@"00"];
}

- (NSString *)message;
{
    return self.ResultInfo;
}

@end

@implementation BaseResponseBody

@end

@implementation BaseResponse

- (BOOL)success
{
    return [_Head success];
}
- (NSString *)message
{
    return [_Head message];
}

@end

// =========================================
