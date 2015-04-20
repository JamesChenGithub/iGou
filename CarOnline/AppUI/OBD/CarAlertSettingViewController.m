//
//  CarAlertSettingViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarAlertSettingViewController.h"

@interface CarAlertSettingViewController ()

@property (nonatomic, strong) GetAlarmResponseBody *alarmBody;

@end

@implementation CarAlertSettingViewController


typedef NS_ENUM(NSInteger, CarAlertSetting)
{
    ECarAlertSetting_Disassemble,
    ECarAlertSetting_LowPresure,
    ECarAlertSetting_FatigueDriving,
    ECarAlertSetting_UnParking,
};

- (void)reloadAfterGetAlarm:(GetAlarmResponseBody *)body
{
    _data = [NSMutableArray array];
    
//    @property (nonatomic, assign) BOOL IsDownAlert;
//    @property (nonatomic, assign) BOOL IsLowPressAlert;
//    @property (nonatomic, assign) BOOL IsFatiguedAlert;
//    @property (nonatomic, assign) BOOL IsNotFireAlert;
    self.alarmBody = body;
    [_data addObject:[KeyValue key:kOBDAlertSetting_DownAlert_Str value:[NSNumber numberWithBool:body.IsDownAlert]]];
    [_data addObject:[KeyValue key:kOBDAlertSetting_LowPressAlert_Str value:[NSNumber numberWithBool:body.IsLowPressAlert]]];
    [_data addObject:[KeyValue key:kOBDAlertSetting_FatiguedAlert_Str value:[NSNumber numberWithBool:body.IsFatiguedAlert]]];
    [_data addObject:[KeyValue key:kOBDAlertSetting_NotFireAlert_Str value:[NSNumber numberWithBool:body.IsNotFireAlert]]];
    
    [_tableView reloadData];
}

- (void)configOwnViews
{
    __weak typeof(self) weakSelf = self;
    GetAlarm *ga = [[GetAlarm alloc] initWithHandler:^(BaseRequest *request) {
        GetAlarmResponseBody *body = (GetAlarmResponseBody *)request.response.Body;
        [weakSelf reloadAfterGetAlarm:body];
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:ga];
}

#define kWTATableCellIdentifier @"WTATableCellIdentifier"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *alert = [[UISwitch alloc] init];
        alert.tag = 2000 + indexPath.row;
        [alert addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:alert];
        
    }
    
    KeyValue *kv = _data[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", kv.key];
    
    UISwitch *alert = (UISwitch *)[cell.contentView viewWithTag:2000 + indexPath.row];
    alert.on = [kv.value boolValue];
    [alert sizeWith:CGSizeMake(60, 30)];
    [alert layoutParentVerticalCenter];
    [alert alignParentRightWithMargin:15];
    return cell;
}

- (void)onSetting:(UISwitch *)alert
{
    __block NSInteger tag = alert.tag - 2000;
    __block KeyValue *kv = _data[tag];
    
    __weak typeof(self) ws = self;
    SetAlarm *setAlarm = [[SetAlarm alloc] initWithHandler:^(BaseRequest *request) {
        [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:kOBDAlertSetting_Foramt_Str, kv.key,  alert.on ? kOBD_Result_Enable_Str : kOBD_Result_Disable_Str]];
        kv.value = [NSNumber numberWithBool:alert.on];
        [ws.tableView reloadData];
    } failHandler:^(BaseRequest *request) {
        [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:kOBDAlertSetting_ForamtError_Str, kv.key,  alert.on ? kOBD_Result_Enable_Str : kOBD_Result_Disable_Str]];
        [ws.tableView reloadData];
    }];
    setAlarm.AlertSettingType = [NSString stringWithFormat:@"%ld", (long)tag];
    setAlarm.AlertSettingValue = alert.on;
    
    [[WebServiceEngine sharedEngine] asyncRequest:setAlarm];
    
    
//    [_tableView reloadData];
}

@end
