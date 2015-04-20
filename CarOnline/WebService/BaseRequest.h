//
//  BaseRequest.h
//  CarOnline
//
//  Created by James on 14-8-4.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

// =========================================

@class BaseRequest;
@class BaseResponse;

typedef void (^RequestCompletionHandler)(BaseRequest *request);

@interface BaseRequest : NSObject
{
@protected
//    NSString                *_uriKey;
    BaseResponse            *_response;
    RequestCompletionHandler _succHandler;
    RequestCompletionHandler _failHandler;
}

//@property (nonatomic, readonly) NSString *uriKey;
@property (nonatomic, strong) BaseResponse *response;
@property (nonatomic, copy) RequestCompletionHandler succHandler;
@property (nonatomic, copy) RequestCompletionHandler failHandler;


- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler;
- (instancetype)initWithHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail;

- (NSString *)uriKey;

- (NSString *)url;

- (NSString *)soapAction;

- (NSString *)contentJSON;

- (NSData *)contentJSONData;

- (NSString *)toWebServiceXml;

- (NSData *)toWebServiceXmlData;


// @Override by subclass
- (NSDictionary *)headDictionary;

// @Override by subclass
- (NSDictionary *)bodyDictionary;

- (Class)responseClass;

- (Class)responseBodyClass;

- (void)handleResponseBody:(NSDictionary *)bodyDic;


@end


@interface OBDBaseRequest : BaseRequest

@property (nonatomic, copy) NSString *VehicleNumber;

@end

// =========================================

@interface BaseResponseHead : NSObject<NSObject>

@property (nonatomic, copy) NSString *ResultCode;
@property (nonatomic, copy) NSString *ResultInfo;

- (BOOL)success;
- (NSString *)message;

@end

@interface BaseResponseBody : NSObject<NSObject>
{
    
}

@end

@interface BaseResponse : NSObject<NSObject>
{
@protected
    BaseResponseHead *_Head;
    BaseResponseBody *_Body;
}

@property (nonatomic, strong) BaseResponseHead *Head;
@property (nonatomic, strong) BaseResponseBody *Body;

- (BOOL)success;
- (NSString *)message;

@end

// =========================================
