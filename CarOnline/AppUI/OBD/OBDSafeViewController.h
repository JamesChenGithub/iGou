//
//  OBDSafeViewController.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"

@interface OBDSafeResultView : OBDResultBaseView<UITableViewDelegate, UITableViewDataSource>
{
@protected
    NSMutableArray *_data;
    UITableView *_tableView;
}
- (void)setSecurity:(BOOL)isSec SafeData:(NSArray *)data;
- (void)setLock:(BOOL)lock;

@end

@interface OBDSafeAnimationView : OBDAnimationBaseView
{
    UIImageView *_carView;
    UIImageView *_lockbgView;
    MenuButton *_lock;
    UIImage      *_normalCarImage;
}

- (void)setLock:(BOOL)lock;

- (void)setVibrate:(BOOL)vbr;

- (void)setLockAntion:(MenuAction)action;

@end



@interface OBDSafeViewController : OBDBaseViewController

@end
