//
//  LoginViewController.h
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
{
    UIView *_loginView;
    
    UIImageView *_appLogoIcon;
    
    UIImageView *_editBg;
    
    UITextField *_accountEditView;
    UITextField *_pwdEditView;
    
    UIButton *_loginButton;
}

@end
