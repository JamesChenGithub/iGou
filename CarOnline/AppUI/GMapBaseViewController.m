//
//  GMapBaseViewController.m
//  CarOnline
//
//  Created by James on 14-11-17.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GMapBaseViewController.h"

@interface GMapBaseViewController ()



@end

@implementation GMapBaseViewController


- (NSUInteger)zoomLevel
{
    if (_zoomLevel < kMKMapViewMinZoomLevel)
    {
        _zoomLevel = kMKMapViewMinZoomLevel;
    }
    else if (_zoomLevel > kMKMapViewMaxZoomLevel)
    {
        _zoomLevel = kMKMapViewMaxZoomLevel;
    }
    return _zoomLevel;
}

- (void)setZoomLevel:(NSUInteger)zoomLevel
{
    if (zoomLevel < kMKMapViewMinZoomLevel)
    {
        zoomLevel = kMKMapViewMinZoomLevel;
    }
    else if (zoomLevel > kMKMapViewMaxZoomLevel)
    {
        zoomLevel = kMKMapViewMaxZoomLevel;
    }
    
    _zoomLevel = zoomLevel;
    [_mapView setZoomLevel:_zoomLevel];
}


- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated
{
    if (zoomLevel < kMKMapViewMinZoomLevel)
    {
        zoomLevel = kMKMapViewMinZoomLevel;
    }
    else if (zoomLevel > kMKMapViewMaxZoomLevel)
    {
        zoomLevel = kMKMapViewMaxZoomLevel;
    }
    
    _zoomLevel = zoomLevel;
    [_mapView setCenterCoordinate:centerCoordinate zoomLevel:zoomLevel animated:animated];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel
{
    [self setCenterCoordinate:centerCoordinate zoomLevel:zoomLevel animated:YES];
}

- (void)addOwnViews
{
    [super addOwnViews];
    _mapView = [[MKMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;
    [self.view addSubview:_mapView];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    _mapView.delegate = self;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    _mapView.delegate = nil;
//}

- (void)layoutOnIPhone
{
    _mapView.frame = self.view.bounds;
}

- (void)zoomIn
{
    self.zoomLevel++;
}


- (void)zoomOut
{
    self.zoomLevel--;
}


@end
