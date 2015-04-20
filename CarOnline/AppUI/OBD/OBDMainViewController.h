//
//  OBDMainViewController.h
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface OBDMainViewController : BaseViewController<CarStatusFloatViewDelegate>
{
    UIView  *_titleBg;
    UILabel *_titleView;
    
    CarStatusFloatView *_floatView;
    
    NSMutableArray *_OBDItems;
    
    UIScrollView *_scrollView;
    
    NSMutableArray *_OBDButtons;

    OBDFloatPanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@property (nonatomic, strong) NSDictionary *obdKeyValue;

@end
