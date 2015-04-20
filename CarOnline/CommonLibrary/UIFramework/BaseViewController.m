//
//  BaseViewController.m
//  TCLSales
//
//  Created by 陈耀武 on 14-1-15.
//  Copyright (c) 2014年 CarOnline. All rights reserved.
//

#import "BaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "FDStatusBarNotifierView.h"
#import "UIViewController+CWStatusBarNotification.h"

#define kUseLocalNotifyButton 0

@interface BaseViewController ()
#if kUseLocalNotifyButton
{
    MenuButton *_localNotification;
}
#endif

@end

@implementation BaseViewController

- (void)dealloc
{
    DebugLog(@"%@", self);
}

#if kSupportMap
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
#if kSupportMap
    _geocodesearch.delegate = self;
#endif
    self.navigationController.navigationBarHidden = NO;
    
}

#if kSupportMap
- (BMKGeoCodeSearch *)geocodesearch
{
    if (!_geocodesearch)
    {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    
    return _geocodesearch;
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        if (result.poiList.count)
        {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                BMKPoiInfo *info = result.poiList[0];
                
                NSString *add = [WebServiceEngine sharedEngine].vehicle.Address;
                
                if ([NSString isEmpty:add])
                {
                    add = info.address;
                }
                
                NSString *city = info.city;
                
                NSRange rang = [add rangeOfString:city];
                if (rang.length > 0)
                {
                    NSString *title = [add substringFromIndex:rang.location + rang.length];
                    
                    NSRange range = [title rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if (range.length > 0)
                    {
                        title = [title substringToIndex:range.location];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.title = title;
                    });
                }
            });
            
        }
    }
}


#endif

- (void)asyncGetAddress:(CLLocationCoordinate2D)loc addressCompletion:(void (^)(NSDictionary *address))action
{
    if (action)
    {
        NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=%@&callback=renderReverse&location=%f,%f&output=json&pois=1", kServerAppKey, loc.latitude, loc.longitude];
        
        NSURL *URL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponce, NSData *data, NSError *error){
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *jsonstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSRange range = [jsonstring rangeOfString:@"renderReverse&&renderReverse("];
                if (range.length)
                {
                    NSString *json = [jsonstring substringAtRange:NSMakeRange(range.location + range.length, jsonstring.length - range.length - range.location - 1)];
                    NSDictionary *dic = [json objectFromJSONString];
                    
                    //                DebugLog(@"responseString = %@", dic);
                    if ([dic[@"status"] integerValue] == 0)
                    {
                        NSDictionary *result = dic[@"result"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            action(result);
                        });
                    }
                }
                
            });
        }];
    }
    
}

- (void)getVehicleAddress:(CLLocationCoordinate2D)loc
{
    __weak typeof(self) ws = self;
    [self asyncGetAddress:loc addressCompletion:^(NSDictionary *result) {
        NSDictionary *address = result[@"addressComponent"];
        ws.title = address[@"street"];
    }];
}

//- (UIView *)localtificationSuperView
//{
//    return self.view;
//}

- (void)hideLocaltification
{
#if kUseLocalNotifyButton
    [_localNotification animation:^(id selfPtr) {
        [_localNotification slideOutTo:kFTAnimationTop duration:0.3 delegate:nil];
    } duration:0.3 completion:^(id selfPtr) {
        [_localNotification.superview removeFromSuperview];
        //        [_localNotification removeFromSuperview];
        _localNotification = nil;
    }];
#endif
}




- (void)showNotification:(UILocalNotification *)notify
{
#if kUseLocalNotifyButton
    [_localNotification setTitle:notify.alertBody forState:UIControlStateNormal];
    if (_localNotification && !_localNotification.hidden) {
        return;
    }
    
    if (!_localNotification)
    {
        _localNotification = [[MenuButton alloc] initWithTitle:notify.alertBody action:^(id<MenuAbleItem> menu) {
            MessageBoxViewController *msg = [NSObject loadClass:[MessageBoxViewController class]];
            msg.vehicleNumbers = [WebServiceEngine sharedEngine].alertMuilVehicleNumbers;
            [[AppDelegate sharedAppDelegate] pushViewController:msg];
        }];
        
        _localNotification.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _localNotification.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_localNotification.titleLabel setFont:[[FontHelper shareHelper] fontWithSize:13]];
        [_localNotification setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_localNotification setBackgroundColor:[kBlackColor colorWithAlphaComponent:0.5]];
        
        
        UIView *bgView = [[UIView alloc] init];
        
        if ([IOSDeviceConfig sharedConfig].isIOS6)
        {
            bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        }
        else
        {
            bgView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
        }
        [self.view addSubview:bgView];
        
        [bgView addSubview:_localNotification];
        
        bgView.clipsToBounds = YES;
        _localNotification.hidden = YES;
        _localNotification.frame = bgView.bounds;
    }
    
    [_localNotification slideInFrom:kFTAnimationTop duration:0.3 delegate:nil];
    
    
    AudioServicesPlaySystemSound(1007);
    //    kSystemSoundID_Vibrate;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(hideLocaltification) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
#else
    AudioServicesPlaySystemSound(1007);
    [self showStatusBarNotification:notify.alertBody forDuration:3];
#endif
}




@end
