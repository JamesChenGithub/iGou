//
//  CarFencePanel.h
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarFencePanelDelegate <NSObject>


//- (void)toCarManage;
//
//- (void)toOBD;
//
//- (void)toMessage;

- (void)setElectronicFence:(BOOL)enable;

- (void)toZoomAddMap;

- (void)toZoomDecMap;

@end

@interface CarFencePanel : UIView
{
@protected
    UIButton *_fence;
    UIButton *_zoomAdd;
    UIButton *_zoomDec;
}

@property (nonatomic, unsafe_unretained) id<CarFencePanelDelegate> delegate;

@property (nonatomic, readonly) UIButton *fence;

- (void)setFenceState:(BOOL)isFenceEnable;
- (void)switchState;

@end
