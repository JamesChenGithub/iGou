//
//  CarMaintenanceViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarMaintenanceViewController.h"

@interface CarMaintenanceViewController ()

@property (nonatomic, strong) GetMaintenanceResponseBody *maintenanceBody;


@end

@implementation CarMaintenanceViewController

typedef NS_ENUM(NSInteger, CarAlertSetting)
{
    ECarMaintenance_LastDistance,
    ECarAlertSetting_LastDays,
    ECarAlertSetting_DistanceTip,
    ECarAlertSetting_TimeTip,
};

- (void)reloadAfterGetMaintenance:(GetMaintenanceResponseBody *)body
{
    self.maintenanceBody = body;
    
    if (_data)
    {
        [_data removeAllObjects];
    }
    else
    {
        _data = [NSMutableArray array];
    }
    
    [_data addObject:[KeyValue key:@"距上次保养累计里程(km)" value:[NSNumber numberWithFloat:body.MaintainMileage]]];
    [_data addObject:[KeyValue key:@"距上次保养累计时间(天)" value:[NSNumber numberWithInt:body.MaintanceDay]]];
    [_data addObject:[KeyValue key:@"里程保养提醒" value:[NSNumber numberWithInt:body.TotalMileage]]];
    [_data addObject:[KeyValue key:@"时间保养提醒" value:[NSNumber numberWithInt:body.TotalDay]]];
    
    [_tableView reloadData];
}

- (void)configOwnViews
{
    __weak typeof(self) ws = self;
    GetMaintenance *gm = [[GetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
        GetMaintenanceResponseBody *body = (GetMaintenanceResponseBody *)request.response.Body;
        [ws reloadAfterGetMaintenance:body];
    }];
    
    [[WebServiceEngine sharedEngine] asyncRequest:gm];
    
}

#define kWTATableCellIdentifier @"WTATableCellIdentifier"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kBlackColor;
        cell.textLabel.textColor = kBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.textColor = kBlackColor;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *alert = [[UISwitch alloc] init];
        alert.tag = 3000 + indexPath.row;
        [alert addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:alert];
        
    }
    
    KeyValue *kv = _data[indexPath.row];
    
    
    UISwitch *alert = (UISwitch *)[cell.contentView viewWithTag:3000 + indexPath.row];
    
    
    if (indexPath.row <= ECarAlertSetting_LastDays)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@：", kv.key];
        
        if (indexPath.row == ECarMaintenance_LastDistance)
        {
            cell.detailTextLabel.text = self.maintenanceBody.ISMileage ? [kv.value description] : @"--";
        }
        else if (indexPath.row == ECarAlertSetting_LastDays)
        {
            cell.detailTextLabel.text = self.maintenanceBody.ISDay ? [kv.value description] : @"--";
        }
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@：%@", kv.key, [kv.value description]];
        cell.detailTextLabel.text = nil;
    }
    
    alert.hidden = indexPath.row <= ECarAlertSetting_LastDays;
    
    
    if (indexPath.row == ECarAlertSetting_DistanceTip)
    {
        alert.on =  self.maintenanceBody.ISMileage;
        
        if (alert.on)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@：%@", kv.key, [kv.value description]];
            cell.detailTextLabel.text = nil;
        }
        else
        {
            cell.textLabel.text = kv.key;
            cell.detailTextLabel.text = nil;
        }
    }
    else if (indexPath.row == ECarAlertSetting_TimeTip)
    {
        alert.on = self.maintenanceBody.ISDay;
        
        if (alert.on)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@：%@", kv.key, [kv.value description]];
            cell.detailTextLabel.text = nil;
        }
        else
        {
            cell.textLabel.text = kv.key;
            cell.detailTextLabel.text = nil;
        }
    }
    
    [alert sizeWith:CGSizeMake(60, 30)];
    [alert layoutParentVerticalCenter];
    [alert alignParentRightWithMargin:15];
    return cell;
}


- (void)onSetting:(UISwitch *)alert
{
    NSInteger tag = alert.tag - 3000;
    __block KeyValue *bkv = _data[tag];
    
    __weak typeof (self) weakSelf = self;
    
    if (tag == ECarAlertSetting_DistanceTip)
    {
        if (alert.on)
        {
            __weak typeof(self) ws = self;
            InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:[NSString stringWithFormat:@"开启%@", bkv.key] editText:@"500" doneAction:^(PopupContentView *pop, NSString *editText) {
                
                if (![NSString isEmpty:editText] && ![editText isEqualToString:bkv.value])
                {
                    NSInteger inp = [editText integerValue];
                    
                    if (inp > 0)
                    {
                        
                        
                        SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                            [weakSelf performSelectorOnMainThread:@selector(configOwnViews) withObject:nil waitUntilDone:NO];
                        }];
                        //                        {"Body":{"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
                        sm.Code = @"1";
                        ws.maintenanceBody.ISMileage = alert.on;
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
            [popup setEditUnit:@"km"];
            [PopupView alertInWindow:popup];
        }
        else
        {
            //            {"Body":{"Code":"1","CodeValue":"0","Value":"0","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
            SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                [weakSelf.tableView reloadData];
            }];
            sm.Code = @"1";
            self.maintenanceBody.ISMileage = alert.on;
            sm.CodeValue = @"0";
            sm.Value = @"0";
            [[WebServiceEngine sharedEngine] asyncRequest:sm];
            
        }
        
        
    }
    else if (tag == ECarAlertSetting_TimeTip)
    {
        if (alert.on)
        {
            __weak typeof(self) ws = self;
            InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:[NSString stringWithFormat:@"开启%@", bkv.key] editText:@"3" doneAction:^(PopupContentView *pop, NSString *editText) {
                
                if (![NSString isEmpty:editText] && ![editText isEqualToString:bkv.value])
                {
                    NSInteger inp = [editText integerValue];
                    
                    if (inp > 0)
                    {
                        
                        SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                            [weakSelf performSelectorOnMainThread:@selector(configOwnViews) withObject:nil waitUntilDone:NO];
                        }];
                        //                        {"Body":{"Code":"1","CodeValue":"1","Value":"500","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
                        sm.Code = @"2";
                        ws.maintenanceBody.ISMileage = alert.on;
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
            [popup setEditUnit:@"Day(s)"];
            [PopupView alertInWindow:popup];
            
        }
        else
        {
            //            {"Body":{"Code":"2","CodeValue":"0","Value":"0","VehicleNumber":"253501101103709"},"Head":{"IMEI":"","MachineType":"0","Password":"103709","UserCode":"U00538","Version":0}}
            SetMaintenance *sm = [[SetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
                [weakSelf.tableView reloadData];
            }];
            sm.Code = @"2";
            self.maintenanceBody.ISDay = alert.on;
            sm.CodeValue = @"0";
            sm.Value = @"0";
            [[WebServiceEngine sharedEngine] asyncRequest:sm];
        }
    }
}

@end
