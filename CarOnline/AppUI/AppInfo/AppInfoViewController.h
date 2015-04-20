//
//  AppInfoViewController.h
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface AppInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
{
//    AppInfoView *_appInfoView;
    UITableView *_tableView;
    UIButton *_logoutButton;
    
    NSMutableArray *_settings;
}

@end
