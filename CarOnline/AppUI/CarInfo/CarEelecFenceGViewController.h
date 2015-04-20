//
//  CarEelecFenceGViewController.h
//  CarOnline
//
//  Created by James on 14-11-17.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//
#if kSupportGMap
#import "BaseViewController.h"

@interface CarEelecFenceGViewController : GMapBaseViewController<CarStatusFloatViewDelegate, CarFencePanelDelegate>
{

    CarStatusFloatView *_floatView;
    
    CarFencePanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@end
#endif