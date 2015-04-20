//
//  OBDFloatPanel.m
//  CarOnline
//
//  Created by James on 14-8-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDFloatPanel.h"

@implementation OBDFloatPanel

#define kTimerInterval 10

- (void)addOwnViews
{
    UIImage *bg = [UIImage imageNamed:@"VRM_i04_011_ButtonCircle.png"];
    UIImage *bg_press = [UIImage imageNamed:@"VRM_i04_011_ButtonCirclePressed.png"];
    
    _carManage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_carManage setImage:[UIImage imageNamed:@"VRM_i04_005_DeviceSel.png"] forState:UIControlStateNormal];
    [_carManage setBackgroundImage:bg forState:UIControlStateNormal];
    [_carManage setBackgroundImage:bg_press forState:UIControlStateHighlighted];
    [_carManage addTarget:self action:@selector(toCarManage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_carManage];
    
    _gps = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gps setImage:[UIImage imageNamed:@"VRM_i09_001_PositionGPS.png"] forState:UIControlStateNormal];
    [_gps setBackgroundImage:bg forState:UIControlStateNormal];
    [_gps setBackgroundImage:bg_press forState:UIControlStateHighlighted];
    [_gps addTarget:self action:@selector(toGPS) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gps];
    
    _message = [UIButton buttonWithType:UIButtonTypeCustom];
    [_message setImage:[UIImage imageNamed:@"VRM_i04_007_Message.png"] forState:UIControlStateNormal];
    [_message setBackgroundImage:bg forState:UIControlStateNormal];
    [_message setBackgroundImage:bg_press forState:UIControlStateHighlighted];
    [_message addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_message];
    
    _badge = [JSCustomBadge customBadgeWithString:@""];
    _badge.userInteractionEnabled = YES;
    _badge.hidden = YES;
    [_message addSubview:_badge];
    _message.clipsToBounds = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessage:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    _info = [UIButton buttonWithType:UIButtonTypeCustom];
    [_info setImage:[UIImage imageNamed:@"VRM_i09_002_AppSystem.png"] forState:UIControlStateNormal];
    [_info setBackgroundImage:bg forState:UIControlStateNormal];
    [_info setBackgroundImage:bg_press forState:UIControlStateHighlighted];
    [_info addTarget:self action:@selector(toAppInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_info];
    
}

- (void)toMessage:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self toMessage];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint loc = [touch locationInView:self];
    
    CGRect msgRect = _message.frame;
    msgRect = CGRectInset(msgRect, -15, -15);
    BOOL ret = CGRectContainsPoint(msgRect, loc);
    return ret;
}


- (void)toCarManage
{
    CarListViewController *car = [NSObject loadClass:[CarListViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:car];
}


- (void)toGPS
{
    [[AppDelegate sharedAppDelegate] popToRootViewController];
}

- (void)toMessage
{
    _badge.hidden = YES;
    MessageBoxViewController *msg = [NSObject loadClass:[MessageBoxViewController class]];
    msg.vehicleNumbers = [WebServiceEngine sharedEngine].alertMuilVehicleNumbers;
    [[AppDelegate sharedAppDelegate] pushViewController:msg];
}

- (void)toAppInfo
{
    AppInfoViewController *app = [NSObject loadClass:[AppInfoViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:app];
}

//- (void)toDeviceInfo
//{
//    CarInfoViewController *info = [NSObject loadClass:[CarInfoViewController class]];
//    [[AppDelegate sharedAppDelegate] pushViewController:info];
//}


#define kRightMargin 15
#define kVerPadding 15

- (void)relayoutFrameOfSubViews
{
    [_carManage sizeWith:CGSizeMake(37, 37)];
    [_carManage layoutParentHorizontalCenter];
    
    [_gps sameWith:_carManage];
    [_gps layoutBelow:_carManage margin:kVerPadding];
    
    [_message sameWith:_gps];
    [_message layoutBelow:_gps margin:kVerPadding];
    
    _badge.center = CGPointMake(_message.bounds.origin.x + _message.bounds.size.width - 7, 7);
    
    [_info sameWith:_message];
    [_info layoutBelow:_message margin:kVerPadding];
}

- (void)stopRequest
{
    [_timer invalidate];
    _timer = nil;
}


- (void)showBadge:(GetUnreadAlarminfoCountResponseBody *)alert
{
    NSInteger count = alert.AlertCount;
    if (count > 99)
    {
        [_badge autoBadgeSizeWithString:@"···"];
    }
    else
    {
        [_badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d", count]];
    }
    
    _badge.hidden = count == 0;
    
    if (count > 0)
    {
        NSInteger lastCount = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kUnreadAlertCountKey] integerValue];
        if (lastCount != count)
        {
            [self showNotify:count];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:kUnreadAlertCountKey];
        }
    }    
}

- (void)showNotify:(NSInteger)count
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDate *now = [NSDate new];
    notification.fireDate = now;
    notification.soundName= UILocalNotificationDefaultSoundName;
    notification.alertBody = [NSString stringWithFormat:kLocalNotificationFormat_Str, count];
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1000], @"LocalNotificationKey",nil];
    [notification setUserInfo:dict];
    
    [[AppDelegate sharedAppDelegate] addNotification:notification];
}


- (void)requestUnreadAlertInfo
{
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    if (![NSString isEmpty:we.vehicle.VehicleNumber])
    {
        __weak typeof(self) weakSelf = self;
        GetUnreadAlarminfoCount *gua = [[GetUnreadAlarminfoCount alloc] initWithHandler:^(BaseRequest *request) {
            GetUnreadAlarminfoCountResponseBody *body = (GetUnreadAlarminfoCountResponseBody *)request.response.Body;
            [weakSelf showBadge:body];
        }];
        gua.VehicleNumbers = we.alertMuilVehicleNumbers;
        
        [we asyncRequest:gua wait:NO];
    }
}

- (void)startRequest
{
    if (_timer == nil)
    {
        [self requestUnreadAlertInfo];
        
        _timer = [NSTimer timerWithTimeInterval:kTimerInterval target:self selector:@selector(requestUnreadAlertInfo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else
    {
        [self stopRequest];
        
        [self startRequest];
    }
}
@end
