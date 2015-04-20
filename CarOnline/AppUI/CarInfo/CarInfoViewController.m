//
//  CarInfoViewController.m
//  CarOnline
//
//  Created by James on 14-7-23.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarInfoViewController.h"

@interface CarInfoViewController ()

@property (nonatomic, strong) GetMileageResponseBody *mileageBody;

@end

@implementation CarInfoViewController



- (void)addMenu:(NSString *)title icon:(UIImage *)image class:(Class)viewClass
{
    if (viewClass == Nil)
    {
        MenuItem *menu = [[MenuItem alloc] initWithTitle:title icon:image action:nil];
        [_data addObject:menu];
    }
    else
    {
        MenuItem *menu = [[MenuItem alloc] initWithTitle:title icon:image action:^(id<MenuAbleItem> menu) {
            UIViewController *view = [[viewClass alloc] init];
            view.title = [menu title];
            [[AppDelegate sharedAppDelegate] pushViewController:view];
        }];
        
        [_data addObject:menu];
    }
}


- (void)onGetMileage:(GetMileageResponseBody *)body
{
    self.mileageBody = body;
    [_tableView reloadData];
}

- (void)configOwnViews
{
    _data = [NSMutableArray array];
    
    
    [self addMenu:kCarInfo_Func_Str icon:[UIImage imageNamed:@"VRM_i05_002_Brief.png"] class:[CarInfoFunctionExplainViewController class]];
    [self addMenu:kCarInfo_Mile_Str icon:[UIImage imageNamed:@"VRM_i05_003_Mileage.png"] class:Nil];
    [self addMenu:kCarInfo_SMS_Str icon:[UIImage imageNamed:@"VRM_i05_004_MsgAdd.png"] class:Nil];
    [self addMenu:kCarInfo_OverSpeed_Str icon:[UIImage imageNamed:@"VRM_i05_005_OverSpeed.png"] class:Nil];
    [self addMenu:kCarInfo_Tracking_Str icon:[UIImage imageNamed:@"VRM_i05_006_Traking.png"] class:Nil];
    [self addMenu:kCarInfo_Playback_Str icon:[UIImage imageNamed:@"VRM_i05_007_Playback.png"] class:Nil];
    [self addMenu:kCarInfo_EleFence_Str icon:[UIImage imageNamed:@"VRM_i05_008_Fence.png"] class:Nil];
    
    
    __weak typeof(self) weakSelf = self;
    GetMileage *gm = [[GetMileage alloc] initWithHandler:^(BaseRequest *request) {
        GetMileageResponseBody *body = (GetMileageResponseBody *)request.response.Body;
        [weakSelf onGetMileage:body];
    }];
    gm.VehicleNumber = self.vehicle.VehicleNumber;
    [[WebServiceEngine sharedEngine] asyncRequest:gm];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.vehicle.DeviceName;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//#define kWTATableCellIdentifier @"WTATableCellIdentifier"
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 2;
//    return _data.count;
//}

//#define kButtonSettingSize CGSizeMake(60, 30)
#define kButtonSettingSize CGSizeMake(60, 30)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        // 功能说明
        case ECarInfo_FunctionExplain:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_FunctionExplain"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ECarInfo_FunctionExplain"];
                cell.backgroundColor = [UIColor clearColor];
                cell.textLabel.textColor = kBlackColor;
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            MenuItem *menu = _data[indexPath.row];
            cell.textLabel.text = menu.title;
            cell.imageView.image = menu.icon;
            return cell;
        }
            break;
        // 里程
        case ECarInfo_Distance:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_Distance"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ECarInfo_Distance"];
                cell.backgroundColor = [UIColor clearColor];
                cell.textLabel.textColor = kBlackColor;
                cell.detailTextLabel.textColor = kBlackColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            MenuItem *menu = _data[indexPath.row];
            cell.textLabel.text = menu.title;
            cell.imageView.image = menu.icon;
            if (_mileageBody)
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld km", (long)_mileageBody.Mileage];
            }
            else
            {
                cell.detailTextLabel.text = nil;
            }
            return cell;
        }
            break;
            // 短信取地址
        case ECarInfo_MessageAddress:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_MessageAddress"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ECarInfo_MessageAddress"];
                cell.backgroundColor = [UIColor clearColor];
                cell.textLabel.textColor = kBlackColor;
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIButton *button = [UIButton buttonWithTip:kCarInfo_Query_Str];
                button.tag = 1000 + indexPath.row;
                [button setTitleColor:kBlackColor forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"VRM_i05_009_ButtonSet.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"VRM_i05_010_ButtonSetPressed.png"] forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage imageNamed:@"VRM_i05_010_ButtonSetPressed.png"] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(onMessageAddress:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
            }
            
            MenuItem *menu = _data[indexPath.row];
            cell.textLabel.text = menu.title;
            cell.imageView.image = menu.icon;
            
            UIView *button = [cell.contentView viewWithTag:1000 + indexPath.row];
            [button sizeWith:kButtonSettingSize];
            [button layoutParentVerticalCenter];
            [button alignParentRightWithMargin:15];
            return cell;
        }
            break;
            // 超速设置
        case ECarInfo_OverSpeed:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_MessageAddress"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ECarInfo_MessageAddress"];
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
                [button addTarget:self action:@selector(onOverspeed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
            }
            
            MenuItem *menu = _data[indexPath.row];
            cell.textLabel.text = menu.title;
            cell.imageView.image = menu.icon;
            
            UIView *button = [cell.contentView viewWithTag:1000 + indexPath.row];
            [button sizeWith:kButtonSettingSize];
            [button layoutParentVerticalCenter];
            [button alignParentRightWithMargin:15];
            return cell;
        }
            break;
            // 跟踪
        case ECarInfo_Track:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_Track"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ECarInfo_Track"];
                cell.backgroundColor = [UIColor clearColor];
                cell.textLabel.textColor = kBlackColor;
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.detailTextLabel.textColor = kBlackColor;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIButton *alert = [[SwitchButton alloc] init];
                alert.tag = 3000 + indexPath.row;
                [alert addTarget:self action:@selector(onTrack:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:alert];
                
            }
            
            MenuItem *kv = _data[indexPath.row];
            
            cell.imageView.image = kv.icon;
            cell.textLabel.text = kv.title;
            
            WebServiceEngine *we = [WebServiceEngine sharedEngine];
            SwitchButton *alert = (SwitchButton *)[cell.contentView viewWithTag:3000 + indexPath.row];
            alert.on = [self.vehicle.DeviceName isEqualToString:we.vehicle.DeviceName] &&  we.isTracking;
            [alert sizeWith:kButtonSettingSize];
            [alert layoutParentVerticalCenter];
            [alert alignParentRightWithMargin:15];
            return cell;
        }
            break;
            // 回放
        case ECarInfo_Playback:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_Playback"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ECarInfo_Playback"];
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
                [button addTarget:self action:@selector(onPlayback:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
            }
            
            MenuItem *menu = _data[indexPath.row];
            cell.textLabel.text = menu.title;
            cell.imageView.image = menu.icon;
            
            UIView *button = [cell.contentView viewWithTag:1000 + indexPath.row];
            [button sizeWith:CGSizeMake(60, 30)];
            [button layoutParentVerticalCenter];
            [button alignParentRightWithMargin:15];
            return cell;
        }
            break;
            // 电子围栏
        case ECarInfo_ElectronicFence:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECarInfo_ElectronicFence"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ECarInfo_ElectronicFence"];
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
                [button addTarget:self action:@selector(onElectronicFence:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
            }
            
            MenuItem *menu = _data[indexPath.row];
            cell.textLabel.text = menu.title;
            cell.imageView.image = menu.icon;
            
            UIView *button = [cell.contentView viewWithTag:1000 + indexPath.row];
            [button sizeWith:CGSizeMake(60, 30)];
            [button layoutParentVerticalCenter];
            [button alignParentRightWithMargin:15];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}

- (void)onGetphoneNum:(NSString *)phone
{
    __weak typeof(self) weakSelf = self;
    AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kCarInfo_SendMS_Tip_Str];
    [alert addButtonWithTitle:kCancel_Str];
    
    [alert addButtonWithTitle:kOK_Str action:^(AlertPopup *alert) {
        
        //        SendSMSPosition *ssp = [[SendSMSPosition alloc] initWithHandler:^(BaseRequest *request) {
        //            [[HUDHelper sharedInstance] tipMessage:[request.response message]];
        //        }];
        //        ssp.VehicleNumber = self.vehicle.VehicleNumber;
        //        [[WebServiceEngine sharedEngine] asyncRequest:ssp];
        
        [weakSelf displaySMSComposerSheet:phone];
        [alert closePopup];
        
    }];
    [PopupView alertInWindow:alert];
}

- (void)onMessageAddress:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    // 取Device手机号
    GetDevInfo *gdi = [[GetDevInfo alloc] initWithHandler:^(BaseRequest *request) {
        GetDevInfoResponseBody *body = (GetDevInfoResponseBody *)request.response.Body;
        if ([NSString isEmpty:body.SIMNumber])
        {
            [[HUDHelper sharedInstance] tipMessage:kCarInfo_NoGetPhoneNum_Tip_Str];
        }
        else
        {
            [weakSelf onGetphoneNum:body.SIMNumber];
        }
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:gdi];
    
    // SendSMSPosition
    SendSMSPosition *ssp = [[SendSMSPosition alloc] initWithHandler:^(BaseRequest *request) {
//        [[HUDHelper sharedInstance] tipMessage:[request.response message]];
    }];
    ssp.VehicleNumber = weakSelf.vehicle.VehicleNumber;
    [[WebServiceEngine sharedEngine] asyncRequest:ssp];
}

-(void)displaySMSComposerSheet:(NSString *)num
{
    // 进入短信界面
    if ([NSString isEmpty:num])
    {
        return;
    }
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        
        //    NSMutableString* absUrl = [[NSMutableString alloc] initWithString:web.request.URL.absoluteString];
        //    [absUrl replaceOccurrencesOfString:@"http://i.aizheke.com" withString:@"http://m.aizheke.com" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [absUrl length])];
        picker.recipients = @[num];
        picker.subject = num;
        picker.body = @"POSITION#";
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kCarInfo_NoMsgFunc_Tip_Str];
        [alert addButtonWithTitle:kCarInfo_NoMsgFunc_Known_Str];
        [PopupView alertInWindow:alert];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kCarInfo_NoMsgFunc_Tip_Str delegate:nil cancelButtonTitle:kCarInfo_NoMsgFunc_Known_Str otherButtonTitles:nil, nil];
//        [alert show];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    // 短信界面回调
    switch (result)
    {
        case MessageComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
        {
//            __weak typeof(self) weakSelf = self;
//            SendSMSPosition *ssp = [[SendSMSPosition alloc] initWithHandler:^(BaseRequest *request) {
//                [[HUDHelper sharedInstance] tipMessage:[request.response message]];
//            }];
//            ssp.VehicleNumber = weakSelf.vehicle.VehicleNumber;
//            [[WebServiceEngine sharedEngine] asyncRequest:ssp];
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case MessageComposeResultFailed:
            [[HUDHelper sharedInstance] tipMessage:kCarInfo_SendMSG_Fail_Str];
            break;
        default:
            break;
    }
}

// 超速处理
- (void)onOverspeed:(UIButton *)button
{
    MenuItem *item = _data[button.tag - 1000];
    __weak typeof(self) weakSelf = self;
    InputPopupContentView *popup = [[InputPopupContentView alloc] initWith:item.title editText:nil doneAction:^(PopupContentView *pop, NSString *editText) {
        if ([NSString isEmpty:editText]) {
            [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
            return;
        }
        
        if (editText.floatValue <= 0)
        {
            [[HUDHelper sharedInstance] tipMessage:kInputErr_Str];
            return;
        }
        
        SetSpeed *ss = [[SetSpeed alloc] initWithHandler:^(BaseRequest *request) {
            
            weakSelf.vehicle.SpeedAlert = editText.floatValue;
//            [[HUDHelper sharedInstance] tipMessage:[request.response message]];
            
            [pop closePopup];
        }];
        ss.VehicleNumber = weakSelf.vehicle.VehicleNumber;
        ss.IsEnable = YES;
        ss.SpeedAlert = editText.floatValue;
        
        [[WebServiceEngine sharedEngine] asyncRequest:ss];
    }];
    popup.edit.keyboardType = UIKeyboardTypeNumberPad;
    popup.edit.text = [NSString stringWithFormat:@"%d", (int)_vehicle.SpeedAlert];
    [popup setEditUnit:@"km/h"];
    [PopupView alertInWindow:popup];
}

// 跟踪处理
- (void)onTrack:(SwitchButton *)alert
{
    alert.on = !alert.on;
    [WebServiceEngine sharedEngine].vehicle = self.vehicle;
    [WebServiceEngine sharedEngine].isTracking = alert.on;
    [[AppDelegate sharedAppDelegate] popToRootViewController];
}


// 回放处理
- (void)onPlayback:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    PlaybackPopupContentView *pop = [[PlaybackPopupContentView alloc] initWithDone:^(PlaybackPopupContentView *pop, NSString *fromTime, NSString *toTime) {
        @autoreleasepool
        {
            
#if kSupportGMap
            if ([AppDelegate sharedAppDelegate].isChinese)
            {
                CarPlaybackViewController *pv = [NSObject loadClass:[CarPlaybackViewController class]];
                pv.fromTime = fromTime;
                pv.toTime = toTime;
                pv.vehicle = weakSelf.vehicle;
                [[AppDelegate sharedAppDelegate] pushViewController:pv];
            }
            else
            {
                
#if kSupportGoogleMap
                CarPlaybackGoogleMapViewController *pv = [NSObject loadClass:[CarPlaybackGoogleMapViewController class]];
                pv.fromTime = fromTime;
                pv.toTime = toTime;
                pv.vehicle = weakSelf.vehicle;
                [[AppDelegate sharedAppDelegate] pushViewController:pv];
#else
                CarPlaybackGMapViewController *pv = [NSObject loadClass:[CarPlaybackGMapViewController class]];
                pv.fromTime = fromTime;
                pv.toTime = toTime;
                pv.vehicle = weakSelf.vehicle;
                [[AppDelegate sharedAppDelegate] pushViewController:pv];
#endif

                
            }
#else
            CarPlaybackViewController *pv = [NSObject loadClass:[CarPlaybackViewController class]];
            pv.fromTime = fromTime;
            pv.toTime = toTime;
            pv.vehicle = weakSelf.vehicle;
            [[AppDelegate sharedAppDelegate] pushViewController:pv];
#endif
            
            
        }
        [pop closePopup];
    }];
    [PopupView alertInWindow:pop];
}

// 显示围栏
- (void)onElectronicFence:(UIButton *)button
{
#if kSupportGMap
    if ([AppDelegate sharedAppDelegate].isChinese)
    {
        CarElectronicFenceViewController *elec = [[CarElectronicFenceViewController alloc] init];
        elec.vehicle = self.vehicle;
        [[AppDelegate sharedAppDelegate] pushViewController:elec];
    }
    else
    {
#if kSupportGoogleMap
        CarEelecFenceGoogleMapViewController *elec = [[CarEelecFenceGoogleMapViewController alloc] init];
        elec.vehicle = self.vehicle;
        [[AppDelegate sharedAppDelegate] pushViewController:elec];
#else
        CarEelecFenceGViewController *elec = [[CarEelecFenceGViewController alloc] init];
        elec.vehicle = self.vehicle;
        [[AppDelegate sharedAppDelegate] pushViewController:elec];
#endif
    }
#else
    CarElectronicFenceViewController *elec = [[CarElectronicFenceViewController alloc] init];
    elec.vehicle = self.vehicle;
    [[AppDelegate sharedAppDelegate] pushViewController:elec];
#endif
    

    
}
#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuItem *item = [_data objectAtIndex:indexPath.row];
    [item menuAction];
}

@end
