//
//  CarRemoteKeyView.h
//  CarOnline
//
//  Created by James on 14-8-31.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarRemoteKeyView;

@protocol CarRemoteKeyViewDelegate <NSObject>

- (void)onUnlockRemoteView:(CarRemoteKeyView *)remote;
- (void)onLockRemoteView:(CarRemoteKeyView *)remote;
@end

@interface CarRemoteKeyView : UIView
{
    UIImageView *_remoteKeyBg;
    UIButton *_unlockButton;
    UIButton *_lockButton;
}

@property (nonatomic, readonly) UIButton *unlockButton;
@property (nonatomic, readonly) UIButton *lockButton;

@property (nonatomic, unsafe_unretained) id<CarRemoteKeyViewDelegate> delegate;

@end
