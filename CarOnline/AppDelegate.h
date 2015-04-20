//
//  AppDelegate.h
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#if kSupportMap
@interface AppDelegate : BaseAppDelegate<BMKGeneralDelegate>
#else
@interface AppDelegate : BaseAppDelegate
#endif
{
#if kSupportMap
    BMKMapManager *_mapManager;
#endif
}

@property (nonatomic, readonly) BOOL isChinese;



//- (void)onLogin;
//
//- (void)onToOBDMain;
//
//- (void)onToCarInfo;

- (void)toGPSMain;


- (void)addNotification:(UILocalNotification *)notify;

@end
