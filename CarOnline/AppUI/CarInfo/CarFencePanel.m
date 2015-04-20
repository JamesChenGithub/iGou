//
//  CarFencePanel.m
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarFencePanel.h"

@implementation CarFencePanel

- (void)setFenceState:(BOOL)isFenceEnable
{
    _fence.selected = isFenceEnable;
    if (isFenceEnable)
    {
        [_fence setTitle:kCarFencePanel_Close_Str forState:UIControlStateNormal];
    }
    else
    {
        [_fence setTitle:kCarFencePanel_Open_Str forState:UIControlStateNormal];
    }
}

- (void)switchState
{
    [self setFenceState:!_fence.selected];
}

- (void)addOwnViews
{
    _fence = [[UIButton alloc] init];
//    [_fence setBackgroundColor:[kBlackColor colorWithAlphaComponent:0.6]];
    [_fence setBackgroundImage:[UIImage imageNamed:@"fenceButton_noPress.png"] forState:UIControlStateNormal];
    [_fence setBackgroundImage:[UIImage imageNamed:@"fenceButton_Pressed.png"] forState:UIControlStateHighlighted];
//    _fence.showsTouchWhenHighlighted = YES;
    [_fence setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _fence.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_fence addTarget:self action:@selector(onFence:) forControlEvents:UIControlEventTouchUpInside];
    _fence.layer.cornerRadius = 5;
    _fence.layer.masksToBounds = YES;
    [self addSubview:_fence];
    
    
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

- (void)onFence:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(setElectronicFence:)])
    {
        [_delegate setElectronicFence:button.selected];
    }
}

- (void)toZoomAddMap
{
    if ([_delegate respondsToSelector:@selector(toZoomAddMap)])
    {
        [_delegate toZoomAddMap];
    }
    
}

- (void)toZoomDecMap
{
    if ([_delegate respondsToSelector:@selector(toZoomDecMap)])
    {
        [_delegate toZoomDecMap];
    }
}

- (void)relayoutFrameOfSubViews
{
    CGRect bounds = self.bounds;
    [_fence sizeWith:CGSizeMake(bounds.size.width, 44)];
    
    [_zoomAdd sizeWith:CGSizeMake(44, 44)];
    [_zoomAdd layoutBelow:_fence margin:20];
    [_zoomAdd alignParentRight];
    
    [_zoomDec sameWith:_zoomAdd];
    [_zoomDec layoutBelow:_zoomAdd margin:1];
}

@end
