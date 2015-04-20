//
//  CarListViewController.m
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarListViewController.h"

//@implementation CarListItem
//
//
//
//@end
//
//@implementation CarListSectionItem
//
//
//
//@end

// =========================================

@interface CarListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *carList;

@property (nonatomic, strong) VehicleGPSListItem *selectVehicle;

@end

@implementation CarListViewController

- (void)dealloc
{
    DebugLog(@"");
}

#define kRowHeight 50

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)addOwnViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = kRowHeight;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    
    
    BOOL isMuilt = [[WebServiceEngine sharedEngine] isMuiltMonitor];
    
    _multiMonitor = [[UIButton alloc] init];
    [_multiMonitor setTitle:kCarList_Muilt_Title_Str forState:UIControlStateNormal];
    [_multiMonitor setTitleColor:kBlackColor forState:UIControlStateNormal];
    
    UIImage *nor = [UIImage imageWithColor:kLightGrayColor size:CGSizeMake(self.view.bounds.size.width, kRowHeight)];
    UIImage *img = [UIImage imageWithColor:kOrangeColor size:CGSizeMake(self.view.bounds.size.width, kRowHeight)];
    if (isMuilt)
    {
        [_multiMonitor setBackgroundImage:img forState:UIControlStateNormal];
        [_multiMonitor setBackgroundImage:nor forState:UIControlStateSelected];
        [_multiMonitor setBackgroundImage:nor forState:UIControlStateHighlighted];
    }
    else
    {
        [_multiMonitor setBackgroundImage:nor forState:UIControlStateNormal];
        [_multiMonitor setBackgroundImage:img forState:UIControlStateSelected];
        [_multiMonitor setBackgroundImage:img forState:UIControlStateHighlighted];
    }
    
    [_multiMonitor addTarget:self action:@selector(onMultiMonitor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_multiMonitor];
    
}

// 多车监控处理，设置muilVehicleNumbers
- (void)onMultiMonitor
{
    NSMutableString *vehNums = [NSMutableString string];
    for (GroupListItem *item in _carList)
    {
        for (VehicleGPSListItem *veh in item.VehicleList)
        {
            [vehNums appendString:[NSString stringWithFormat:@"%@,", veh.VehicleNumber]];
        }
    }
    
    [WebServiceEngine sharedEngine].muilVehicleNumbers = [vehNums substringAtRange:NSMakeRange(0, vehNums.length - 1)];
    [WebServiceEngine sharedEngine].isTracking = NO;
    [[AppDelegate sharedAppDelegate] performSelector:@selector(popViewController) withObject:nil afterDelay:0.5];
}

// GetDevList回调处理，并把当前显示的民开
- (void)onGetDevList:(GetDevListResponseBody *)body
{
    self.carList = body.GroupList;
    
    VehicleGPSListItem *vehicle = [WebServiceEngine sharedEngine].vehicle;
    
    BOOL hasFind = NO;
    for (GroupListItem *item in _carList)
    {
        for (VehicleGPSListItem *veh in item.VehicleList)
        {
            if ([veh.VehicleNumber isEqualToString:vehicle.VehicleNumber]) {
                item.isExpand = YES;
                hasFind = YES;
                break;
            }
        }
        
        if (hasFind)
        {
            break;
        }
    }
    
    [_tableView reloadData];

}

- (void)configOwnViews
{
    self.title = kCarList_Title_Str;
    
    
    // 请求GetDevList
    __weak typeof(self) weakSelf = self;
    GetDevList *gdl = [[GetDevList alloc] initWithHandler:^(BaseRequest *request) {
        GetDevListResponseBody *body = (GetDevListResponseBody *)request.response.Body;
        [weakSelf onGetDevList:body];
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:gdl];
    
    self.selectVehicle = [WebServiceEngine sharedEngine].vehicle;
}

- (void)layoutOnIPhone
{
    CGRect rect = self.view.bounds;
    
    CGRect monitorRect = rect;
    monitorRect.origin.y += rect.size.height - kRowHeight;
    monitorRect.size.height = kRowHeight;
    _multiMonitor.frame = monitorRect;
    
    rect.size.height -= kRowHeight;
    _tableView.frame = rect;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _carList.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GroupListItem *sectionItem = _carList[section];
    if (sectionItem.isExpand)
    {
        return sectionItem.VehicleList.count;
    }
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section
{
    return kRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CarListSectionView *sectionView = [[CarListSectionView alloc] init];
    __weak typeof(self) weakSelf = self;
    [sectionView configWith:_carList[section] clickAction:^(CarListSectionView *view) {
        weakSelf.selectVehicle = [WebServiceEngine sharedEngine].vehicle;
        [tableView reloadData];
    }];
    return sectionView;
}

#define kWTATableCellIdentifier @"WTATableCellIdentifier"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarListItemTableViewCell *cell = (CarListItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[CarListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWTATableCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = kClearColor;
    }
    
    
    // 设置选中状态
    GroupListItem *group = [_carList objectAtIndex:indexPath.section];
    VehicleGPSListItem *veh = group.VehicleList[indexPath.row];
    
    [cell configWith:veh];
    
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    if (![we isMuiltMonitor])
    {
        if ([veh.DeviceName isEqualToString:self.selectVehicle.DeviceName])
        {
            cell.location.hidden = NO;
            [cell setSelected:YES animated:YES];
            
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
            cell.location.hidden = ![veh.DeviceName isEqualToString:we.vehicle.DeviceName];
            [cell setSelected:NO animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarListItemTableViewCell *cell = (CarListItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.location.hidden = NO;
    GroupListItem *group = [_carList objectAtIndex:indexPath.section];
    VehicleGPSListItem *veh = group.VehicleList[indexPath.row];
    self.selectVehicle = veh;

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarListItemTableViewCell *cell = (CarListItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    GroupListItem *group = [_carList objectAtIndex:indexPath.section];
    VehicleGPSListItem *veh = group.VehicleList[indexPath.row];
    self.selectVehicle = veh;
    cell.location.hidden = ![veh.DeviceName isEqualToString:[WebServiceEngine sharedEngine].vehicle.DeviceName];
}




@end
