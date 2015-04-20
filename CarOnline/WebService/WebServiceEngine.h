//
//  WebServiceEngine.h
//  CarOnline
//
//  Created by James on 14-8-5.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "MKNetworkEngine.h"

@class BaseRequest;

@interface WebServiceEngine : NSObject<NSObject>
{
@protected
    NSString    *_startAlertId;
}

@property (nonatomic, strong) LoginUser *user;

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@property (nonatomic, copy) NSString *muilVehicleNumbers;

@property (nonatomic, copy) NSString *alertMuilVehicleNumbers;

@property (nonatomic, assign) BOOL isTracking;

@property (nonatomic, copy) NSString *startAlertId;

+ (instancetype)sharedEngine;

- (void)asyncRequest:(BaseRequest *)req;

- (void)asyncRequest:(BaseRequest *)req wait:(BOOL)wait;

- (void)setVehicleFrom:(GetDevListResponseBody *)body;

- (void)setGPSVehicleFrom:(GetGpsDataResponseBody *)body;

- (BOOL)isMuiltMonitor;

- (void)setVehicleOnMuiltMonitor:(VehicleGPSListItem *)vehicle;

@end
