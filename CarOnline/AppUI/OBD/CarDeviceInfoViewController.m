//
//  CarDeviceInfoViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarDeviceInfoViewController.h"

@interface CarDeviceInfoViewController ()

@property (nonatomic, assign) NSInteger setTag;
@property (nonatomic, copy) NSString *setValue;
@property (nonatomic, strong) GetDevInfoResponseBody *devInfoBody;



@end

@implementation CarDeviceInfoViewController


typedef NS_ENUM(NSInteger, CarDeviceInfoType)
{
    ECarDevice_IMET,
    ECarDevice_UnitType,
    ECarDevice_URL,
    ECarDevice_Name,
    ECarDevice_SOS,
    ECarDevice_UpdatePeriod
};

- (void)reloadOnGetDevInfo:(GetDevInfoResponseBody *)body
{
    self.devInfoBody = body;
    _data = [NSMutableArray array];
    KeyValue *kv = [KeyValue key:kOBDDeviceInfo_IMEI_Str value:body.IMEI];
    [_data addObject:kv];
    
    kv = [KeyValue key:kOBDDeviceInfo_DeviceType_Str value:body.DeviceType];
    [_data addObject:kv];
    
//    VehicleListItem *vehicle = [WebServiceEngine sharedEngine].vehicle;
    kv = [KeyValue key:kOBDDeviceInfo_NewAddress_Str value:@""];
    [_data addObject:kv];
    
    kv = [KeyValue key:kOBDDeviceInfo_DeviceName_Str value:body.DeviceName];
    [_data addObject:kv];
    
    kv = [KeyValue key:kOBDDeviceInfo_SOS_Str value:body.SOSNumber];
    [_data addObject:kv];
    
    kv = [KeyValue key:kOBDDeviceInfo_DataUpdate_Str value:body.UpdatePeriod];
    [_data addObject:kv];
    
    [_tableView reloadData];
}

- (void)configOwnViews
{
    __weak typeof(self) weakSelf = self;
    GetDevInfo *gdi = [[GetDevInfo alloc] initWithHandler:^(BaseRequest *request) {
        GetDevInfoResponseBody *body = (GetDevInfoResponseBody *)request.response.Body;
        [weakSelf reloadOnGetDevInfo:body];
        
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:gdi];
    
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
        
        UIButton *button = [UIButton buttonWithTip:kSetting_Str];
        button.tag = 1000 + indexPath.row;
        [button setTitleColor:kBlackColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"VRM_i05_009_ButtonSet.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"VRM_i05_010_ButtonSetPressed.png"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"VRM_i05_010_ButtonSetPressed.png"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
    }
    
    KeyValue *kv = _data[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@", kv.key, kv.value ? [kv.value description] : @""];
    
    UIView *button = [cell.contentView viewWithTag:1000 + indexPath.row];
    button.hidden = indexPath.row <= ECarDevice_URL;
    [button sizeWith:CGSizeMake(60, 30)];
    [button layoutParentVerticalCenter];
    [button alignParentRightWithMargin:15];
    return cell;
}

- (void)onSetting:(UIButton *)button
{
    NSInteger tag = button.tag - 1000;
    KeyValue *kv = _data[tag];
    [self onSetting:kv withTag:tag];
}

- (void)onSetting:(KeyValue *)kv withTag:(NSInteger)tag
{
    self.setTag = tag;
    __block KeyValue *bkv = kv;
    __weak typeof(self) weakSelf = self;
    InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:kv.key editText:kv.value doneAction:^(PopupContentView *pop, NSString *editText) {
        
        
        switch (tag)
        {
            case ECarDevice_Name:
            {
                if (![NSString isEmpty:editText] && ![editText isEqualToString:bkv.value])
                {
                    weakSelf.setValue = editText;
                    SetDevInfo *sdi = [[SetDevInfo alloc] initWithHandler:^(BaseRequest *request) {
                        bkv.value = weakSelf.setValue;
                        [weakSelf.tableView reloadData];
                    } failHandler:^(BaseRequest *request) {
                        [weakSelf.tableView reloadData];
                    } deviceName:editText];
                    
                    [[WebServiceEngine sharedEngine] asyncRequest:sdi];
                    [pop closePopup];
                }
                else
                {
                    if ([NSString isEmpty:editText])
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_DeviceName_NotEmpty_Str];
                    }
                    else if ([editText isEqualToString:bkv.value])
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_DeviceName_Same_Str];
                    }
                }
            }
                
                break;
            case ECarDevice_SOS:
            {
                if (![NSString isEmpty:editText] && ![editText isEqualToString:bkv.value])
                {
                    weakSelf.setValue = editText;
                    SetDevInfo *sdi = [[SetDevInfo alloc] initWithHandler:^(BaseRequest *request) {
                        bkv.value = weakSelf.setValue;
                        [weakSelf.tableView reloadData];
                    } failHandler:^(BaseRequest *request) {
                        [weakSelf.tableView reloadData];
                    } SOSNumber:editText];
                    
                    [[WebServiceEngine sharedEngine] asyncRequest:sdi];
                    [pop closePopup];
                }
                else
                {
                    if ([NSString isEmpty:editText])
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_SOS_NotEmpty_Str];
                    }
                    else if ([editText isEqualToString:bkv.value])
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_SOS_Same_Str];
                    }
                }
            }
                break;
            case ECarDevice_UpdatePeriod:
            {
                if (![NSString isEmpty:editText] && ![editText isEqualToString:bkv.value])
                {
                    NSInteger dur = [(NSString *)bkv.value integerValue];
                    NSInteger inp = [editText integerValue];
                    
                    if (dur != inp && inp > 0)
                    {
                        weakSelf.setValue = editText;
                        SetDevInfo *sdi = [[SetDevInfo alloc] initWithHandler:^(BaseRequest *request) {
                            bkv.value = weakSelf.setValue;
                            [weakSelf.tableView reloadData];
                        } failHandler:^(BaseRequest *request) {
                            [weakSelf.tableView reloadData];
                        } SOSNumber:editText];
                        
                        [[WebServiceEngine sharedEngine] asyncRequest:sdi];
                        [pop closePopup];
                    }
                    else if (dur == inp)
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_DataUpdate_Same_Str];
                    }
                    else
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_DataUpdate_Invaild_Str];
                    }
                    
                }
                else
                {
                    if ([NSString isEmpty:editText])
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_SOS_NULL_Str];
                    }
                    else if ([editText isEqualToString:bkv.value])
                    {
                        [[HUDHelper sharedInstance] tipMessage:kOBDDeviceInfo_DataUpdate_Same_Str];
                    }
                }
                
            }
                break;
            default:
                break;
        }
        
        
    }];
    
    if (tag == ECarDevice_UpdatePeriod)
    {
        popup.edit.keyboardType = UIKeyboardTypeNumberPad;
        [popup setEditUnit:@"s"];
    }
    else if (tag == ECarDevice_SOS)
    {
        popup.edit.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    [PopupView alertInWindow:popup];
}

@end
