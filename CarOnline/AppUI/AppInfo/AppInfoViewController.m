//
//  AppInfoViewController.m
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()

@property (nonatomic, strong) NSMutableArray *settings;

@end

@implementation AppInfoViewController

- (void)addMenu:(NSString *)title icon:(UIImage *)image class:(Class)viewClass
{
    MenuItem *menu = [[MenuItem alloc] initWithTitle:title icon:image action:^(id<MenuAbleItem> menu) {
        
        if (viewClass != Nil)
        {
            UIViewController *view = [[viewClass alloc] init];
            view.title = [menu title];
            [[AppDelegate sharedAppDelegate] pushViewController:view];
        }
        
    }];
    
    [_settings addObject:menu];
}

- (void)configParams
{
    self.settings = [NSMutableArray array];
    

    [self addMenu:kAppInfo_Feedback_Str icon:[UIImage imageNamed:@"VRM_i19_003_SystemFeedback.png"] class:[FeedbackViewController class]];

    [self addMenu:kAppInfo_Help_Str icon:[UIImage imageNamed:@"VRM_i19_004_SystemHelp.png"] class:[HelpInfoViewController class]];
    
    [self addMenu:kAppInfo_CheckUpdate_Str icon:[UIImage imageNamed:@"VRM_i19_005_SystemUpdata.png"] class:[CheckVersionViewController class]];
    
    [self addMenu:kAppInfo_AboutUs_Str icon:[UIImage imageNamed:@"VRM_i19_006_SystemAboutUs.png"] class:[AboutUsViewController class]];
    
    [self addMenu:kAppInfo_Web_Str icon:[UIImage imageNamed:@"VRM_i19_007_Website.png"] class:[OfficialWebsiteViewController class]];
    
    [self addMenu:kAppInfo_Wechat_Str icon:[UIImage imageNamed:@"VRM_i19_008_Wechat.png"] class:[FollowWechatViewController class]];
}

#define kSettingTableViewRowHeight 50

- (void)addOwnViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = kSettingTableViewRowHeight;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }

    _tableView.scrollEnabled = NO;
    
    _logoutButton = [UIButton buttonWithTip:kAppInfo_Logout_Str];
//    _logoutButton.backgroundColor = kRedColor;
//    _logoutButton.layer.cornerRadius = 5;
    
    [_logoutButton setBackgroundImage:[UIImage imageNamed:@"VRM_i19_001_ButtonLogout.png"] forState:UIControlStateNormal];
    [_logoutButton setBackgroundImage:[UIImage imageNamed:@"VRM_i19_002_ButtonLogoutPressed.png"] forState:UIControlStateHighlighted];
    [_logoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_logoutButton addTarget:self action:@selector(onLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logoutButton];
    
}

- (void)onLogout
{
    // 退出登录
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kAppLoginUserIDKey];
    [ud removeObjectForKey:kAppLoginUserPWDKey];
    [ud synchronize];
    
    [[AppDelegate sharedAppDelegate] enterMainUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kAppInfo_Title_Str;
}

#define kAppInfoHeight  0

#define kLogoutButtonHeight 44

- (void)layoutOnIPhone
{
    CGRect rect = self.view.bounds;
    
//    [_appInfoView sizeWith:CGSizeMake(200, kAppInfoHeight)];
//    [_appInfoView layoutParentHorizontalCenter];
//    [_appInfoView relayoutFrameOfSubViews];
    
    [_tableView sizeWith:CGSizeMake(rect.size.width, kSettingTableViewRowHeight * _settings.count)];
    [_tableView alignParentTop];
    

    
    [_logoutButton sizeWith:CGSizeMake(290, kLogoutButtonHeight)];
    [_logoutButton layoutBelow:_tableView margin:10];
    [_logoutButton layoutParentHorizontalCenter];
    
}


#pragma mark - UITableViewDatasource Methods

#define kWTATableCellIdentifier  @"WTATableCellIdentifier"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = kBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    
    MenuItem *item = [self.settings objectAtIndex:indexPath.row];
    cell.textLabel.text = [item title];
    cell.imageView.image = [item icon];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        [self sendMailInApp];
        return;
    }
    else if (indexPath.row == 2)
    {
        // 检查更新
        CheckUpdates *cu = [[CheckUpdates alloc] initWithHandler:^(BaseRequest *request) {

            CheckUpdatesResponseBody *body = (CheckUpdatesResponseBody *)request.response.Body;
            
            NSString *appbundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([appbundleVersion isEqualToString:body.CurrentVersionCode])
            {
                AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kAppInfo_Update_Latest_Tip_Str];
                [alert addButtonWithTitle:kOK_Str];
                [PopupView alertInWindow:alert];
            }
            else
            {
                if (![NSString isEmpty:body.DownLoadUrl] && ![NSString isEmpty:body.updateInfo])
                {
                    AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:body.updateInfo];
                    [alert addButtonWithTitle:kAppInfo_Update_Upgrade_Str action:^(AlertPopup *selfPtr) {
                        
                        // upgrade now
                        NSURL *url = [NSURL URLWithString:body.DownLoadUrl];
                        [[UIApplication sharedApplication] openURL:url];
                        
                        [selfPtr closePopup];
                        
                    }];
                    
                    [alert addButtonWithTitle:kCancel_Str];
                    
                    [PopupView alertInWindow:alert];
                }
                else
                {
                    // 接口返回出错处理
                    AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kAppInfo_Update_Latest_Tip_Str];
                    [alert addButtonWithTitle:kOK_Str];
                    [PopupView alertInWindow:alert];
                }
            }
            
        }];
        [[WebServiceEngine sharedEngine] asyncRequest:cu wait:YES];
        return;
    }
    else if (indexPath.row == 4)
    {
        // 访问官网
        
        AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kAppInfo_BrowseWeb_Str];
        [alert addButtonWithTitle:kCancel_Str];
        [alert addButtonWithTitle:kOK_Str action:^(AlertPopup *selfPtr) {
            
            // upgrade now
            NSURL *url = [NSURL URLWithString:@"http://www.igpsobd.com/"];
            [[UIApplication sharedApplication] openURL:url];
            
            [selfPtr closePopup];
            
        }];
        
        
        
        [PopupView alertInWindow:alert];
        
        return;
    }
        
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuItem *item = [self.settings objectAtIndex:indexPath.row];
    [item menuAction];
}

-(void)launchMailApp
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:kAppInfo_Feedback_Subject_Str];
    //添加邮件内容
//    [mailUrl appendString:@"&body=<b>email</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:kOK_Str otherButtonTitles:nil, nil];
//    [alert show];
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
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
//    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
//    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
//    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    //添加一个pdf附件
//    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
//    NSString *emailBody = @"<font color='red'>eMail</font> 正文";
//    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
    
    
//    [self presentViewController:mailPicker animated:YES completion:^{
//        UIViewController *last = [[mailPicker viewControllers] lastObject];
//        UINavigationItem *nav = [last navigationItem];
//        [nav setTitle:nil];
//    }];
    

}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
