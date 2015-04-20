//
//  PlaybackPopupContentView.m
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "PlaybackPopupContentView.h"

@interface PlaybackPopupContentView ()

@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) UIButton *fromTime;
@property (nonatomic, strong) UIButton *toTime;

@end

@implementation PlaybackPopupContentView

- (instancetype)initWithDone:(PlaybackPopupDoneAction)block
{
    if (self = [super init])
    {
        self.doneAction = block;
        _showSize = [self showSize];
        self.layer.cornerRadius = 8;
        self.backgroundColor = kAppModalBackgroundColor;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)addOwnViews
{
    _title = [[UILabel alloc] init];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [[FontHelper shareHelper] boldFontWithSize:18];
    _title.text = kPlaybackPopup_Title_Str;
    _title.backgroundColor = kClearColor;
    _title.textColor = kWhiteColor;
    [self addSubview:_title];
    
    _dateButton = [[UIButton alloc] init];
    [_dateButton setBackgroundImage:[UIImage imageNamed:@"VRM_i06_004_PopInput.png"] forState:UIControlStateNormal];
    [_dateButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    _dateButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    [_dateButton setTitle:@"2014-8-28" forState:UIControlStateNormal];
    [_dateButton addTarget:self action:@selector(onClickDate) forControlEvents:UIControlEventTouchUpInside];
//    _dateButton.layer.cornerRadius = 5;
    [self addSubview:_dateButton];
    
    _fromTime = [[UIButton alloc] init];
    [_fromTime setBackgroundImage:[UIImage imageNamed:@"VRM_i06_004_PopInput.png"] forState:UIControlStateNormal];
    [_fromTime setTitleColor:kBlackColor forState:UIControlStateNormal];
    _fromTime.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    [_fromTime setTitle:@"22:35" forState:UIControlStateNormal];
    [_fromTime addTarget:self action:@selector(onClickFromTime) forControlEvents:UIControlEventTouchUpInside];
//    _fromTime.layer.cornerRadius = 5;
    [self addSubview:_fromTime];
    
    _interLabel = [[UILabel alloc] init];
    _interLabel.textAlignment = NSTextAlignmentCenter;
    _interLabel.font = [UIFont boldSystemFontOfSize:16];
    _interLabel.text = @"--";
    _interLabel.backgroundColor = kClearColor;
    _interLabel.textColor = kWhiteColor;
    [self addSubview:_interLabel];
    
    _toTime = [[UIButton alloc] init];
//    _toTime.backgroundColor = kGrayColor;
    _toTime.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_toTime setBackgroundImage:[UIImage imageNamed:@"VRM_i06_004_PopInput.png"] forState:UIControlStateNormal];
    [_toTime setTitleColor:kBlackColor forState:UIControlStateNormal];
//    _toTime.layer.cornerRadius = 5;
    //    [_toTime setTitle:@"23:35" forState:UIControlStateNormal];
    [_toTime addTarget:self action:@selector(onClickToTime) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_toTime];
    
    _cancel = [[UIButton alloc] init];
    [_cancel setTitle:kCancel_Str forState:UIControlStateNormal];
    [_cancel setBackgroundImage:[UIImage imageWithColor:kAlertButtonNormalColor] forState:UIControlStateNormal];
    [_cancel setBackgroundImage:[UIImage imageWithColor:kAlertButtonPressedColor] forState:UIControlStateHighlighted];
    [_cancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancel];
    
    _confirm = [[UIButton alloc] init];
    [_confirm setTitle:kOK_Str forState:UIControlStateNormal];
    [_confirm setBackgroundImage:[UIImage imageWithColor:kAlertButtonNormalColor] forState:UIControlStateNormal];
    [_confirm setBackgroundImage:[UIImage imageWithColor:kAlertButtonPressedColor] forState:UIControlStateHighlighted];
    [_confirm addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirm];
    
}

- (void)updateDateButton:(NSDate *)today
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit ;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:today];
    
    int year = (int)[comps year];
    int month = (int)[comps month];
    int day = (int)[comps day];
    [_dateButton setTitle:[NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day] forState:UIControlStateNormal];

}

- (void)updateToTime:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit ;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    int tohour = (int)[comps hour];
    int tomin = (int)[comps minute];
    [_toTime setTitle:[NSString stringWithFormat:@"%02d:%02d", tohour, tomin] forState:UIControlStateNormal];

}

- (void)updateFromTime:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit ;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int fromhour = (int)[comps hour];
    int frommin = (int)[comps minute];
    [_fromTime setTitle:[NSString stringWithFormat:@"%02d:%02d", fromhour, frommin] forState:UIControlStateNormal];
}

- (void)configOwnViews
{
    NSDate *today = [NSDate date];
    NSDate *before = [NSDate dateWithTimeIntervalSinceNow:-60*60];
    [self updateDateButton:today];
    [self updateToTime:today];
    [self updateFromTime:before];
}



#define kTitleHeight 44
#define kVerPadding 5
#define kButtonHeight 44
#define kCancelConfirmHeight kTitleHeight
#define kHorPadding 20

- (CGSize)showSize
{
    return CGSizeMake(280, kTitleHeight + kButtonHeight + kVerPadding + kButtonHeight + kVerPadding + kTitleHeight);
}

- (void)relayoutFrameOfSubViews
{
    CGRect bounds = self.bounds;
    [_title sizeWith:CGSizeMake(bounds.size.width, kTitleHeight)];
    
    [_dateButton sizeWith:CGSizeMake(bounds.size.width - 2 * kHorPadding, kButtonHeight)];
    [_dateButton layoutBelow:_title];
    [_dateButton layoutParentHorizontalCenter];
    
    [_interLabel sizeWith:CGSizeMake(30, kButtonHeight)];
    [_interLabel layoutParentHorizontalCenter];
    [_interLabel layoutBelow:_dateButton margin:kVerPadding];
    
    [_fromTime sameWith:_interLabel];
    [_fromTime alignLeft:_dateButton];
    [_fromTime scaleToLeftOf:_interLabel];
    
    [_toTime sameWith:_fromTime];
    [_toTime layoutToRightOf:_interLabel];
    
    [_cancel sizeWith:CGSizeMake(bounds.size.width/2, kTitleHeight)];
    [_cancel alignParentLeft];
    [_cancel alignParentBottom];
    
    [_confirm sameWith:_cancel];
    [_confirm alignParentRight];
    
    
}

#define kDateEmptyStr       kPlaybackPopup_DateEmpty_Str
#define kFromTimeEmptyStr   kPlaybackPopup_FromTimeEmpty_Str
#define kToTimeEmptyStr     kPlaybackPopup_ToTimeEmpty_Str


- (void)onClickDate
{
    // 选择日期
    
    NSString *title = [_dateButton titleForState:UIControlStateNormal];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:title];
    
    __weak typeof(self) weakSelf = self;
    DateTimePickerPopupContentView *pop = [[DateTimePickerPopupContentView alloc] initWithDate:date dateDone:^(DateTimePickerPopupContentView *selfPtr) {
        // 点击日期处理
        NSDate *date = [selfPtr selectDate];
        [weakSelf updateDateButton:date];
    } clear:^(DateTimePickerPopupContentView *selfPtr) {
        // 清空处理
        [weakSelf.dateButton setTitle:kDateEmptyStr forState:UIControlStateNormal];
        [selfPtr closePopup];
    }];
    
    
    
    [PopupView alertInWindow:pop];
}

- (void)onClickFromTime
{
    // 起始时间
    __weak typeof(self) weakSelf = self;
    
    NSString *fromTime = [_fromTime titleForState:UIControlStateNormal];
    NSDate *frmoDate = nil;
    
    if ([NSString isEmpty:fromTime])
    {
        frmoDate = [NSDate date];
    }
    else
    {
        NSDateFormatter *nowDateFormat = [[NSDateFormatter alloc] init];
        [nowDateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSString *now = [nowDateFormat stringFromDate:[NSDate date]];
        NSString *fromTimeStr = [NSString stringWithFormat:@"%@ %@", now, fromTime];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        frmoDate = [dateFormat dateFromString:fromTimeStr];
    }
    
    
    
    
    
    
    DateTimePickerPopupContentView *pop = [[DateTimePickerPopupContentView alloc] initWithDate:frmoDate timeDone:^(DateTimePickerPopupContentView *selfPtr) {
        NSDate *date = [selfPtr selectDate];
        [weakSelf updateFromTime:date];
    } clear:^(DateTimePickerPopupContentView *selfPtr) {
        [weakSelf.fromTime setTitle:kFromTimeEmptyStr forState:UIControlStateNormal];
        [selfPtr closePopup];
    }];
    
    [PopupView alertInWindow:pop];
}

- (void)onClickToTime
{
    // 结束时间
    __weak typeof(self) weakSelf = self;
    
    NSString *toTime = [_toTime titleForState:UIControlStateNormal];
    NSDate *toDate = nil;
    
    if ([NSString isEmpty:toTime])
    {
        toDate = [NSDate date];
    }
    else
    {
        NSDateFormatter *nowDateFormat = [[NSDateFormatter alloc] init];
        [nowDateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSString *now = [nowDateFormat stringFromDate:[NSDate date]];
        NSString *toTimeStr = [NSString stringWithFormat:@"%@ %@", now, toTime];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        toDate = [dateFormat dateFromString:toTimeStr];
    }
    
    DateTimePickerPopupContentView *pop = [[DateTimePickerPopupContentView alloc] initWithDate:toDate timeDone:^(DateTimePickerPopupContentView *selfPtr) {
        NSDate *date = [selfPtr selectDate];
        [weakSelf updateToTime:date];
    } clear:^(DateTimePickerPopupContentView *selfPtr) {
        [weakSelf.toTime setTitle:kToTimeEmptyStr forState:UIControlStateNormal];

        [selfPtr closePopup];
    }];
    
    [PopupView alertInWindow:pop];
}

- (void)onCancel
{
    [self closePopup];
}

- (void)onConfirm
{
    NSString *date = [_dateButton titleForState:UIControlStateNormal];
    if ([date isEqualToString:kDateEmptyStr])
    {
        [[HUDHelper sharedInstance] tipMessage:kPlaybackPopup_DateEmpty_Tip_Str];
        return;
    }
    
    NSString *fromTime = [_fromTime titleForState:UIControlStateNormal];
    if ([fromTime isEqualToString:kFromTimeEmptyStr])
    {
        [[HUDHelper sharedInstance] tipMessage:kPlaybackPopup_FromTimeEmpty_Tip_Str];
        return;
    }
    
    NSString *toTime = [_toTime titleForState:UIControlStateNormal];
    if ([toTime isEqualToString:kFromTimeEmptyStr])
    {
        [[HUDHelper sharedInstance] tipMessage:kPlaybackPopup_ToTimeEmpty_Tip_Str];
        return;
    }
    
    NSString *fromTimeStr = [NSString stringWithFormat:@"%@ %@", date, fromTime];
    
    NSString *toTimeStr = [NSString stringWithFormat:@"%@ %@", date, toTime];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *frmoDate = [dateFormat dateFromString:fromTimeStr];
    
    NSDate *toDate = [dateFormat dateFromString:toTimeStr];
    
    if ([toDate timeIntervalSinceDate:[NSDate date]] > 0)
    {
        [[HUDHelper sharedInstance] tipMessage:kPlaybackPopup_EndLagerNow_Tip_Str];
        return;
    }
    
    NSTimeInterval interval = [frmoDate timeIntervalSinceDate:toDate];
    if (interval >= 0)
    {
        [[HUDHelper sharedInstance] tipMessage:kPlaybackPopup_StartLagerEnd_Tip_Str];
        return;
    }
    
    
    
    if (_doneAction)
    {
        _doneAction(self, fromTimeStr, toTimeStr);
    }
}

//- (NSDate *)fromDate
//{
//    NSString *title = [_dateButton titleForState:UIControlStateNormal];
//
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//
//
//    NSDate *date = [dateFormat dateFromString:title];
//}
//
//- (NSString *)fromTimeString
//{
//
//}
//
//- (NSDate *)toDate
//{
//
//}
//
//- (NSString *)toTimeString
//{
//    
//}


@end
