//
//  GPSGoogleMapMainViewController.h
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GoogleMapBaseViewController.h"

@interface GPSGoogleMapMainViewController : GoogleMapBaseViewController<CarStatusFloatViewDelegate, GPSMainFloatPanelDelegate>
{
    UIView  *_titleBg;
    UILabel *_titleView;
    
    CarStatusFloatView *_floatView;
    
    GPSMainFloatPanel *_floatPanel;
    
    BOOL _hadGetDevList;
    BOOL _hadGetGPSList;
    
    GMSMarker *_calloutAnnotation;
    
    BOOL _hadSetCenter;
}

- (void)requestOnViewWillAppear;

@end
