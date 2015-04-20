//
//  CarRemoteKeyView.m
//  CarOnline
//
//  Created by James on 14-8-31.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarRemoteKeyView.h"

@implementation CarRemoteKeyView

- (void)addOwnViews
{
    _remoteKeyBg = [[UIImageView alloc] init];
    _remoteKeyBg.userInteractionEnabled = YES;
    _remoteKeyBg.image = [UIImage imageNamed:@"car_remoteKey.png"];
    [self addSubview:_remoteKeyBg];
    
    _unlockButton = [[UIButton alloc] init];
    [_unlockButton setImage:[UIImage imageNamed:@"car_button_unlock.png"] forState:UIControlStateNormal];
    [_unlockButton setBackgroundImage:[UIImage imageNamed:@"car_VRM_i04_011_ButtonCircle.png"] forState:UIControlStateNormal];
    [_unlockButton setBackgroundImage:[UIImage imageNamed:@"car_button_bg_press.png"] forState:UIControlStateHighlighted];
    [_unlockButton addTarget:self action:@selector(onUnlock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_unlockButton];
    
    _lockButton = [[UIButton alloc] init];
    [_lockButton setImage:[UIImage imageNamed:@"car_button_lock.png"] forState:UIControlStateNormal];
    [_lockButton setBackgroundImage:[UIImage imageNamed:@"car_VRM_i04_011_ButtonCircle.png"] forState:UIControlStateNormal];
    [_lockButton setBackgroundImage:[UIImage imageNamed:@"car_button_bg_press.png"] forState:UIControlStateHighlighted];
    [_lockButton addTarget:self action:@selector(onLock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lockButton];
    
    
}

- (void)onLock:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(onLockRemoteView:)])
    {
        [_delegate onLockRemoteView:self];
    }
}

- (void)onUnlock:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(onUnlockRemoteView:)])
    {
        [_delegate onUnlockRemoteView:self];
    }
}

#define kRemoteKeySize CGSizeMake(150, 110)
#define kButtonSize CGSizeMake(36, 36)


- (void)relayoutFrameOfSubViews
{
    const CGSize kBGSize = kRemoteKeySize;
    CGRect rect = self.bounds;
    rect = CGRectInset(self.bounds, (rect.size.width - kBGSize.width)/2, (rect.size.height - kBGSize.height)/2);
    _remoteKeyBg.frame = rect;
    
    [_unlockButton sizeWith:kButtonSize];
    [_unlockButton alignTop:_remoteKeyBg margin:-10];
    [_unlockButton alignLeft:_remoteKeyBg margin:25];
    
    [_lockButton sameWith:_unlockButton];
    [_lockButton alignRight:_remoteKeyBg margin:20];
    [_lockButton alignBottom:_remoteKeyBg margin:30];
}

- (void)onRemoteView:(CarRemoteKeyView *)remote onLock:(BOOL)isLock
{
    
}
- (void)onRemoteView:(CarRemoteKeyView *)remote onSecture:(BOOL)isLock
{
    
}

@end
