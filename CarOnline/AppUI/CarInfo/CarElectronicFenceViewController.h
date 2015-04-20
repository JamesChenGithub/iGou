//
//  CarElectronicFenceViewController.h
//  CarOnline
//
//  Created by James on 14-8-27.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface CarElectronicFenceViewController : BaseViewController<CarStatusFloatViewDelegate, CarFencePanelDelegate
#if kSupportMap
, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate
#endif
>
{
#if kSupportMap
    BMKMapView *_mapView;    
#endif
    
    CarStatusFloatView *_floatView;
    
    CarFencePanel *_floatPanel;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@end
