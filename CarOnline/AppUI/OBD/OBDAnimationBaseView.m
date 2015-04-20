//
//  OBDAnimationBaseView.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDAnimationBaseView.h"

@implementation OBDAnimationBaseView

- (void)dealloc
{
    DebugLog(@"");
}


- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = kBlackColor;
    }
    return self;
}

- (void)startAnimation
{
    
}

- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    self.responseBody = body;
    self.animationOver = block;
}

@end
