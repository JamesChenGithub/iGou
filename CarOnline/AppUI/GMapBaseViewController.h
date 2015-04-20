//
//  GMapBaseViewController.h
//  CarOnline
//
//  Created by James on 14-11-17.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface GMapBaseViewController : BaseViewController<MKMapViewDelegate>
{
@protected
    MKMapView *_mapView;
    NSUInteger _zoomLevel;
    
    id<MKAnnotation> _calloutAnnotation;
}

@property (nonatomic, assign) NSUInteger zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel;

// 放大
- (void)zoomIn;
// 缩小
- (void)zoomOut;


@end
