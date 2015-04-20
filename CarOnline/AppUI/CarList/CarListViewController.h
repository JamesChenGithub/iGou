//
//  CarListViewController.h
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

//@interface CarListItem : NSObject
//
//@end
//
//@interface CarListSectionItem : NSObject
//{
//@protected
//    BOOL _isExpand;
//    NSString *_sectionName;
//    NSMutableArray *_list;
//}
//
//@property (nonatomic, assign) BOOL isExpand;
//@property (nonatomic, copy) NSString *sectionName;
//@property (nonatomic, strong) NSMutableArray *list;
//
//@end


@interface CarListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView    *_tableView;
    UIButton       *_multiMonitor;
    NSMutableArray *_carList;
}

@end
