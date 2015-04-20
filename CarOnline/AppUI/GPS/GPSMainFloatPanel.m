//
//  FloatPanel.m
//  CarOnline
//
//  Created by James on 14-8-20.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GPSMainFloatPanel.h"

@implementation GPSMainFloatPanel

#define kTimerInterval 10

#define kHideDuration 10


- (void)dealloc
{
    [self stopRequest];
    [self stopHideTimer];
}

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
    
    _OBD = [UIButton buttonWithType:UIButtonTypeCustom];
    [_OBD setImage:[UIImage imageNamed:@"VRM_i04_006_CarFunction.png"] forState:UIControlStateNormal];
    [_OBD setBackgroundImage:bg forState:UIControlStateNormal];
    [_OBD setBackgroundImage:bg_press forState:UIControlStateHighlighted];
    [_OBD addTarget:self action:@selector(toOBD) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_OBD];
    
    _message = [UIButton buttonWithType:UIButtonTypeCustom];
    [_message setImage:[UIImage imageNamed:@"VRM_i04_007_Message.png"] forState:UIControlStateNormal];
    [_message setBackgroundImage:bg forState:UIControlStateNormal];
    [_message setBackgroundImage:bg_press forState:UIControlStateHighlighted];
    [_message addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_message];


    _badge = [JSCustomBadge customBadgeWithString:@""];
//    _badge.center = CGPointMake(30, 5);
    _badge.hidden = YES;
    _badge.userInteractionEnabled = YES;
    [_message addSubview:_badge];
    _message.clipsToBounds = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessage:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    _zoomAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zoomAdd setImage:[UIImage imageNamed:@"VRM_i04_009_Scale+.png"] forState:UIControlStateNormal];
    [_zoomAdd setBackgroundImage:[UIImage imageNamed:@"VRM_i04_013_ButtonScale.png"] forState:UIControlStateNormal];
    [_zoomAdd setBackgroundImage:[UIImage imageNamed:@"VRM_i04_013_ButtonScalePressed.png"] forState:UIControlStateHighlighted];
    [_zoomAdd addTarget:self action:@selector(toZoomAddMap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_zoomAdd];
    
    _zoomDec = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zoomDec setImage:[UIImage imageNamed:@"VRM_i04_010_Scale-.png"] forState:UIControlStateNormal];
    [_zoomDec setBackgroundImage:[UIImage imageNamed:@"VRM_i04_013_ButtonScaleDec.png"] forState:UIControlStateNormal];
    [_zoomDec setBackgroundImage:[UIImage imageNamed:@"VRM_i04_013_ButtonScaleDecPressed.png"] forState:UIControlStateHighlighted];
    [_zoomDec addTarget:self action:@selector(toZoomDecMap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_zoomDec];
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

- (void)configOwnViews
{
    [self startHideTimer];
}


- (void)startHideTimer
{
    [self stopHideTimer];
    _hideTimer = [NSTimer timerWithTimeInterval:kHideDuration target:self selector:@selector(hideSelf) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_hideTimer forMode:NSRunLoopCommonModes];
}

- (void)hideSelf
{
    [self slideOutTo:kFTAnimationRight duration:1.5 delegate:nil];
}

- (void)stopHideTimer
{
    [_hideTimer invalidate];
    _hideTimer = nil;
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
        
        if (self.hidden)
        {
            [self show];
        }
        
        [self stopHideTimer];
    }
    else
    {
        if (!self.hidden)
        {
            [self startHideTimer];
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
        
        if (![WebServiceEngine sharedEngine].isTracking)
        {
            _timer = [NSTimer timerWithTimeInterval:kTimerInterval target:self selector:@selector(requestUnreadAlertInfo) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }
    else
    {
        [self stopRequest];
        
        [self startRequest];
    }
}

- (void)toCarManage
{
    CarListViewController *car = [NSObject loadClass:[CarListViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:car];
}


- (void)toOBD
{
    OBDMainViewController *obd = [NSObject loadClass:[OBDMainViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:obd];
}

- (void)toMessage
{
    _badge.hidden = YES;
    MessageBoxViewController *msg = [NSObject loadClass:[MessageBoxViewController class]];
    msg.vehicleNumbers = [WebServiceEngine sharedEngine].alertMuilVehicleNumbers;
    [[AppDelegate sharedAppDelegate] pushViewController:msg];
}

- (void)toZoomAddMap
{
    [self startHideTimer];
    if ([_delegate respondsToSelector:@selector(toZoomAddMap)])
    {
        [_delegate toZoomAddMap];
    }
    
}

- (void)toZoomDecMap
{
    [self startHideTimer];
    if ([_delegate respondsToSelector:@selector(toZoomDecMap)])
    {
        [_delegate toZoomDecMap];
    }
}

#define kRightMargin 15
#define kVerPadding 15

- (void)relayoutFrameOfSubViews
{
    [_carManage sizeWith:CGSizeMake(37, 37)];
    [_carManage layoutParentHorizontalCenter];
    
    [_OBD sameWith:_carManage];
    [_OBD layoutBelow:_carManage margin:kVerPadding];
    
    [_message sameWith:_OBD];
    [_message layoutBelow:_OBD margin:kVerPadding];
    
    _badge.center = CGPointMake(_message.bounds.origin.x + _message.bounds.size.width - 7, 7);
    
    [_zoomAdd sameWith:_message];
    [_zoomAdd layoutBelow:_message margin:kVerPadding];
    
    [_zoomDec sameWith:_zoomAdd];
    [_zoomDec layoutBelow:_zoomAdd margin:1];
}


- (void)show
{
    if (self.hidden)
    {
        [self slideInFrom:kFTAnimationRight duration:0.5 delegate:nil];
        [self startHideTimer];
    }
    else
    {
        [self stopHideTimer];
        [self startHideTimer];
    }
}

@end
