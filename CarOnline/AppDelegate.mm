//
//  AppDelegate.m
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "AppDelegate.h"

#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    UIBackgroundTaskIdentifier bgTaskId;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *localNotifications;

@end


@implementation AppDelegate


- (void)addNotification:(UILocalNotification *)notify
{
    NSInteger key = [(NSNumber *)[[notify userInfo] objectForKey:@"LocalNotificationKey"] integerValue];
    
    NSMutableArray *array = [NSMutableArray array];
    for (UILocalNotification *ln in self.localNotifications)
    {
        if ([(NSNumber *)[[ln userInfo] objectForKey:@"LocalNotificationKey"] integerValue] == key)
        {
            [array addObject:ln];
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
    
    [self.localNotifications removeObjectsInArray:array];
    [self.localNotifications addObject:notify];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
}

- (void)checkLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [allLanguages objectAtIndex:0];
    _isChinese = [preferredLang isEqualToString:@"zh-Hans"] || [preferredLang isEqualToString:@"zh-HK"] || [preferredLang isEqualToString:@"zh-Hant"];
    
#if DEBUG
#if kSupportGMap
//    _isChinese = NO;
#endif
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self checkLanguage];
    
    if (_isChinese)
    {
#if kSupportMap
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = [[BMKMapManager alloc] init];
        BOOL ret = [_mapManager start:kClientAppKey generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
#endif
    }
    else
    {
        [GMSServices provideAPIKey:kGoogleMapAppKey];
        [GMSServices sharedServices];
//        NSString *license = [GMSServices openSourceLicenseInfo];
    }
    
    self.localNotifications = [NSMutableArray array];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)enterMainUI
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // 进入主界面
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hasShow = ((NSNumber *)[ud objectForKey:kHasShowTutorial]).boolValue;
    if (!hasShow)
    {
        // 没有显示过tutorial，则显示tutorial
        TutorialViewController *login = [NSObject loadClass:[TutorialViewController class]];
        self.window.rootViewController = login;
        return;
    }
    
    if (![CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }

//    NSString *username = [ud objectForKey:kAppLoginUserIDKey];
//    NSString *pwd = [ud objectForKey:kAppLoginUserPWDKey];
//    if (![NSString isEmpty:username] && ![NSString isEmpty:pwd])
//    {
//        APPLogin *applogin = [[APPLogin alloc] initWithHandler:^(BaseRequest *request) {
//            WebServiceEngine *wse = [WebServiceEngine sharedEngine];
//            APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
//            wse.user.UserName = body.UserName;
//            wse.user.UserCode = body.UserCode;
//            wse.user.Password = pwd;
//            
//            [[AppDelegate sharedAppDelegate] toGPSMain];
//        }];
//        applogin.UserName = username;
//        applogin.Password = pwd;
//        
//        applogin.failHandler = ^(BaseRequest *request) {
//            LoginViewController *login = [NSObject loadClass:[LoginViewController class]];
//            self.window.rootViewController = login;
//        };
//        
//        [[WebServiceEngine sharedEngine] syncRequest:applogin];
//    }
//    else
//    {
    
        // 进入登录界面
        LoginViewController *login = [NSObject loadClass:[LoginViewController class]];
        self.window.rootViewController = login;
//    }
}

//==========================================
// 测试代码
//- (void)enterTestNet
//{
//    TestServerViewController *info = [NSObject loadClass:[TestServerViewController class]];
//    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
//    self.window.rootViewController = nav;
//}
//
//- (void)onLogin
//{
//    AppInfoViewController *info = [NSObject loadClass:[AppInfoViewController class]];
//    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
//    self.window.rootViewController = nav;
//}
//
//- (void)onToOBDMain
//{
//    OBDMainViewController *info = [NSObject loadClass:[OBDMainViewController class]];
//    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
//    self.window.rootViewController = nav;
//}
//
//- (void)onToCarInfo
//{
//    CarInfoViewController *info = [NSObject loadClass:[CarInfoViewController class]];
//    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
//    self.window.rootViewController = nav;
//}
//
//======================================


// 到主界面
- (void)toGPSMain
{
    
#if kSupportGMap
    if ([AppDelegate sharedAppDelegate].isChinese)
    {
        GPSMainViewController *info = [NSObject loadClass:[GPSMainViewController class]];
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
        self.window.rootViewController = nav;
    }
    else
    {
#if kSupportGoogleMap
        GPSGoogleMapMainViewController *info = [NSObject loadClass:[GPSGoogleMapMainViewController class]];
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
        self.window.rootViewController = nav;
#else
        GMapGPSMainViewController *info = [NSObject loadClass:[GMapGPSMainViewController class]];
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
        self.window.rootViewController = nav;
#endif
    }
#else
    GPSMainViewController *info = [NSObject loadClass:[GPSMainViewController class]];
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:info];
    self.window.rootViewController = nav;
#endif

    
    if ([IOSDeviceConfig sharedConfig].isIOS7Later)
    {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app currentUserNotificationSettings].types == UIUserNotificationTypeNone)
        {
            UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound  categories:nil];
            [app registerUserNotificationSettings:setting];
        }
    }
}


#if kSupportMap
#pragma mark - 

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"授权成功");
    }
    else
    {
//        NSLog(@"onGetPermissionState %d",iError);
        
//        AlertPopup *pop = [[AlertPopup alloc] init]
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"授权失败" delegate:nil cancelButtonTitle:kOK_Str otherButtonTitles:nil, nil];
//        [alert show];
        
        AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kBaiduMapAuthorization_Failed_Str];
        [alert addButtonWithTitle:kOK_Str];
        
        [PopupView alertInWindow:alert];
    }
}
#endif

//void playFinished(SystemSoundID ssID, void* clientData)
//{
//    AudioServicesRemoveSystemSoundCompletion(ssID);
//    AudioServicesDisposeSystemSoundID(ssID);
//}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([(NSNumber *)[[notification userInfo] objectForKey:@"LocalNotificationKey"] integerValue] == 2000)
    {
        // 要播放的音频文件地址
        [application cancelLocalNotification:notification];
        return;
    }
    
    if (application.applicationState == UIApplicationStateActive)
    {
        UIViewController *vc = [AppDelegate sharedAppDelegate].navigationViewController.topViewController;
        if ([vc respondsToSelector:@selector(showNotification:)])
        {
            [vc performSelector:@selector(showNotification:) withObject:notification];
        }
    }
    else
    {
        [application cancelAllLocalNotifications];
        UIViewController *vc = [AppDelegate sharedAppDelegate].navigationViewController.topViewController;
        if ([vc isKindOfClass:[MessageBoxViewController class]])
        {
            [vc configOwnViews];
        }
        else
        {
            MessageBoxViewController *msg = [NSObject loadClass:[MessageBoxViewController class]];
            msg.vehicleNumbers = [WebServiceEngine sharedEngine].alertMuilVehicleNumbers;
            [[AppDelegate sharedAppDelegate] pushViewController:msg];
        }
    }
}

////本地推送通知
//-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    //成功注册registerUserNotificationSettings:后，回调的方法
//    NSLog(@"%@",notificationSettings);
//}

//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    //收到本地推送消息后调用的方法
//    NSLog(@"%@",notification);
//}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    NSLog(@"%@----%@",identifier,notification);
    
    completionHandler();//处理完消息，最后一定要调用这个代码块
    
}

//远程推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //向APNS注册成功，收到返回的deviceToken
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //向APNS注册失败，返回错误信息error
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到远程推送通知消息
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
}


//当程序从后台将要重新回到前台时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    bgTaskId = UIBackgroundTaskInvalid;
    [self resignFirstResponder];
}

//当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //设置后台播放
    UIViewController *root = self.navigationViewController.viewControllers[0];
    if ([root respondsToSelector:@selector(requestOnViewWillAppear)])
    {
        [root performSelector:@selector(requestOnViewWillAppear) withObject:nil];
    }
    
    bgTaskId = [application beginBackgroundTaskWithExpirationHandler: ^{
        
        [application endBackgroundTask:bgTaskId];
    }];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DebugLog(@"location update from (%@) to (%@)", oldLocation, newLocation);
}

@end
