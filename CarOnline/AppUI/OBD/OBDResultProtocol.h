//
//  OBDResultProtocol.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^OBDAnimationOverBlock)();



@protocol OBDAnimationAbleView <NSObject>

- (void)startAnimation;

- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block;

@end


@class OBDResultHeaderView;

@protocol OBDResultAbleView <NSObject>


- (OBDResultHeaderView *)headerView;

- (void)showResult:(BaseResponseBody *)body;

- (BOOL)isEnableExpand;
- (BOOL)isExpand;
- (void)setIsExpand:(BOOL)isExpand;

- (NSInteger)unexpandHeight;
- (NSInteger)expandHeight;

- (void)expand;
- (void)withdraw;

@end