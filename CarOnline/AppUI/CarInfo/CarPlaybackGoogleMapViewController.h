//
//  CarPlaybackGoogleMapViewController.h
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GoogleMapBaseViewController.h"

@interface CarPlaybackGoogleMapViewController : GoogleMapBaseViewController<CarPlaybackFloatPanelDelegate, CarStatusFloatViewDelegate>
{
    CarStatusFloatView *_floatView;
    
    CarPlaybackFloatPanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@property (nonatomic, copy) NSString *fromTime;
@property (nonatomic, copy) NSString *toTime;

@end
