//
//  FloatPanel.h
//  CarOnline
//
//  Created by James on 14-8-20.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GPSMainFloatPanelDelegate <NSObject>


//- (void)toCarManage;
//
//- (void)toOBD;
//
//- (void)toMessage;

- (void)toZoomAddMap;

- (void)toZoomDecMap;

@end

@interface GPSMainFloatPanel : UIView<UIGestureRecognizerDelegate>
{
@protected
    UIButton *_carManage;
    UIButton *_OBD;
    UIButton *_message;
    JSCustomBadge *_badge;
    UIButton *_zoomAdd;
    UIButton *_zoomDec;
    
    NSTimer *_timer;
    NSTimer *_hideTimer;
}

@property (nonatomic, unsafe_unretained) id<GPSMainFloatPanelDelegate> delegate;

- (void)show;

- (void)startRequest;

- (void)stopRequest;


@end
