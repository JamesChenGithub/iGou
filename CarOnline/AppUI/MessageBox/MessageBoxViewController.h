//
//  MessageBoxViewController.h
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageBoxViewController : KeyValueTableViewController<EGORefreshTableHeaderDelegate>
{
@protected
    EGORefreshTableHeaderView       *_refreshHeaderView;        // 提示刷新的视图
    BOOL                            _reloading;
    NSInteger _startIndex;
    
    BOOL                            _hasRecodeStarID;
}

@property (nonatomic, copy) NSString *vehicleNumbers;

@end
