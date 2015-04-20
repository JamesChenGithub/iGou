//
//  CarPlaybackGoogleMapViewController.m
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarPlaybackGoogleMapViewController.h"

@interface CarPlaybackGoogleMapViewController ()

@property (nonatomic, strong) GetOrbitDataResponseBody *orbitBody;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer *playBackTimer;

//@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) VehicleGPSListItem *lastAnnotation;

@property (nonatomic, strong) NSMutableArray *stoppedAnnotations;

@property (nonatomic, weak) GMSMarker *lastMarker;

@property (nonatomic, strong) GMSMutablePath *mutablePaths;
@property (nonatomic, strong) GMSPolyline *mutableLine;

@end

@implementation CarPlaybackGoogleMapViewController



- (NSInteger)showStopFrom:(VehicleGPSListItem *)lastlast to:(VehicleGPSListItem *)last
{
    if (!lastlast || !last) {
        return 0;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *from = [dateFormat dateFromString:lastlast.Date];
    NSDate *to = [dateFormat dateFromString:last.Date];
    
    NSInteger interval = [to timeIntervalSinceDate:from];
    
    return interval;
}

- (void)updatePolyline
{
#if kSupportMap
    if (_currentIndex >= self.orbitBody.VehicleGPSList.count)
    {
        // 播放完毕处理
        [_floatPanel setPlayOrPause:NO];
        [self toPausePlayback];
        
        
        AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kCarPlayback_Playover_Str];
        [alert addButtonWithTitle:kOK_Str];
        [PopupView alertInWindow:alert];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kCarPlayback_Playover_Str delegate:nil cancelButtonTitle:kOK_Str otherButtonTitles:nil, nil];
        //        [alert show];
        
        return;
    }
    
    
    VehicleGPSListItem *lastlast = nil;
    if (_currentIndex > 0)
    {
        // 移除上一次的位置
        lastlast = [self.orbitBody.VehicleGPSList objectAtIndex:_currentIndex - 1];
        _lastMarker.map = nil;
    }
    
    
    VehicleGPSListItem *last = [self.orbitBody.VehicleGPSList objectAtIndex:_currentIndex];
    
    if (_currentIndex == 0)
    {
        VehiclePlaybackItem *start = [VehiclePlaybackItem copy:last];
        start.isStart = YES;
        [start addToMapView:_mapView];
    }
    
    
    
    //    [_mapView addAnnotation:last];
    self.lastMarker = [last addToMapView:_mapView];
    
    NSInteger inte = [self showStopFrom:lastlast to:last];
    if (inte >= 300)
    {
        // add stop
        VehicleGPSListItem *stop = [lastlast copy];
        stop.stopDuration = [NSString stringWithFormat:@"%dh%d'", inte/3600, (inte%3600)/60];
        stop.isStaticAnnotaion = YES;
        [_stoppedAnnotations addObject:stop];
        //        [_mapView addAnnotation:stop];
        [stop addToMapView:_mapView];
        
    }
    
    
    self.lastAnnotation = last;
    
    [_floatView setGPSListItem:last];
    
    
    //    GMSCameraPosition *pos = [GMSCameraPosition alloc]
    //    [_mapView setCenterCoordinate:last.coordinate animated:YES];
    [self setCenter:last];
    
    if (_currentIndex >= 1)
    {
        // 添加路径线条
        VehicleGPSListItem *start = [self.orbitBody.VehicleGPSList objectAtIndex:_currentIndex - 1];
        VehicleGPSListItem *end = last;
        
        CLLocationCoordinate2D startPoint;
        startPoint.latitude = start.Latidude;
        startPoint.longitude = start.Longitude;
        
        CLLocationCoordinate2D endPoint;
        endPoint.latitude = end.Latidude;
        endPoint.longitude = end.Longitude;
        
        //        NSString *startStr = NSStringFromCGPoint(CGPointMake(startPoint.latitude, startPoint.longitude));
        //        NSString *endStr = NSStringFromCGPoint(CGPointMake(endPoint.latitude, endPoint.longitude));
        
        DebugLog(@"=================\n 开始划线：From : (%f, %f) \n to : (%f, %f)", start.Latidude, start.Longitude, end.Latidude, end.Longitude);
        
        //        CLLocationCoordinate2D line[2] = {startPoint, endPoint};
        
        if (_mutablePaths)
        {
            [_mutablePaths addCoordinate:endPoint];
        }
        else
        {
            _mutablePaths = [GMSMutablePath path];
            [_mutablePaths addCoordinate:startPoint];
            [_mutablePaths addCoordinate:endPoint];
        }
        
        _mutableLine.map = nil;
        _mutableLine = [GMSPolyline polylineWithPath:_mutablePaths];
        _mutableLine.strokeColor = [UIColor redColor];
        _mutableLine.strokeWidth = 2;
        _mutableLine.map = _mapView;
//        [_lines addObject:pLine];
        
//        GMSMutablePath *path = [GMSMutablePath path];
//        [path addCoordinate:startPoint];
//        [path addCoordinate:endPoint];
//        
//        GMSPolyline *pLine = [GMSPolyline polylineWithPath:path];
//        pLine.strokeColor = [UIColor redColor];
//        pLine.strokeWidth = 2;
//        pLine.map = _mapView;
//        [_lines addObject:pLine];
    }
    _currentIndex++;
    
    if (_currentIndex >= self.orbitBody.VehicleGPSList.count)
    {
        VehiclePlaybackItem *start = [VehiclePlaybackItem copy:last];
        [start addToMapView:_mapView];
    }
#endif
    
}

- (void)toResumePlayback
{
#if kSupportMap
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // 恢复播放
    if (_currentIndex >= self.orbitBody.VehicleGPSList.count)
    {
        //        [_mapView removeOverlays:_lines];
        //        _lines = nil;
        //        [_mapView removeAnnotation:self.lastAnnotation];
        //        [_mapView removeAnnotations:self.stoppedAnnotations];
        [_mapView clear];
        self.stoppedAnnotations = nil;
//        [_lines removeAllObjects];
        _mutablePaths = nil;
        _currentIndex = 0;
    }
    
//    if (!_lines)
//    {
//        _lines = [NSMutableArray array];
//    }
    
    if (!_stoppedAnnotations)
    {
        _stoppedAnnotations = [NSMutableArray array];
    }
    
    _playBackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePolyline) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_playBackTimer forMode:NSRunLoopCommonModes];
#endif
}

- (void)toPausePlayback
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    // 暂停播放
    [_playBackTimer invalidate];
    _playBackTimer = nil;
}

- (void)onGetOrbitData:(GetOrbitDataResponseBody *)body
{
#if kSupportMap
    // 查询到记录处理
    self.orbitBody = body;
    
    if (body.VehicleGPSList.count)
    {
        [_mapView clear];
        [self toResumePlayback];
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:kCarPlayback_NoRecord_Str];
    }
#endif
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    GetOrbitData *gd = [[GetOrbitData alloc] initWithHandler:^(BaseRequest *request) {
        
        GetOrbitDataResponseBody *body = (GetOrbitDataResponseBody *)request.response.Body;
        [weakSelf onGetOrbitData:body];
        
    }];
    gd.StartOn = self.fromTime;
    gd.EndOn = self.toTime;
    
    [[WebServiceEngine sharedEngine] asyncRequest:gd];
    
    [_vehicle addToMapView:_mapView];
    
    
    
    [_floatView updateStatusText];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self toPausePlayback];
}

- (void)onGetAddress:(VehicleGPSListItem *)gps;
{
    [self getVehicleAddress:[gps coordinate]];
}

- (void)addOwnViews
{
    [super addOwnViews];
    
    _floatView = [[CarStatusFloatView alloc] initWithoutUpdate];
    _floatView.delegate = self;
    [_floatView startRequestOfVehicleNum:self.vehicle.VehicleNumber];
    _floatView.isInPlayback = YES;
    [self.view addSubview:_floatView];
    
    
    _floatPanel = [[CarPlaybackFloatPanel alloc] init];
    _floatPanel.delegate = self;
    [self.view addSubview:_floatPanel];
}

- (void)toZoomAddMap
{
    CLLocationCoordinate2D loc = _mapView.camera.target;
    [self setCenterOf:loc zoom:_mapView.camera.zoom + 1];
}


- (void)toZoomDecMap
{
    CLLocationCoordinate2D loc = _mapView.camera.target;
    [self setCenterOf:loc zoom:_mapView.camera.zoom - 1];
}

#define kRightMargin 15
#define kVerPadding 15

- (void)layoutOnIPhone
{
    [super layoutOnIPhone];
    
    CGRect rect = self.view.bounds;
    
    [_floatView sizeWith:CGSizeMake(rect.size.width, kCarStatusFloatViewHeight)];
    [_floatView relayoutFrameOfSubViews];
    
    [_floatPanel sizeWith:CGSizeMake(44, 37 * 5 + kVerPadding + 1)];
    [_floatPanel alignParentTopWithMargin:20];
    [_floatPanel alignParentRightWithMargin:kRightMargin];
    [_floatPanel relayoutFrameOfSubViews];
}


- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    VehicleGPSListItem *item = (VehicleGPSListItem *)marker.userData;
    if ([item isStaticAnnotaion])
    {
        return [[VehicleStopPaoView alloc] initWithVehicle:item];
    }
    return nil;
}

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker {
//    if (marker == _brisbaneMarker) {
//        return _contentView;
//    }
//    return nil;
//}


@end