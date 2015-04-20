//
//  CarPlaybackFloatPanel.h
//  CarOnline
//
//  Created by James on 14-8-29.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarPlaybackFloatPanelDelegate <NSObject>

- (void)toResumePlayback;

- (void)toPausePlayback;

- (void)toZoomAddMap;

- (void)toZoomDecMap;

@end

@interface CarPlaybackFloatPanel : UIView
{
@protected
    UIButton *_zoomAdd;
    UIButton *_zoomDec;
    UIButton *_playPause;
}

@property (nonatomic, unsafe_unretained) id<CarPlaybackFloatPanelDelegate> delegate;

- (void)setPlayOrPause:(BOOL)isPlay;

@end
