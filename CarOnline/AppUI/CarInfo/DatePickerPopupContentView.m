//
//  DatePickerPopupContentView.m
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "DatePickerPopupContentView.h"

@implementation DateTimePickerPopupContentView


// 日期选择框
- (instancetype)initWithDate:(NSDate *)date dateDone:(CommonBlock)block clear:(CommonBlock)ca
{
    if (self = [super init])
    {
        self.doneAction = block;
        self.clearAction = ca;
        
        _pickerView = [[UIDatePicker alloc] init];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        _pickerView.backgroundColor = [UIColor flatWhiteColor];
        _pickerView.date = date ? date : [NSDate date];
        _pickerView.maximumDate = [NSDate date];
        [self addSubview:_pickerView];
        
    }
    return self;
}

// 时间选择框
- (instancetype)initWithDate:(NSDate *)date timeDone:(CommonBlock)block clear:(CommonBlock)ca
{
    if (self = [super init])
    {
        self.doneAction = block;
        self.clearAction = ca;
        
        _pickerView = [[UIDatePicker alloc] init];
        _pickerView.datePickerMode = UIDatePickerModeTime;
        _pickerView.backgroundColor = [UIColor flatWhiteColor];
        _pickerView.date = date ? date : [NSDate date];
//        _pickerView.maximumDate = [NSDate date];
        [self addSubview:_pickerView];
        
//        NSDate *date = [NSDate new];
//        // Split up the date components
//        NSDateComponents *time = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
//        NSInteger seconds = ([time hour] * 60 * 60) + ([time minute] * 60);
//        
//        UIDatePicker *picker = [UIDatePicker new];
//        [picker setDatePickerMode:UIDatePickerModeCountDownTimer];
//        [picker setCountDownDuration:seconds];
//        [self addSubview:picker];
//        _pickerView = picker;
    }
    return self;
}



- (void)addOwnViews
{
    _title = [[UILabel alloc] init];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [[FontHelper shareHelper] boldFontWithSize:18];
    _title.text = kDatePickerPopup_Title_Str;
    _title.backgroundColor = kClearColor;
    _title.textColor = kWhiteColor;
    [self addSubview:_title];
    
    
    _clearButton = [[UIButton alloc] init];
    [_clearButton setTitle:kDatePickerPopup_Clear_Str forState:UIControlStateNormal];
    [_clearButton setBackgroundImage:[UIImage imageWithColor:kAlertButtonNormalColor] forState:UIControlStateNormal];
    [_clearButton setBackgroundImage:[UIImage imageWithColor:kAlertButtonPressedColor] forState:UIControlStateHighlighted];
    [_clearButton addTarget:self action:@selector(onClear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clearButton];
    
    
    _cancel = [[UIButton alloc] init];
    [_cancel setTitle:kCancel_Str forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [_cancel setBackgroundImage:[UIImage imageWithColor:kAlertButtonNormalColor] forState:UIControlStateNormal];
    [_cancel setBackgroundImage:[UIImage imageWithColor:kAlertButtonPressedColor] forState:UIControlStateHighlighted];
    [self addSubview:_cancel];
    
    _confirm = [[UIButton alloc] init];
    [_confirm setTitle:kOK_Str forState:UIControlStateNormal];
    [_confirm addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [_confirm setBackgroundImage:[UIImage imageWithColor:kAlertButtonNormalColor] forState:UIControlStateNormal];
    [_confirm setBackgroundImage:[UIImage imageWithColor:kAlertButtonPressedColor] forState:UIControlStateHighlighted];
    [self addSubview:_confirm];
    
    _showSize = [self showSize];
    self.layer.cornerRadius = 8;
    self.backgroundColor = kAppModalBackgroundColor;
    self.clipsToBounds = YES;
}

- (void)onClear
{
    // 清空回调处理
    if (_clearAction)
    {
        _clearAction(self);
    }
}

- (void)onCancel
{
    
    [self closePopup];
}

- (void)onConfirm
{
    if (_doneAction)
    {
        _doneAction(self);
    }
    
    [self closePopup];
}

#define kTitleHeight 44
#define kPickerHeight 216
#define kButtonHeight 44
#define kCancelConfirmHeight kTitleHeight


- (CGSize)showSize
{
    return CGSizeMake(280, kTitleHeight + kPickerHeight + kButtonHeight + kCancelConfirmHeight);
}

- (void)relayoutFrameOfSubViews
{
    CGRect bounds = self.bounds;
    [_title sizeWith:CGSizeMake(bounds.size.width, kTitleHeight)];
    
    [_pickerView sizeWith:CGSizeMake(bounds.size.width - 40, kPickerHeight)];
    [_pickerView layoutBelow:_title];
    [_pickerView layoutParentHorizontalCenter];
    
    [_clearButton sizeWith:CGSizeMake(bounds.size.width, kTitleHeight)];
    [_clearButton layoutBelow:_pickerView];
    [_clearButton layoutParentHorizontalCenter];

    
    [_cancel sizeWith:CGSizeMake(bounds.size.width/2, kTitleHeight)];
    [_cancel alignParentLeft];
    [_cancel alignParentBottom];
    
    [_confirm sameWith:_cancel];
    [_confirm alignParentRight];
}

- (NSDate *)selectDate
{
    return [_pickerView date];
}

@end
