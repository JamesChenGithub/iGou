//
//  GeoMapBaseViewController.h
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GMapBaseViewController.h"

@class VehicleGPSListItem;

@interface GoogleMapBaseViewController : BaseViewController<GMSMapViewDelegate>
{
@protected
    GMSMapView *_mapView;
}

// 放大
- (void)zoomIn;
// 缩小
- (void)zoomOut;

- (void)setCenter:(VehicleGPSListItem *)item;

- (void)setCenterOf:(CLLocationCoordinate2D)item;

- (void)setCenterOf:(CLLocationCoordinate2D)item zoom:(CGFloat)zoom;

@end
