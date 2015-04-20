//
//  WebServiceEngine.m
//  CarOnline
//
//  Created by James on 14-8-5.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "WebServiceEngine.h"
#import <AudioToolbox/AudioToolbox.h>

@interface WebServiceEngine ()

@property (nonatomic, strong) GetDevListResponseBody *devListBody;

@end

@implementation WebServiceEngine

#define kLastVehicleNumberKey @"DefaultVehicleNumberKey"

static WebServiceEngine *_sharedEngine = nil;
+ (instancetype)sharedEngine
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedEngine = [[WebServiceEngine alloc] init];
    });
    return _sharedEngine;
}

- (void)setVehicleOnMuiltMonitor:(VehicleGPSListItem *)vehicle
{
    _vehicle = vehicle;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:vehicle.DeviceName forKey:kLastVehicleNumberKey];
    [ud synchronize];
}

- (void)setMuilVehicleNumbers:(NSString *)muilVehicleNumbers
{
    _muilVehicleNumbers = muilVehicleNumbers;
}

- (void)setVehicle:(VehicleGPSListItem *)vehicle
{
    self.muilVehicleNumbers = nil;
    
    //    if (_vehicle != nil)
    //    {
    //        self.isTracking = ![vehicle.DeviceName isEqualToString:_vehicle.DeviceName];
    //    }
    
    _vehicle = vehicle;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:vehicle.DeviceName forKey:kLastVehicleNumberKey];
    [ud setObject:[NSNumber numberWithFloat:vehicle.Latidude] forKey:kLastUserLocationLatitude];
    [ud setObject:[NSNumber numberWithFloat:vehicle.Longitude] forKey:kLastUserLocationLongitude];
    [ud synchronize];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.user = [[LoginUser alloc] init];
    }
    return self;
}

- (void)asyncRequest:(BaseRequest *)req
{
    [self asyncRequest:req wait:YES];
}

- (void)asyncRequest:(BaseRequest *)req wait:(BOOL)wait
{
    if (!req)
    {
        return;
    }

    @autoreleasepool
    {
        NSString *url = [req url];
        NSData *data = [req toWebServiceXmlData];
        NSString *soapAction = [req soapAction];
        
        if ([NSString isEmpty:url] || !data || [NSString isEmpty:soapAction])
        {
            DebugLog(@"请求出错了");
            return;
        }
        
        DebugLog(@"reqest URL = %@", url);
        
        NSURL *URL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setValue:[NSString stringWithFormat:@"%ld",(long)[data length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
        
        [request setHTTPBody:data];
        
        if (wait)
        {
            [[HUDHelper sharedInstance] loading];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        __block BOOL bWait = wait;
        __block BaseRequest *baseReq = req;
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponce, NSData *data, NSError *error)
         {
             if (bWait)
             {
                 [[HUDHelper sharedInstance] stopLoading];
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             }
             
             if (error != nil)
             {
                 DebugLog(@"Request = %@, Error = %@", baseReq, error);
                 [[HUDHelper sharedInstance] tipMessage:kRequestError_Str];
                 
                 if (baseReq.failHandler)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         baseReq.failHandler(baseReq);
                     });
                 }
             }
             else
             {
                 NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 DebugLog(@"=========================>>>>>>>>\nresponseString is :\n %@" , responseString);
                 // TODO : 正则表解析XML返回的结果
                 // 改下面这句
                 
                 NSString *jsonString = [responseString valueOfLabel:[baseReq uriKey]];
                 
                 NSDictionary *dic = (NSDictionary *)[jsonString objectFromJSONString];
                 NSDictionary *headDic = [dic objectForKey:@"Head"];
                 baseReq.response.Head = [NSObject parse:[BaseResponseHead class] dictionary:headDic];
                 
                 if ([baseReq.response success])
                 {
                     NSDictionary *bodyDic = [dic objectForKey:@"Body"];
                     [baseReq handleResponseBody:bodyDic];
                 }
                 else
                 {
                     if (baseReq.failHandler)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             baseReq.failHandler(baseReq);
                         });
                     }
                     
                     
                     NSString *message = [baseReq.response message];
                     if (![NSString isEmpty:message])
                     {
                         [[HUDHelper sharedInstance] tipMessage:message];
                     }
                     else
                     {
                         [[HUDHelper sharedInstance] tipMessage:kRequestError_Str];
                     }
                 }
                 
             }
         }];
    }
    
    
}

- (void)setIsTracking:(BOOL)isTracking
{    
    if (_isTracking != isTracking)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTrackChangedNotify object:nil userInfo:nil];
    }
    
    _isTracking = isTracking;
    
}

- (void)resetAlertMuilVehicleNumbers
{
    NSMutableArray *groupList = self.devListBody.GroupList;
    NSMutableString *vehNums = [NSMutableString string];
    for (GroupListItem *item in groupList)
    {
        for (VehicleGPSListItem *veh in item.VehicleList)
        {
            [vehNums appendString:[NSString stringWithFormat:@"%@,", veh.VehicleNumber]];
        }
    }
    
    self.alertMuilVehicleNumbers = [vehNums substringAtRange:NSMakeRange(0, vehNums.length - 1)];
}

void playFinished(SystemSoundID ssID, void* clientData)
{
    AudioServicesRemoveSystemSoundCompletion(ssID);
    AudioServicesDisposeSystemSoundID(ssID);
}


#define kOverSpeedDrivingCount @"kOverSpeedDrivingCount"

- (void)setGPSVehicleFrom:(GetGpsDataResponseBody *)body
{
    for (VehicleGPSListItem *item in body.VehicleGPSList)
    {
        if ([item.DeviceName isEqualToString:self.vehicle.DeviceName])
        {
            self.vehicle = item;
            
            if (self.vehicle.VehicleSpeed > self.vehicle.SpeedAlert)
            {
                NSInteger osc = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"kOverSpeedDrivingCount"] integerValue];
                
                if (osc < 3)
                {
                    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
                    {
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        NSDate *now = [NSDate new];
                        notification.fireDate = now;
                        //                    notification.soundName= UILocalNotificationDefaultSoundName;
                        notification.alertBody = [NSString stringWithFormat:kLocalOverSpeedNotificationFormat_Str, self.vehicle.DeviceName];
                        
                        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:2000], @"LocalNotificationKey", nil];
                        [notification setUserInfo:dict];
                        [[AppDelegate sharedAppDelegate] addNotification:notification];
                    }
                    
                    
                    // 要播放的音频文件地址
                    NSString *urlPath = [AppDelegate sharedAppDelegate].isChinese ? [[NSBundle mainBundle] pathForResource:@"overspeed" ofType:@"wav"] : [[NSBundle mainBundle] pathForResource:@"overspeed_en" ofType:@"wav"];
                    
                    NSURL *url = [NSURL fileURLWithPath:urlPath];
                    
                    // 声明需要播放的音频文件ID[unsigned long]
                    SystemSoundID ID;
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
                    AudioServicesAddSystemSoundCompletion(ID, NULL, NULL, &playFinished, (__bridge void *)(self));
                    AudioServicesPlaySystemSound(ID);
                    //                [application cancelLocalNotification:notification];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:++osc] forKey:kOverSpeedDrivingCount];
                    
                }
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:kOverSpeedDrivingCount];
            }
            
            break;
        }
    }
}

- (void)setVehicleFrom:(GetDevListResponseBody *)body
{
    self.devListBody = body;
    [self resetAlertMuilVehicleNumbers];
    
    NSString *lastKey = [[NSUserDefaults standardUserDefaults] valueForKey:kLastVehicleNumberKey];
    NSMutableArray *groupList = body.GroupList;
    if ([NSString isEmpty:lastKey])
    {
        if (groupList.count)
        {
            GroupListItem *item = groupList[0];
            
            if (item.VehicleList.count)
            {
                VehicleGPSListItem *veh = item.VehicleList[0];
                self.vehicle = veh;
            }
        }
    }
    else
    {
        BOOL hasFind = NO;
        
        for (GroupListItem *item in groupList)
        {
            for (VehicleGPSListItem *veh in item.VehicleList)
            {
                if ([veh.DeviceName isEqualToString:lastKey]) {
                    hasFind = YES;
                    self.vehicle = veh;
                    break;
                }
            }
            
            if (hasFind)
            {
                break;
            }
        }
        
        if (!hasFind)
        {
            if (groupList.count)
            {
                GroupListItem *item = groupList[0];
                
                if (item.VehicleList.count)
                {
                    VehicleGPSListItem *veh = item.VehicleList[0];
                    self.vehicle = veh;
                }
            }
        }
    }
}

- (BOOL)isMuiltMonitor
{
    return ![NSString isEmpty:self.muilVehicleNumbers];
}

#define kUnreadAlertStartId @"UnreadAlertStartId"

- (void)setStartAlertId:(NSString *)startAlertId
{
    if ([NSString isEmpty:startAlertId])
    {
        return;
    }
    
    _startAlertId = startAlertId;
    
    [[NSUserDefaults standardUserDefaults] setObject:_startAlertId forKey:kUnreadAlertStartId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)startAlertId
{
    if ([NSString isEmpty:_startAlertId])
    {
        NSString *startID = [[NSUserDefaults standardUserDefaults] objectForKey:kUnreadAlertStartId];
        
        if ([NSString isEmpty:startID])
        {
            _startAlertId = @"0";
        }
        else
        {
            _startAlertId = startID;
        }
    }
    
    return _startAlertId;
}


@end

