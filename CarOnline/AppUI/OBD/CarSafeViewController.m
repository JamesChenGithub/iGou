//
//  CarSafeViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarSafeViewController.h"

@interface CarSafeViewController ()

@property (nonatomic, strong) GetSafetyResponseBody *safetyBody;
@property (nonatomic, strong) GetSecurityResponseBody *securityBody;

@property (nonatomic, strong) CarSafeView *safeView;

@end

@implementation CarSafeViewController

- (void)onGetSafety:(GetSafetyResponseBody *)body
{
    self.safetyBody = body;
    
    NSInteger type = [body.Type integerValue];

    if (type <= 1)
    {
        _safeView.safeSate = E_All_Off;
    }
    else if (type == 2)
    {
        [_safeView setVibCar:[UIImage imageNamed:@"vibCar.png"]];
    }
    
    NSString *value = body.Info;
    
    if (![NSString isEmpty:value] && value.length >= 6)
    {
        const char *valueChars = [value cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger state = 0;
        if (valueChars[0] == '1')
        {
            state += 8;
        }
        
        if (valueChars[1] == '1')
        {
            state += 4;
        }
        
        if (valueChars[2] == '1')
        {
            state += 2;
        }
        
        if (valueChars[3] == '1')
        {
            state += 1;
        }
        
        
        _safeView.safeSate = state;
        
        _safeView.lightImageView.hidden = valueChars[4] == '0' ? YES : NO;
        _safeView.tailBoxImageView.hidden = valueChars[5] == '0' ? YES : NO;
    }
    
    if (self.securityBody.IsSecurity)
    {
        _safeView.safeSate = E_All_Off;
    }
    
}

- (void)onGetSecurity:(GetSecurityResponseBody *)body
{
    self.securityBody = body;
    [_safeView setLock:self.securityBody.IsSecurity];
    
    if (self.securityBody.IsSecurity)
    {
        _safeView.safeSate = E_All_Off;
    }
    
}

- (void)addOwnViews
{
    _safeView = [[CarSafeView alloc] init];
    [self.view addSubview:_safeView];
    
    _remoteView = [[CarRemoteKeyView alloc] init];
    _remoteView.delegate = self;
    [self.view addSubview:_remoteView];
}

- (void)configOwnViews
{
    
    __weak typeof(self) weakSelf = self;
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    
    GetSecurity *gsc = [[GetSecurity alloc] initWithHandler:^(BaseRequest *request) {
        GetSecurityResponseBody *body = (GetSecurityResponseBody *)request.response.Body;
        [weakSelf onGetSecurity:body];
    }];
    [we asyncRequest:gsc];
    
    GetSafety *gs = [[GetSafety alloc] initWithHandler:^(BaseRequest *request) {
        GetSafetyResponseBody *body = (GetSafetyResponseBody *)request.response.Body;
        [weakSelf onGetSafety:body];
    }];
    [we asyncRequest:gs];
}

- (void)layoutOnIPhone
{
    CGRect bounds = self.view.bounds;
    
    
    [_remoteView sizeWith:CGSizeMake(bounds.size.width, 110)];
    [_remoteView alignParentBottom];
    [_remoteView relayoutFrameOfSubViews];
    
    [_safeView sizeWith:CGSizeMake(bounds.size.width, bounds.size.height - 110)];
    [_safeView relayoutFrameOfSubViews];
}

- (void)onUnlockRemoteView:(CarRemoteKeyView *)remote
{
    if (!self.securityBody.IsSecurity)
    {
        __weak typeof(self) weakSelf = self;
        SetSecurity *ss = [[SetSecurity alloc] initWithHandler:^(BaseRequest *request) {
            
            if ([request.response success])
            {
                weakSelf.securityBody.IsSecurity = YES;
                [weakSelf.safeView setLock:weakSelf.securityBody.IsSecurity];
                [weakSelf.safeView setSafeSate:E_All_Off];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearCarWarningNotify" object:nil userInfo:nil];
            }
            
//            [[HUDHelper sharedInstance] tipMessage:[request.response message]];
            
        }];
        ss.IsSecurity = 1;
        [[WebServiceEngine sharedEngine] asyncRequest:ss];
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:@"已经是解防状态。"];
    }
}

- (void)onLockRemoteView:(CarRemoteKeyView *)remote
{
    if (self.securityBody.IsSecurity)
    {
        __weak typeof(self) weakSelf = self;
        SetSecurity *ss = [[SetSecurity alloc] initWithHandler:^(BaseRequest *request) {
            
            if ([request.response success])
            {
                weakSelf.securityBody.IsSecurity = NO;
                [weakSelf.safeView setLock:weakSelf.securityBody.IsSecurity];
            }
            
//            [[HUDHelper sharedInstance] tipMessage:[request.response message]];
            
        }];
        ss.IsSecurity = 0;
        [[WebServiceEngine sharedEngine] asyncRequest:ss];
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:@"已经是设防状态。"];
    }

}

@end
