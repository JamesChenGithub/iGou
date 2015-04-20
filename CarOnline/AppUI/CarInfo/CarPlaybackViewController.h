//
//  CarPlaybackViewController.h
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface CarPlaybackViewController : BaseViewController<CarPlaybackFloatPanelDelegate, CarStatusFloatViewDelegate
#if kSupportMap
, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate
#endif
>
{
#if kSupportMap
    BMKMapView *_mapView;
#endif
    
    CarStatusFloatView *_floatView;
    
    CarPlaybackFloatPanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@property (nonatomic, copy) NSString *fromTime;
@property (nonatomic, copy) NSString *toTime;

@end
