//
//  OBDMaintenanceViewController.m
//  CarOnline
//
//  Created by James on 14-11-14.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDMaintenanceViewController.h"

@implementation OBDMaintenanceResultView

//- (BOOL)isEnableExpand
//{
//    return _maintenanceResults.data.count > 0;
//}

- (void)addOwnViews
{
    [super addOwnViews];
    
    _maintenanceResults = [[OBDKeyValueTableViewController alloc] init];
    [self addSubview:_maintenanceResults.view];
}


- (void)configOwnViews
{
    [super configOwnViews];
    _resultLabel.text = kOBDMaintance_Scaning_Str;
}


- (void)showResult:(BaseResponseBody *)body
{
    [super showResult:body];
    
    
    GetMaintenanceResponseBody *gmBody = (GetMaintenanceResponseBody *)self.responseBody;
    if (!(gmBody.ISMileage || gmBody.ISDay))
    {
        _resultLabel.text = kOBDMaintance_NoMaintanceTip_Str;
        _resultLabel.textColor = kBlackColor;
        [self withdraw];
        _maintenanceResults.data = nil;
        [_maintenanceResults.tableView reloadData];
    }
    else
    {
        if ((gmBody.ISMileage && gmBody.MaintainMileage > gmBody.TotalMileage) || (gmBody.ISDay && gmBody.MaintanceDay > gmBody.TotalDay))
        {
            _resultLabel.text = kOBDMaintance_NeedMaintance_Str;
            _resultLabel.textColor = kRedColor;
        }
        else
        {
            _resultLabel.text = kOBDMaintance_NoNeedMaintance_Str;
            _resultLabel.textColor = kBlackColor;
        }
        
        NSMutableArray *array = [NSMutableArray array];
        
        if (gmBody.ISMileage)
        {
            
            if (gmBody.MaintainMileage > gmBody.TotalMileage)
            {
                NSString *value = [NSString stringWithFormat:kOBDMaintance_MileageValue_Format_Str, (int)(gmBody.MaintainMileage - gmBody.TotalMileage)];
                KeyValue *kv = [[KeyValue alloc] initWithKey:kOBDMaintance_OverMileageKey_Str value:value];
                [array addObject:kv];
            }
            else
            {
                NSString *value = [NSString stringWithFormat:kOBDMaintance_MileageValue_Format_Str, (int)(gmBody.TotalMileage - gmBody.MaintainMileage)];
                KeyValue *kv = [[KeyValue alloc] initWithKey:kOBDMaintance_InMileageKey_Str value:value];
                [array addObject:kv];
            }
            
        }
        
        if (gmBody.ISDay)
        {
            int total = (int)gmBody.TotalDay;
            int ma =  (int)gmBody.MaintanceDay;
            ma = gmBody.MaintanceDay > ma ? ma + 1 : ma;
            
            if (ma > total)
            {
                NSString *value = [NSString stringWithFormat:kOBDMaintance_MaintanceDay_Format_Str, (int)(ma - total)];
                KeyValue *kv = [[KeyValue alloc] initWithKey:kOBDMaintance_OverDayKey_Str value:value];
                [array addObject:kv];
            }
            else
            {
                NSString *value = [NSString stringWithFormat:kOBDMaintance_MaintanceDay_Format_Str, (int)(total - ma)];
                KeyValue *kv = [[KeyValue alloc] initWithKey:kOBDMaintance_InDayKey_Str value:value];
                [array addObject:kv];
            }
            
        }
        
        if (array.count == 0)
        {
            array = nil;
            [self withdraw];
            
        }
        
        _maintenanceResults.data = array;
        [_maintenanceResults.tableView reloadData];
    }
    
    
    //    [_monitorResults reloadAfterGetOBDData:(GetOBDDataResponseBody *)body];
    //    BOOL isnoraml = [_monitorResults isMonitorNormal];
    //    _resultLabel.text = isnoraml ? kOBDTire_Normal_Str : kOBDTire_Abnormal_Str;
    //    _resultLabel.textColor = isnoraml ? kBlackColor : kRedColor;
}

- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    
    CGRect rect = self.bounds;
    CGRect lrect = _resultLabel.frame;
    
    rect.origin.y = lrect.origin.y + lrect.size.height;
    rect.size.height -= lrect.origin.y + lrect.size.height;
    
    _maintenanceResults.view.frame = rect;
    [_maintenanceResults layoutSubviewsFrame];
}

@end

#if kSupportOldMaintananceUI

@implementation OBDMaintenanceAnimationView

- (void)addOwnViews
{
    _background = [[UIImageView alloc] init];
    _background.image = [UIImage imageNamed:@"VRM_i15_001_CircleBackOff.png"];
    [self addSubview:_background];
    _background.userInteractionEnabled = YES;
    _background.clipsToBounds = YES;
    
    _totalMileageSwitch = [[UISwitch alloc] init];
    [_totalMileageSwitch addTarget:self action:@selector(onSetMileage:) forControlEvents:UIControlEventValueChanged];
    [_background addSubview:_totalMileageSwitch];
    
    _totalMileageView = [[OBDMaintenanceView alloc] init];
    [_background addSubview:_totalMileageView];
    
    _maintainceMileageView = [[OBDMaintenanceView alloc] init];
    [_background addSubview:_maintainceMileageView];
    
    _totalDaySwitch = [[UISwitch alloc] init];
    [_totalDaySwitch addTarget:self action:@selector(onSetMaintanceDay:) forControlEvents:UIControlEventValueChanged];
    [_background addSubview:_totalDaySwitch];
    
    _totalDayView = [[OBDMaintenanceView alloc] init];
    [_background addSubview:_totalDayView];
    
    _maintainceDayView = [[OBDMaintenanceView alloc] init];
    [_background addSubview:_maintainceDayView];
}


- (void)onSetMileage:(UISwitch *)alert
{
    if (alert.on)
    {
        __weak typeof(self) ws = self;
        InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:kOBDMaintance_OpenMileageNotify_Str editText:@"500" doneAction:^(PopupContentView *pop, NSString *editText) {
            
            if (![NSString isEmpty:editText])
            {
                NSInteger inp = [editText integerValue];
                
                if (inp > 0)
                {
                    
                    
                    __block CGFloat input = inp;
                    SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                        ((GetMaintenanceResponseBody *)ws.responseBody).TotalMileage = input;
                        ((GetMaintenanceResponseBody *)ws.responseBody).MaintainMileage = 0;
                        [ws onAnimationOver];
                    }];
                    //                        {"Body":{"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
                    sm.Code = @"1";
                    ((GetMaintenanceResponseBody *)ws.responseBody).ISMileage = alert.on;
                    sm.CodeValue = @"1";
                    sm.Value = [NSString stringWithFormat:@"%ld", (long)inp];
                    [[WebServiceEngine sharedEngine] asyncRequest:sm];
                    [pop closePopup];
                }
                else
                {
                    [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
                }
                
            }
            else
            {
                [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
            }
            
        }];
        popup.edit.keyboardType = UIKeyboardTypeNumberPad;
        [popup addCancelAction:^(id<MenuAbleItem> menu) {
            alert.on = NO;
        }];
        
        [popup setEditUnit:@"km"];
        [PopupView alertInWindow:popup];
    }
    else
    {
        //            {"Body":{"Code":"1","CodeValue":"0","Value":"0","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
        
        
        __weak typeof(self) ws = self;
        SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
            [ws onAnimationOver];
        }];
        sm.Code = @"1";
        ((GetMaintenanceResponseBody *)self.responseBody).ISMileage = alert.on;
        sm.CodeValue = @"0";
        sm.Value = @"0";
        [[WebServiceEngine sharedEngine] asyncRequest:sm];
        
    }
    
}

- (void)onSetMaintanceDay:(UISwitch *)alert
{
    if (alert.on)
    {
        __weak typeof(self) ws = self;
        InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:kOBDMaintance_OpenDayNotify_Str editText:@"3" doneAction:^(PopupContentView *pop, NSString *editText) {
            
            if (![NSString isEmpty:editText])
            {
                NSInteger inp = [editText integerValue];
                
                if (inp > 0)
                {
                    
                    __block CGFloat input = inp;
                    SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                        ((GetMaintenanceResponseBody *)ws.responseBody).TotalDay = input;
                        ((GetMaintenanceResponseBody *)ws.responseBody).MaintanceDay = 0;
                        [ws onAnimationOver];
                    }];
                    //                        {"Body":{"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
                    sm.Code = @"2";
                    ((GetMaintenanceResponseBody *)ws.responseBody).ISDay = alert.on;
                    sm.CodeValue = @"1";
                    sm.Value = [NSString stringWithFormat:@"%ld", (long)inp];
                    [[WebServiceEngine sharedEngine] asyncRequest:sm];
                    [pop closePopup];
                }
                else
                {
                    [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
                }
                
            }
            else
            {
                [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
            }
            
        }];
        popup.edit.keyboardType = UIKeyboardTypeNumberPad;
        [popup addCancelAction:^(id<MenuAbleItem> menu) {
            alert.on = NO;
        }];
        [popup setEditUnit:@"Day(s)"];
        [PopupView alertInWindow:popup];
        
    }
    else
    {
        //            {"Body":{"Code":"2","CodeValue":"0","Value":"0","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
        
        __weak typeof(self) ws = self;
        SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
            [ws onAnimationOver];
        }];
        sm.Code = @"2";
        ((GetMaintenanceResponseBody *)self.responseBody).ISDay = alert.on;
        sm.CodeValue = @"0";
        sm.Value = @"0";
        [[WebServiceEngine sharedEngine] asyncRequest:sm];
    }
}

- (void)configOwnViews
{
    [_totalMileageView setTitle:kOBDMaintance_OFF_Str];
    [_totalDayView setTitle:kOBDMaintance_OFF_Str];
    _maintainceMileageView.hidden = YES;
    _maintainceDayView.hidden = YES;
}


#define kMaintenanceViewSize CGSizeMake(40, 274)

- (void)relayoutFrameOfSubViews
{
    [_background sizeWith:_background.image.size];
    [_background layoutParentHorizontalCenter];
    [_background alignParentTopWithMargin:15];
    _background.layer.cornerRadius = _background.image.size.width/2;
    
    [_totalMileageSwitch sizeWith:CGSizeMake(50, 30)];
    [_totalMileageSwitch alignParentTopWithMargin:10];
    [_totalMileageSwitch layoutParentHorizontalCenter];
    
    [_totalDaySwitch sameWith:_totalMileageSwitch];
    
    [_totalMileageSwitch move:CGPointMake(-27, 0)];
    [_totalDaySwitch move:CGPointMake(27, 0)];
    
    [_totalMileageView sizeWith:kMaintenanceViewSize];
    [_totalMileageView layoutBelow:_totalMileageSwitch margin:5];
    [_totalMileageView alignHorizontalCenterOf:_totalMileageSwitch];
    [_totalMileageView relayoutFrameOfSubViews];
    
    [_totalDayView sameWith:_totalMileageView];
    [_totalDayView alignHorizontalCenterOf:_totalDaySwitch];
    [_totalDayView relayoutFrameOfSubViews];
    
    [_maintainceMileageView sameWith:_totalMileageView];
    [_maintainceMileageView layoutToLeftOf:_totalMileageView margin:2];
    [_maintainceMileageView alignTop:_totalMileageView margin:-80];
    [_maintainceMileageView relayoutFrameOfSubViews];
    
    [_maintainceDayView sameWith:_maintainceMileageView];
    [_maintainceDayView layoutToRightOf:_totalDayView margin:2];
    [_maintainceDayView relayoutFrameOfSubViews];
}


- (void)onAnimationOver
{
    
    GetMaintenanceResponseBody *gmBody = (GetMaintenanceResponseBody *)self.responseBody;
    if (gmBody.ISMileage || gmBody.ISDay)
    {
        _background.image = [UIImage imageNamed:@"VRM_i15_002_CircleBackOn.png"];
    }
    else
    {
        _background.image = [UIImage imageNamed:@"VRM_i15_001_CircleBackOff.png"];
    }
    
    _totalMileageSwitch.on = gmBody.ISMileage;
    _maintainceMileageView.hidden = !gmBody.ISMileage;
    
    _totalDaySwitch.on = gmBody.ISDay;
    _maintainceDayView.hidden = !gmBody.ISDay;
    
    if (gmBody.ISMileage)
    {
        [_totalMileageView setTitle:[NSString stringWithFormat:kOBDMaintance_MileageFormat_Str, (int)gmBody.TotalMileage]];
        [_maintainceMileageView setTitle:[NSString stringWithFormat:kOBDMaintance_MileageFormat_Str, (int)gmBody.MaintainMileage] ];
        if (gmBody.MaintainMileage > gmBody.TotalMileage)
        {
            [_maintainceMileageView setStatusImage:[UIImage imageNamed:@"VRM_i15_006_CurrentRed.png"]];
            [_maintainceMileageView alignTop:_totalMileageView];
        }
        else
        {
            CGFloat rat = gmBody.MaintainMileage/gmBody.TotalMileage;
            if (gmBody.MaintainMileage < gmBody.TotalMileage/2)
            {
                [_maintainceMileageView setStatusImage:[UIImage imageNamed:@"VRM_i15_004_CurrentGreen.png"]];
                
            }
            else
            {
                [_maintainceMileageView setStatusImage:[UIImage imageNamed:@"VRM_i15_005_CurrentOrange.png"]];
            }
            [_maintainceMileageView alignTop:_totalMileageView margin:(rat-1)*180];
            
        }
    }
    else
    {
        [_totalMileageView setTitle:kOBDMaintance_OFF_Str];
        _maintainceMileageView.hidden = YES;
    }
    
    
    if (gmBody.ISDay)
    {
        int total = (int)gmBody.TotalDay;
        int ma =  (int)gmBody.MaintanceDay;
        ma = gmBody.MaintanceDay > ma ? ma + 1 : ma;
        [_totalDayView setTitle:[NSString stringWithFormat:kOBDMaintance_DayFormat_Str, total]];
        [_maintainceDayView setTitle:[NSString stringWithFormat:kOBDMaintance_DayFormat_Str, ma] ];
        
        if (ma > total)
        {
            [_maintainceDayView setStatusImage:[UIImage imageNamed:@"VRM_i15_006_CurrentRed.png"]];
            [_maintainceDayView alignTop:_totalDayView];
        }
        else
        {
            CGFloat rat = gmBody.MaintanceDay/gmBody.TotalDay;
            if (ma < total/2)
            {
                [_maintainceDayView setStatusImage:[UIImage imageNamed:@"VRM_i15_004_CurrentGreen.png"]];
            }
            else
            {
                [_maintainceDayView setStatusImage:[UIImage imageNamed:@"VRM_i15_005_CurrentOrange.png"]];
            }
            [_maintainceDayView alignTop:_totalDayView margin:(rat-1)*180];
            
        }
    }
    else
    {
        [_totalDayView setTitle:kOBDMaintance_OFF_Str];
        _maintainceDayView.hidden = YES;
    }
    
    
    if (self.animationOver)
    {
        self.animationOver();
    }
    
}


- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    [super stopAnimation:body completion:block];
    [self onAnimationOver];
}

@end

#else


@implementation OBDMaintenanceAnimationView

- (void)addOwnViews
{
    _totalMileageView = [[OBDMaintenanceView alloc] init];
    
    __weak typeof(self) ws = self;
    [_totalMileageView setClickAction:^(MenuButton *menu) {
        [ws onSetMileage:menu];
    }];
    [self addSubview:_totalMileageView];
    
    _maintainceMileageView = [[OBDMaintenanceValueView alloc] init];
    [self addSubview:_maintainceMileageView];
    
    _totalDayView = [[OBDMaintenanceView alloc] init];
    [_totalDayView setClickAction:^(MenuButton *menu) {
        [ws onSetMaintanceDay:menu];
    }];
    [self addSubview:_totalDayView];
    
    _maintainceDayView = [[OBDMaintenanceValueView alloc] init];
    [self addSubview:_maintainceDayView];
}

- (void)onSetMileage:(MenuButton *)alert
{
    if (alert.selected)
    {
        __weak typeof(self) ws = self;
        InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:kOBDMaintance_OpenMileageNotify_Str editText:@"500" doneAction:^(PopupContentView *pop, NSString *editText) {
            
            if (![NSString isEmpty:editText])
            {
                NSInteger inp = [editText integerValue];
                
                if (inp > 0)
                {
                    
                    
                    __block CGFloat input = inp;
                    SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                        ((GetMaintenanceResponseBody *)ws.responseBody).TotalMileage = input;
                        ((GetMaintenanceResponseBody *)ws.responseBody).MaintainMileage = 0;
                        [ws onAnimationOver];
                    }];
                    //                        {"Body":{"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
                    sm.Code = @"1";
                    ((GetMaintenanceResponseBody *)ws.responseBody).ISMileage = alert.selected;
                    sm.CodeValue = @"1";
                    sm.Value = [NSString stringWithFormat:@"%ld", (long)inp];
                    [[WebServiceEngine sharedEngine] asyncRequest:sm];
                    [pop closePopup];
                }
                else
                {
                    [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
                }
                
            }
            else
            {
                [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
            }
            
        }];
        popup.edit.keyboardType = UIKeyboardTypeNumberPad;
        [popup addCancelAction:^(id<MenuAbleItem> menu) {
            alert.selected = NO;
        }];
        
        [popup setEditUnit:@"km"];
        [PopupView alertInWindow:popup];
    }
    else
    {
        //            {"Body":{"Code":"1","CodeValue":"0","Value":"0","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
        
        
        __weak typeof(self) ws = self;
        SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
            ((GetMaintenanceResponseBody *)ws.responseBody).ISMileage = YES;
            if (((GetMaintenanceResponseBody *)ws.responseBody).TotalMileage == 0)
            {
                ((GetMaintenanceResponseBody *)ws.responseBody).TotalMileage = 500;
            }
            [ws onAnimationOver];
        }];
        sm.Code = @"1";
        ((GetMaintenanceResponseBody *)self.responseBody).ISMileage = alert.selected;
        sm.CodeValue = @"0";
        sm.Value = @"0";
        [[WebServiceEngine sharedEngine] asyncRequest:sm];
        
    }
    
}

- (void)onSetMaintanceDay:(MenuButton *)alert
{
    if (alert.selected)
    {
        __weak typeof(self) ws = self;
        InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:kOBDMaintance_OpenDayNotify_Str editText:@"3" doneAction:^(PopupContentView *pop, NSString *editText) {
            
            if (![NSString isEmpty:editText])
            {
                NSInteger inp = [editText integerValue];
                
                if (inp > 0)
                {
                    
                    __block CGFloat input = inp;
                    SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                        ((GetMaintenanceResponseBody *)ws.responseBody).TotalDay = input;
                        ((GetMaintenanceResponseBody *)ws.responseBody).MaintanceDay = 0;
                        [ws onAnimationOver];
                    }];
                    //                        {"Body":{"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
                    sm.Code = @"2";
                    ((GetMaintenanceResponseBody *)ws.responseBody).ISDay = alert.selected;
                    sm.CodeValue = @"1";
                    sm.Value = [NSString stringWithFormat:@"%ld", (long)inp];
                    [[WebServiceEngine sharedEngine] asyncRequest:sm];
                    [pop closePopup];
                }
                else
                {
                    [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
                }
                
            }
            else
            {
                [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
            }
            
        }];
        popup.edit.keyboardType = UIKeyboardTypeNumberPad;
        [popup addCancelAction:^(id<MenuAbleItem> menu) {
            alert.selected = NO;
        }];
        [popup setEditUnit:@"Day(s)"];
        [PopupView alertInWindow:popup];
        
    }
    else
    {
        //            {"Body":{"Code":"2","CodeValue":"0","Value":"0","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
        
        __weak typeof(self) ws = self;
        SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
            ((GetMaintenanceResponseBody *)ws.responseBody).ISDay = YES;
            if (((GetMaintenanceResponseBody *)ws.responseBody).TotalDay == 0) {
                ((GetMaintenanceResponseBody *)ws.responseBody).TotalDay = 3;
            }
            [ws onAnimationOver];
        }];
        sm.Code = @"2";
        ((GetMaintenanceResponseBody *)self.responseBody).ISDay = alert.selected;
        sm.CodeValue = @"0";
        sm.Value = @"0";
        [[WebServiceEngine sharedEngine] asyncRequest:sm];
    }
}

- (void)configOwnViews
{
    [_totalMileageView setTitle:kOBDMaintance_OFF_Str];
    [_totalDayView setTitle:kOBDMaintance_OFF_Str];
    _maintainceMileageView.hidden = YES;
    _maintainceDayView.hidden = YES;
}


#define kMaintenanceViewSize CGSizeMake(40, 274)

- (void)relayoutFrameOfSubViews
{
    
    [_totalMileageView sizeWith:kMaintenanceViewSize];
    [_totalMileageView alignParentTopWithMargin:60];
    [_totalMileageView layoutParentHorizontalCenter];
    [_totalMileageView move:CGPointMake(-25, 0)];
    [_totalMileageView relayoutFrameOfSubViews];
    
    [_totalDayView sameWith:_totalMileageView];
    [_totalDayView layoutToRightOf:_totalMileageView margin:10];
    [_totalDayView relayoutFrameOfSubViews];
    
    [_maintainceMileageView sameWith:_totalMileageView];
    [_maintainceMileageView layoutToLeftOf:_totalMileageView margin:2];
    [_maintainceMileageView alignTop:_totalMileageView margin:-80];
    [_maintainceMileageView relayoutFrameOfSubViews];

    [_maintainceDayView sameWith:_maintainceMileageView];
    [_maintainceDayView layoutToRightOf:_totalDayView margin:2];
    [_maintainceDayView relayoutFrameOfSubViews];
}


- (void)onAnimationOver
{
    
    
    
    GetMaintenanceResponseBody *gmBody = (GetMaintenanceResponseBody *)self.responseBody;
    //    if (gmBody.ISMileage || gmBody.ISDay)
    //    {
    //        _background.image = [UIImage imageNamed:@"VRM_i15_002_CircleBackOn.png"];
    //    }
    //    else
    //    {
    //        _background.image = [UIImage imageNamed:@"VRM_i15_001_CircleBackOff.png"];
    //    }
    
    //    _totalMileageSwitch.on = gmBody.ISMileage;
    _totalMileageView.button.selected = gmBody.ISMileage;
    _maintainceMileageView.hidden = !gmBody.ISMileage;
    
    _totalDayView.button.selected = gmBody.ISDay;
    _maintainceDayView.hidden = !gmBody.ISDay;
    
    if (gmBody.ISMileage)
    {
        [_totalMileageView setTitle:[NSString stringWithFormat:kOBDMaintance_MileageFormat_Str, (int)gmBody.TotalMileage]];
        [_maintainceMileageView setTitle:[NSString stringWithFormat:kOBDMaintance_MileageFormat_Str, (int)gmBody.MaintainMileage] ];
        
        
        CGRect rect = _maintainceMileageView.frame;
        
        if (gmBody.MaintainMileage > gmBody.TotalMileage)
        {
            [_maintainceMileageView setStatusImage:[UIImage imageWithColor:[UIColor flatRedColor]]];
            rect.origin.y = _totalMileageView.frame.origin.y;
            rect.size.height = _totalMileageView.frame.size.height;
            
        }
        else
        {
            CGFloat rat = gmBody.MaintainMileage/gmBody.TotalMileage;
            if (gmBody.MaintainMileage < gmBody.TotalMileage/2)
            {
                [_maintainceMileageView setStatusImage:[UIImage imageWithColor:[UIColor flatGreenColor]]];
                
            }
            else
            {
                [_maintainceMileageView setStatusImage:[UIImage imageWithColor:[UIColor flatOrangeColor]]];
            }
            //            [_maintainceMileageView scaleToAboveOf:_totalMileageView margin:(rat-1)*160];
            
            rect.origin.y = _totalMileageView.frame.origin.y + (1-rat)*_totalMileageView.frame.size.height;
            rect.size.height = rat * _totalMileageView.frame.size.height;
        }
        
        if (rect.size.height == 0)
        {
            rect.origin.y -= 20;
            rect.size.height = 20;
        }
        [_maintainceMileageView setFrameAndLayout:rect];
        
    }
    else
    {
        [_totalMileageView setTitle:kOBDMaintance_OFF_Str];
        _maintainceMileageView.hidden = YES;
    }
    
    
    if (gmBody.ISDay)
    {
        int total = (int)gmBody.TotalDay;
        int ma =  (int)gmBody.MaintanceDay;
        ma = gmBody.MaintanceDay > ma ? ma + 1 : ma;
        [_totalDayView setTitle:[NSString stringWithFormat:kOBDMaintance_DayFormat_Str, total]];
        [_maintainceDayView setTitle:[NSString stringWithFormat:kOBDMaintance_DayFormat_Str, ma] ];
        
        
        CGRect rect = _maintainceDayView.frame;
        if (ma > total)
        {
            [_maintainceDayView setStatusImage:[UIImage imageWithColor:[UIColor flatRedColor]]];
            rect.origin.y = _totalDayView.frame.origin.y;
            rect.size.height = _totalDayView.frame.size.height;
        }
        else
        {
            CGFloat rat = gmBody.MaintanceDay/gmBody.TotalDay;
            if (ma < total/2)
            {
                [_maintainceDayView setStatusImage:[UIImage imageWithColor:[UIColor flatGreenColor]]];
            }
            else
            {
                [_maintainceDayView setStatusImage:[UIImage imageWithColor:[UIColor flatOrangeColor]]];
            }
            rect.origin.y = _totalDayView.frame.origin.y + (1-rat)*_totalDayView.frame.size.height;
            rect.size.height = rat * _totalDayView.frame.size.height;
        }
        
        if (rect.size.height == 0)
        {
            rect.origin.y -= 20;
            rect.size.height = 20;
        }
        
        [_maintainceDayView setFrameAndLayout:rect];
    }
    else
    {
        [_totalDayView setTitle:kOBDMaintance_OFF_Str];
        _maintainceDayView.hidden = YES;
    }
    
    if (self.animationOver)
    {
        self.animationOver();
    }
    
    
    
    
    
}


- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    [super stopAnimation:body completion:block];
    [self onAnimationOver];
}

@end


#endif

//============================================


@interface OBDMaintenanceViewController ()

@end

@implementation OBDMaintenanceViewController

- (Class)animationViewClass
{
    return [OBDMaintenanceAnimationView class];
}

- (Class)resultViewClass
{
    return [OBDMaintenanceResultView class];
}



- (void)configOwnViews
{
    __weak typeof(self) ws = self;
    GetMaintenance *gm = [[GetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
        [ws showResult:request.response.Body];
    }];
    
    [[WebServiceEngine sharedEngine] asyncRequest:gm wait:NO];
}

- (void)showResult:(BaseResponseBody *)body
{
    __weak typeof(_resultView) wr = _resultView;
    [_animationView stopAnimation:body completion:^{
        
        //        OBDMaintenanceAnimationView *mav = (OBDMaintenanceAnimationView *)_animationView;
        //        BaseResponseBody *newBody = mav.responseBody;
        [wr showResult:body];
    }];
    
}

@end
