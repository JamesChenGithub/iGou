//
//  TestServerViewController.m
//  CarOnline
//
//  Created by James on 14-8-4.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "TestServerViewController.h"

@interface TestServerViewController ()

@property (nonatomic, strong) NSMutableArray *menus;

@end

@implementation TestServerViewController

- (void)addMenu:(NSString *)title action:(MenuAction)action
{
    MenuItem *menu = [[MenuItem alloc] initWithTitle:title icon:nil action:action];
    
    [self.menus addObject:menu];
}


- (void)configParams
{
    self.menus = [NSMutableArray array];
    
    
    [self addMenu:@"AppLogin" action:^(id<MenuAbleItem> item) {
        APPLogin *applogin = [[APPLogin alloc] initWithHandler:^(BaseRequest *request) {
            WebServiceEngine *wse = [WebServiceEngine sharedEngine];
            APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
            wse.user.UserName = body.UserName;
            wse.user.UserCode = body.UserCode;
            wse.user.Password = @"103709";
        }];
        applogin.UserName = @"Test709";
        applogin.Password = @"103709";
        
        
        [[WebServiceEngine sharedEngine] asyncRequest:applogin];
    }];
    
    
    [self addMenu:@"GetDevList" action:^(id<MenuAbleItem> item) {
        GetDevList *getDevList = [[GetDevList alloc] initWithHandler:^(BaseRequest *request) {
//            WebServiceEngine *wse = [WebServiceEngine sharedEngine];
//            APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
//            wse.user.UserName = body.UserName;
//            wse.user.UserCode = body.UserCode;
//            wse.user.Password = @"103709";
        }];
//        applogin.UserName = @"Test709";
//        applogin.Password = @"103709";
        
        
        [[WebServiceEngine sharedEngine] asyncRequest:getDevList];
    }];
    
    [self addMenu:@"GetGpsData" action:^(id<MenuAbleItem> item) {
        GetGpsData *getGpsData = [[GetGpsData alloc] initWithHandler:^(BaseRequest *request) {
            //            WebServiceEngine *wse = [WebServiceEngine sharedEngine];
            //            APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
            //            wse.user.UserName = body.UserName;
            //            wse.user.UserCode = body.UserCode;
            //            wse.user.Password = @"103709";
        }];
//        getGpsData.ID = @"Test709";
        getGpsData.VehicleNumbers = @"253501101103709";
        
        
        [[WebServiceEngine sharedEngine] asyncRequest:getGpsData];
    }];
    
    [self addMenu:@"GetUnreadAlarminfoCount" action:^(id<MenuAbleItem> item) {
        GetUnreadAlarminfoCount *req = [[GetUnreadAlarminfoCount alloc] initWithHandler:^(BaseRequest *request) {
            //            WebServiceEngine *wse = [WebServiceEngine sharedEngine];
            //            APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
            //            wse.user.UserName = body.UserName;
            //            wse.user.UserCode = body.UserCode;
            //            wse.user.Password = @"103709";
        }];
        //        getGpsData.ID = @"Test709";
        req.VehicleNumbers = @"253501101103709";
        
        
        [[WebServiceEngine sharedEngine] asyncRequest:req];
    }];
    
    
    [self addMenu:@"GetDevInfo" action:^(id<MenuAbleItem> item) {
        GetDevInfo *req = [[GetDevInfo alloc] initWithHandler:^(BaseRequest *request) {
            //            WebServiceEngine *wse = [WebServiceEngine sharedEngine];
            //            APPLoginResponseBody *body = (APPLoginResponseBody *)request.response.Body;
            //            wse.user.UserName = body.UserName;
            //            wse.user.UserCode = body.UserCode;
            //            wse.user.Password = @"103709";
        }];
        //        getGpsData.ID = @"Test709";
        req.VehicleNumber = @"253501101103709";
        
        
        [[WebServiceEngine sharedEngine] asyncRequest:req];
    }];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configParams];
    self.title = @"测试接口";

}

#define kAppInfoHeight  60

#define kLogoutButtonHeight 44

//- (void)layoutOnIPhone
//{
//    CGRect rect = self.view.bounds;
//    
//    [_appInfoView sizeWith:CGSizeMake(200, kAppInfoHeight)];
//    [_appInfoView layoutParentHorizontalCenter];
//    [_appInfoView relayoutFrameOfSubViews];
//    
//    [_tableView sizeWith:CGSizeMake(rect.size.width, kSettingTableViewRowHeight * _menus.count)];
//    [_tableView layoutBelow:_appInfoView];
//    
//    
//    
//    [_logoutButton sizeWith:CGSizeMake(290, kLogoutButtonHeight)];
//    [_logoutButton layoutBelow:_tableView margin:10];
//    [_logoutButton layoutParentHorizontalCenter];
//    
//}


#pragma mark - UITableViewDatasource Methods

#define kWTATableCellIdentifier  @"WTATableCellIdentifier"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = kBlackColor;
    }
    
    MenuItem *item = [self.menus objectAtIndex:indexPath.row];
    cell.textLabel.text = [item title];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuItem *item = [self.menus objectAtIndex:indexPath.row];
    [item menuAction];
}

@end