//
//  OBDFloatPanel.h
//  CarOnline
//
//  Created by James on 14-8-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDFloatPanel : UIView<UIGestureRecognizerDelegate>
{
    UIButton *_carManage;
    UIButton *_gps;
    UIButton *_message;
    JSCustomBadge *_badge;
    UIButton *_info;
    
    NSTimer *_timer;
}

- (void)startRequest;

- (void)stopRequest;

@end
