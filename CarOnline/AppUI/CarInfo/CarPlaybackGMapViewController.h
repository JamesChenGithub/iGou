//
//  CarPlaybackGMapViewController.h
//  CarOnline
//
//  Created by James on 14-11-17.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#if kSupportGMap

#import "GMapBaseViewController.h"

@interface CarPlaybackGMapViewController : GMapBaseViewController<CarPlaybackFloatPanelDelegate, CarStatusFloatViewDelegate>
{
    CarStatusFloatView *_floatView;
    CarPlaybackFloatPanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@property (nonatomic, copy) NSString *fromTime;
@property (nonatomic, copy) NSString *toTime;

@end

#endif