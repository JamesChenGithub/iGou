//
//  CarInfoFunctionExplainViewController.m
//  CarOnline
//
//  Created by James on 14-7-23.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarInfoFunctionExplainViewController.h"

@interface CarInfoFunctionExplainViewController ()

@end

@implementation CarInfoFunctionExplainViewController

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


- (void)configOwnViews
{
    // 配置功能说明相关的界面
    self.title = kCarInfoFunction_Func_Str;
    _data = [NSMutableArray array];
    
    [self addMenu:kCarInfoFunction_Mile_Str icon:[UIImage imageNamed:@"VRM_i05_003_Mileage.png"] class:Nil];
    [self addMenu:kCarInfoFunction_SMS_Str icon:[UIImage imageNamed:@"VRM_i05_004_MsgAdd.png"] class:Nil];
    [self addMenu:kCarInfoFunction_OverSpeed_Str icon:[UIImage imageNamed:@"VRM_i05_005_OverSpeed.png"] class:Nil];
    [self addMenu:kCarInfoFunction_Tracking_Str icon:[UIImage imageNamed:@"VRM_i05_006_Traking.png"] class:Nil];
    [self addMenu:kCarInfoFunction_Playback_Str icon:[UIImage imageNamed:@"VRM_i05_007_Playback.png"] class:Nil];
    [self addMenu:kCarInfoFunction_EleFence_Str icon:[UIImage imageNamed:@"VRM_i05_008_Fence.png"] class:Nil];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultTableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    }
    
    MenuItem *menu = _data[indexPath.row];
    cell.textLabel.text = menu.title;
    cell.imageView.image = menu.icon;
    return cell;
}
@end
