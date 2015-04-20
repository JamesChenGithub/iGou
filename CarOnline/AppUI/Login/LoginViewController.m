//
//  LoginViewController.m
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "LoginViewController.h"

@interface CenterPlaceHolderTextField : UITextField

@end

@implementation CenterPlaceHolderTextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGSize size = [self.placeholder sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (size.width > bounds.size.width)
    {
        return CGRectInset(bounds, 0, 2);
    }
    return CGRectInset(bounds, (bounds.size.width - size.width)/2, 2);
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[[UIColor grayColor] colorWithAlphaComponent:0.7] setFill];
    
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:17]];
}

@end


@interface LoginViewController ()

@end

@implementation LoginViewController

- (BOOL)hasBackgroundView
{
    return YES;
}

- (void)configBackground
{
    _backgroundView.backgroundColor = kGrayColor;
    IOSDeviceConfig *ios = [IOSDeviceConfig sharedConfig];
    if (ios.isIPhone5)
    {
        UIImage *image = [UIImage imageNamed:@"login_bg_5.jpg"];
        _backgroundView.image = image;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"login_bg_4.jpg"];
        _backgroundView.image = image;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlank:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
    [self performSelector:@selector(tryLogin) withObject:nil afterDelay:0.5];
    
    
}

- (void)onTapBlank:(UITapGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        [_accountEditView resignFirstResponder];
        [_pwdEditView resignFirstResponder];
    }
}

- (void)addOwnViews
{
    _loginView = [[UIView alloc] init];
    [self.view addSubview:_loginView];
    
    _appLogoIcon = [[UIImageView alloc] init];
    _appLogoIcon.image = [UIImage imageNamed:@"VRM_i03_001_Logo"];
    [_loginView addSubview:_appLogoIcon];
    
    _editBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_edit_bg.png"]];
    [_loginView addSubview:_editBg];
    _editBg.userInteractionEnabled = YES;
    
    _accountEditView = [[CenterPlaceHolderTextField alloc] init];
    _accountEditView.placeholder = kLogin_Account_Str;
    _accountEditView.textColor = kWhiteColor;
    _accountEditView.borderStyle = UITextBorderStyleNone;
    _accountEditView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _accountEditView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_editBg addSubview:_accountEditView];
    
    _pwdEditView = [[CenterPlaceHolderTextField alloc] init];
    [_pwdEditView setSecureTextEntry:YES];
    _pwdEditView.placeholder = kLogin_Password_Str;
    _pwdEditView.textColor = kWhiteColor;
    _pwdEditView.borderStyle = UITextBorderStyleNone;
    _pwdEditView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdEditView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_editBg addSubview:_pwdEditView];

    
    _loginButton = [UIButton buttonWithTip:kLogin_Login_Str];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"VRM_i03_003_ButtonLogin.png"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"VRM_i03_003_ButtonLoginPressed.png"] forState:UIControlStateNormal];
    [_loginButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_loginButton addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_loginButton];
    
    _loginView.hidden = YES;
}


- (void)tryLogin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = (NSString *)[ud valueForKey:kAppLoginUserIDKey];
    NSString *pwd = (NSString *)[ud valueForKey:kAppLoginUserPWDKey];
    
    _accountEditView.text = userid;
    _pwdEditView.text = pwd;
    
    
    if (![NSString isEmpty:userid] && ![NSString isEmpty:pwd])
    {
        [self onLogin];
    }
    else
    {
        [_loginView slideInFrom:kFTAnimationRight duration:0.3 delegate:nil];
    }
}

- (void)onLogin
{
    if ([NSString isEmpty:_accountEditView.text])
    {
        [[HUDHelper sharedInstance] tipMessage:kLogin_Account_Empty_Str];
        return;
    }
    
    if ([NSString isEmpty:_pwdEditView.text])
    {
        [[HUDHelper sharedInstance] tipMessage:kLogin_Password_Empty_Str];
        return;
    }
    
    APPLogin *applogin = [[APPLogin alloc] initWithHandler:^(BaseRequest *request) {
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:_accountEditView.text forKey:kAppLoginUserIDKey];
        [ud setObject:_pwdEditView.text forKey:kAppLoginUserPWDKey];
        
        [ud synchronize];
        
        WebServiceEngine *wse = [WebServiceEngine sharedEngine];
        APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
        wse.user.UserName = body.UserName;
        wse.user.UserCode = body.UserCode;
        wse.user.UserPhone = body.UserPhone;
        wse.user.Password = _pwdEditView.text;
        
        [[AppDelegate sharedAppDelegate] toGPSMain];
    }];
    applogin.UserName = _accountEditView.text;
    applogin.Password = _pwdEditView.text;
    
    
    __weak typeof(_loginView) wl = _loginView;
    applogin.failHandler = ^(BaseRequest *request) {
        [wl slideInFrom:kFTAnimationRight duration:0.3 delegate:nil];
    };
    
    [[WebServiceEngine sharedEngine] performSelector:@selector(asyncRequest:) withObject:applogin afterDelay:0.5];
    
    
}

- (void)layoutOnIPhone
{
    [super layoutOnIPhone];
    CGRect rect = self.view.bounds;
    
    [_loginView sizeWith:CGSizeMake(rect.size.width - 80, 200)];
    [_loginView layoutParentHorizontalCenter];
    [_loginView alignParentTopWithMargin: [IOSDeviceConfig sharedConfig].isIPhone4 ? 30 : 100];
    
    [_appLogoIcon sizeWith:_appLogoIcon.image.size];
    [_appLogoIcon layoutParentHorizontalCenter];
    
    
    CGSize bgsize = _editBg.image.size;
    bgsize = CGSizeMake(bgsize.width*1.5, bgsize.height*1.5);
    [_editBg sizeWith:bgsize];
    [_editBg layoutParentHorizontalCenter];
    [_editBg layoutBelow:_appLogoIcon margin:15];
    
    [_accountEditView sizeWith:CGSizeMake(bgsize.width, bgsize.height/2)];
    [_accountEditView alignParentTop];
    
    [_pwdEditView sameWith:_accountEditView];
    [_pwdEditView layoutBelow:_accountEditView margin:1];
    
    [_loginButton sizeWith:CGSizeMake(bgsize.width, bgsize.height/2)];
    [_loginButton layoutBelow:_editBg margin:5];
    [_loginButton layoutParentHorizontalCenter];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
