//
//  DatePickerPopupContentView.h
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "PopupView.h"

@interface DateTimePickerPopupContentView : PopupContentView
{
    UILabel *_title;
    UIDatePicker  *_pickerView;
    
    UIButton *_clearButton;
    UIButton *_cancel;
    UIButton *_confirm;
}

@property (nonatomic, readonly) UIDatePicker *pickerView;

@property (nonatomic, copy) CommonBlock doneAction;
@property (nonatomic, copy) CommonBlock clearAction;

- (instancetype)initWithDate:(NSDate *)date dateDone:(CommonBlock)block clear:(CommonBlock)ca;
- (instancetype)initWithDate:(NSDate *)date timeDone:(CommonBlock)block clear:(CommonBlock)ca;

- (NSDate *)selectDate;

@end
