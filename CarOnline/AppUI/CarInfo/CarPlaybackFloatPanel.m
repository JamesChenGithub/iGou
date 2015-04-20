//
//  CarPlaybackFloatPanel.m
//  CarOnline
//
//  Created by James on 14-8-29.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarPlaybackFloatPanel.h"

@implementation CarPlaybackFloatPanel

- (void)addOwnViews
{
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
    
    _playPause = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playPause setBackgroundImage:[UIImage imageNamed:@"VRM_i04_011_ButtonCircle.png"] forState:UIControlStateNormal];
    [_playPause setBackgroundImage:[UIImage imageNamed:@"VRM_i04_011_ButtonCirclePressed.png"] forState:UIControlStateHighlighted];
    [_playPause setImage:[UIImage imageNamed:@"playback_pause.png"] forState:UIControlStateNormal];
    [_playPause setImage:[UIImage imageNamed:@"playback_play.png"] forState:UIControlStateSelected];
    [_playPause addTarget:self action:@selector(toPlaypause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playPause];
    
}

- (void)setPlayOrPause:(BOOL)isPlay
{
    _playPause.selected = !isPlay;
}

- (void)toPlaypause:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        // 显示暂停
        if ([_delegate respondsToSelector:@selector(toPausePlayback)])
        {
            [_delegate toPausePlayback];
        }
    }
    else
    {
        // 显示播放
        if ([_delegate respondsToSelector:@selector(toResumePlayback)])
        {
            [_delegate toResumePlayback];
        }
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
    [_zoomAdd sizeWith:CGSizeMake(44, 44)];
    [_zoomAdd alignParentRight];
    [_zoomAdd layoutParentHorizontalCenter];
    
    [_zoomDec sameWith:_zoomAdd];
    [_zoomDec layoutBelow:_zoomAdd margin:1];
    
    [_playPause sameWith:_zoomDec];
    [_playPause layoutBelow:_zoomDec margin:15];
}

@end
