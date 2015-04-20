//
//  OBDResultHeaderView.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDResultHeaderView.h"

@implementation OBDResultHeaderView

//- (instancetype)init
//{
//    if (self = [super init])
//    {
//        self.layer.masksToBounds = YES;
//        self.layer.shadowColor = kBlackColor.CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 1);
//    }
//    return self;
//}

- (void)addOwnViews
{
    _bgView = [[UIImageView alloc] init];
    _bgView.image = [UIImage imageNamed:@"VRM_i10_003_WordBackground.png"];
    [self addSubview:_bgView];
    
    _leftLine = [[UIImageView alloc] init];
    _leftLine.backgroundColor = kLightGrayColor;
    [self addSubview:_leftLine];
    
    _deviceName = [[UILabel alloc] init];
    _deviceName.backgroundColor = kClearColor;
    _deviceName.textColor = kBlackColor;
    [self addSubview:_deviceName];
    
    _pullButton = [[UIButton alloc] init];
    [_pullButton setBackgroundImage:[UIImage imageNamed:@"VRM_i10_001_ButtonPull.png"] forState:UIControlStateNormal];
    [_pullButton addTarget:self action:@selector(onPull) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pullButton];
    
    _help = [[UIButton alloc] init];
    [_help setImage:[UIImage imageNamed:@"VRM_i10_002_ButtonWhy.png"] forState:UIControlStateNormal];
    [_help addTarget:self action:@selector(onHelp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_help];
    
    _rightLine = [[UIImageView alloc] init];
    _rightLine.backgroundColor = kLightGrayColor;
    [self addSubview:_rightLine];
}

- (void)onPull
{
    
}

- (void)onHelp
{
    [self sendMailInApp];
}

#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass)
    {
        [self alertWithMessage:kAppInfo_Feedback_NoMail_Str];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:kAppInfo_Feedback_NoMailAccount_Str];
        return;
    }
    [self displayMailPicker];
}

- (void)alertWithMessage:(NSString *)msg
{
    AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:msg];
    [alert addButtonWithTitle:kOK_Str];
    [PopupView alertInWindow:alert];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    //设置主题
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    NSString *subject = [NSString stringWithFormat:kAppInfo_Feedback_ContentFormat_Str, we.user.UserName, we.user.UserPhone];
    [mailPicker setSubject: subject];
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: kAppInfo_Feedback_Receiver_Str];
    [mailPicker setToRecipients: toRecipients];
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [[AppDelegate sharedAppDelegate].topViewController dismissViewControllerAnimated:YES completion:nil];
    NSString *msg = nil;
    switch (result)
    {
        case MFMailComposeResultSent:
            msg = kAppInfo_Feedback_Succ_Str;
            break;
        case MFMailComposeResultCancelled:
            //            msg = @"用户取消编辑邮件";
            //            break;
        case MFMailComposeResultSaved:
            //            msg = @"用户成功保存邮件";
            //            break;
        case MFMailComposeResultFailed:
            //            msg = @"用户试图保存或者发送邮件失败";
            //            break;
        default:
            //            msg = @"";
            break;
    }
    if (![NSString isEmpty:msg])
    {
        AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:msg];
        [alert addButtonWithTitle:kOK_Str];
        
        [PopupView alertInWindow:alert];
        //        [[HUDHelper sharedInstance] tipMessage:msg];
    }
}



#define kLineHorMargin 20
#define kHorMargin 10
#define kVerMargin 7

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    _bgView.frame = rect;
    
    [_pullButton sizeWith:[_pullButton backgroundImageForState:UIControlStateNormal].size];
    [_pullButton layoutParentCenter];
    
    [_leftLine sizeWith:CGSizeMake(1, rect.size.height - 2*kVerMargin)];
    [_leftLine alignParentLeftWithMargin:kLineHorMargin];
    [_leftLine layoutParentVerticalCenter];
    
    
    [_deviceName sameWith:_leftLine];
    [_deviceName layoutToRightOf:_leftLine margin:kHorMargin];
    [_deviceName scaleToLeftOf:_pullButton margin:kHorMargin];
    
    [_rightLine sameWith:_leftLine];
    [_rightLine alignParentRightWithMargin:kLineHorMargin];
    
    [_help sizeWith:[_help imageForState:UIControlStateNormal].size];
    [_help layoutParentVerticalCenter];
    [_help layoutToLeftOf:_rightLine margin:kHorMargin];
    
    
}


- (void)setVehicle:(VehicleGPSListItem *)vehicle
{
    _vehicle = vehicle;
    _deviceName.text = vehicle.DeviceName;
}

@end
