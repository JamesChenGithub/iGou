//
//  GMapGPSMainViewController.h
//  CarOnline
//
//  Created by James on 14-11-24.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GMapBaseViewController.h"

@interface GMapGPSMainViewController : GMapBaseViewController<CarStatusFloatViewDelegate, GPSMainFloatPanelDelegate>
{
    UIView  *_titleBg;
    UILabel *_titleView;
    
    CarStatusFloatView *_floatView;
    
    GPSMainFloatPanel *_floatPanel;
    
    BOOL _hadGetDevList;
    BOOL _hadGetGPSList;
}

- (void)requestOnViewWillAppear;

@end
