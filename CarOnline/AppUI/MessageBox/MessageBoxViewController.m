//
//  MessageBoxViewController.m
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "MessageBoxViewController.h"

@interface MessageBoxViewController ()

@end

@implementation MessageBoxViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    _startIndex = 1;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = kMessageBox_Title_Str;
    
    self.data = [NSMutableArray array];
    
    self.view.backgroundColor = kWhiteColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteAlarm:) name:kDeleteAlarmNotify object:nil];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)onDeleteAlarm:(NSNotification *)notify
{
    AlertListItem *item = (AlertListItem *)notify.object;
    NSInteger index = [_data indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView beginUpdates];
    [_data removeObject:item];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView endUpdates];
}

- (void)addOwnViews
{
    [super addOwnViews];
#if kSupportOldUI
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
}

- (void)layoutOnIPhone
{
    [super layoutOnIPhone];
    [self resetMoreView];
}

- (void)resetMoreView
{
    _reloading = NO;
    if (nil == _refreshHeaderView)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, _tableView.contentSize.height, _tableView.frame.size.width, 65)];
        _refreshHeaderView.delegate = self;
        [_tableView addSubview:_refreshHeaderView];
    }
    else
    {
        _refreshHeaderView.frame = CGRectMake(0.0f, _tableView.contentSize.height, _tableView.frame.size.width, 65);
    }
    
    if (_tableView.contentSize.height < _tableView.frame.size.height)
    {
        _refreshHeaderView.hidden = YES;
    }
    else
    {
        _refreshHeaderView.hidden = NO;
    }
}

- (void)onGetAlarminfoList:(GetAlarminfoListResponseBody *)body
{
    // 更新列表显示
    if (body.AlertList.count)
    {
        // 有更多数据的时候进行刷新
        if (!_hasRecodeStarID)
        {
            WebServiceEngine *we = [WebServiceEngine sharedEngine];
            AlertListItem *item = body.AlertList[0];
            if (item.AlertId.integerValue > we.startAlertId.integerValue)
            {
                we.startAlertId = item.AlertId;
            }
            _hasRecodeStarID = YES;
        }
        
        _startIndex += body.AlertList.count;
        [self.data addObjectsFromArray:body.AlertList];
        [self refreshAfterLoadMore];
    }
    else
    {
        // 没有更多的时候，重置相关内容
        [self stopLoadMore];
        [self resetMoreView];
        [self onLoadOver];
        [[HUDHelper sharedInstance] tipMessage:kMessageBox_NoMore_Str];
    }
    
}

- (void)configOwnViews
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUnreadAlertCountKey];
    // 请求警告信息
    WebServiceEngine *we = [WebServiceEngine sharedEngine];

    __weak typeof(self) weakSelf = self;
    GetAlarminfoList *gal = [[GetAlarminfoList alloc] initWithHandler:^(BaseRequest *request) {
        GetAlarminfoListResponseBody *body = (GetAlarminfoListResponseBody *)request.response.Body;
        [weakSelf onGetAlarminfoList:body];
    }];
    gal.StartRecord = _startIndex;
    gal.VehicleNumbers = self.vehicleNumbers;
    [we asyncRequest:gal];
    
//    _data = [NSMutableArray array];
//    
//    [_data addObject:@"Test Message"];
//    [_data addObject:@"Test Message, Test Message, Test Message, Test Message, Test Message, Test Message, Test Message, Test Message, Test Message, Test Message, Test Message"];
}

#define kTableViewCellIdentifier @"MessageBoxTableViewCell"

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id kv = _data[indexPath.row];
    return [MessageBoxTableViewCell heightOf:[kv description]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBoxTableViewCell *cell = (MessageBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell)
    {
        cell = [[MessageBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AlertListItem *kv = _data[indexPath.row];
    [cell config:kv];
    return cell;
}



// 根据歌曲列表进行界面展现，主要是tabView的初始化操作
- (void)refreshAfterLoadMore
{
    [self stopLoadMore];
    [_tableView reloadData];
    
    [self resetMoreView];
}

- (void)reloadData
{
    if (_reloading)
    {
        [self stopLoadMore];
    }
}

- (void)onLoadOver
{
    _refreshHeaderView.isLoadOver = YES;
}

- (void)stopLoadMore
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}


#pragma mark -
#pragma mark UITableViewDelegate

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView.hidden) {
        _refreshHeaderView.hidden = YES;
    }
    if (scrollView.contentOffset.y > 0)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > 0)
    {
        if (!_refreshHeaderView.isLoadOver)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)loadMore
{
    // 加载更多逻辑
    [self configOwnViews];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    // 在此回调函数中进行数据的获取, 然后数据获取完毕后在通知刷新页面
    // 回调外界进行界面的刷新
    [self loadMore];
    _reloading = YES;
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

@end
