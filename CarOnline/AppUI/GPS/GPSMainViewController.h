//
//  GPSMainViewController.h
//  CarOnline
//
//  Created by James on 14-7-25.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"


@interface GPSMainViewController : BaseViewController<CarStatusFloatViewDelegate, GPSMainFloatPanelDelegate
#if kSupportMap
, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate
#endif
>
{
    UIView  *_titleBg;
    UILabel *_titleView;
    
#if kSupportMap
    BMKMapView *_mapView;
    
    BMKLocationService* _locService;

#endif
    
    CarStatusFloatView *_floatView;
    
    GPSMainFloatPanel *_floatPanel;
    
    BOOL _hadGetDevList;
    BOOL _hadGetGPSList;
}

- (void)requestOnViewWillAppear;

@end
