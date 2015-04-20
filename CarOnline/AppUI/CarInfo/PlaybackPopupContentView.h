//
//  PlaybackPopupContentView.h
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "PopupView.h"

@class PlaybackPopupContentView;

typedef void (^PlaybackPopupDoneAction)(PlaybackPopupContentView *pop, NSString *fromTime, NSString *toTime);

@interface PlaybackPopupContentView : PopupContentView
{
    UILabel *_title;
    UIButton *_dateButton;
    UIButton *_fromTime;
    UILabel  *_interLabel;
    UIButton *_toTime;
    
    UIButton *_cancel;
    UIButton *_confirm;
}

@property (nonatomic, copy) PlaybackPopupDoneAction doneAction;

- (instancetype)initWithDone:(PlaybackPopupDoneAction)block;

//- (NSString *)fromTimeString;
//
//- (NSString *)toTimeString;

@end
