//
//  CarEelecFenceGoogleMapViewController.h
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GoogleMapBaseViewController.h"

@interface CarEelecFenceGoogleMapViewController : GoogleMapBaseViewController<CarStatusFloatViewDelegate, CarFencePanelDelegate>
{
    CarStatusFloatView *_floatView;
    
    CarFencePanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@end
