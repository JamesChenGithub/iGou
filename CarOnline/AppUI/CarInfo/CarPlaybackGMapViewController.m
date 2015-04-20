//
//  CarPlaybackGMapViewController.m
//  CarOnline
//
//  Created by James on 14-11-17.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#if kSupportGMap

#import "CarPlaybackGMapViewController.h"

@interface CarPlaybackGMapViewController ()

@property (nonatomic, strong) GetOrbitDataResponseBody *orbitBody;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer *playBackTimer;

@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) VehicleGPSListItem *lastAnnotation;

@property (nonatomic, strong) NSMutableArray *stoppedAnnotations;

@end

@implementation CarPlaybackGMapViewController



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
        [_mapView removeAnnotation:lastlast];
    }
    
    
    VehicleGPSListItem *last = [self.orbitBody.VehicleGPSList objectAtIndex:_currentIndex];
    
    
    //    if (_currentIndex == 0)
    //    {
    //        VehiclePlaybackItem *start = [VehiclePlaybackItem copy:last];
    //        start.isStart = YES;
    //        [_mapView addAnnotation:start];
    //    }
    
    
    [_mapView addAnnotation:last];
    
    NSInteger inte = [self showStopFrom:lastlast to:last];
    if (inte >= 300)
    {
        // add stop
        VehicleGPSListItem *stop = [lastlast copy];
        stop.stopDuration = [NSString stringWithFormat:@"%dh%d'", inte/3600, (inte%3600)/60];
        stop.isStaticAnnotaion = YES;
        [_stoppedAnnotations addObject:stop];
        [_mapView addAnnotation:stop];
    }
    
    
    self.lastAnnotation = last;
    
    [_floatView setGPSListItem:last];
    
    [_mapView setCenterCoordinate:last.coordinate animated:YES];
    
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
        
        CLLocationCoordinate2D line[2] = {startPoint, endPoint};
        
        MKPolyline *pLine = [MKPolyline polylineWithCoordinates:line count:2];
        [_mapView addOverlay:pLine];
        [_lines addObject:pLine];
    }
    _currentIndex++;
    
    if (_currentIndex >= self.orbitBody.VehicleGPSList.count)
    {
        VehiclePlaybackItem *end = [VehiclePlaybackItem copy:last];
        [_mapView addAnnotation:end];
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
        [_mapView removeOverlays:_lines];
        _lines = nil;
        [_mapView removeAnnotation:self.lastAnnotation];
        [_mapView removeAnnotations:self.stoppedAnnotations];
        self.stoppedAnnotations = nil;
        [_lines removeAllObjects];
        _currentIndex = 0;
    }
    
    if (!_lines)
    {
        _lines = [NSMutableArray array];
    }
    
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
        [_mapView removeAnnotation:_vehicle];
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
    
    [_mapView performSelector:@selector(addAnnotation:) withObject:_vehicle afterDelay:0.5];
    
    
    
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
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(_vehicle.Latidude, _vehicle.Longitude);
    [self setCenterCoordinate:loc zoomLevel:16 animated:YES];
    
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
    self.zoomLevel++;
}

- (void)toZoomDecMap
{
    self.zoomLevel--;
}

//- (void)onSetFenceSucc:(BaseResponse *)resp
//{
//    _floatPanel.fence.selected = !_floatPanel.fence.selected;
//}
//
//- (void)setElectronicFence:(BOOL)enable
//{
//    __weak typeof(self) weakSelf = self;
//
//
//    SetElectronicFence *sf = [[SetElectronicFence alloc] initWithHandler:^(BaseRequest *request) {
//        [[HUDHelper sharedInstance] tipMessage:[request.response message]];
//        [weakSelf onSetFenceSucc:request.response];
//    }];
//    sf.IsEnable = enable;
//    sf.Latidude = self.fenceBody.Lat;
//    sf.Longitude = self.fenceBody.Lng;
//    sf.Enclosure = self.fenceBody.Enclosure;
//    [[WebServiceEngine sharedEngine] asyncRequest:sf];
//}

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

#if kSupportMap


#define kVehicleAnnotationViewIndentifier @"VehicleAnnotationViewIndentifier"
#define kVehicleGPSListPlaybackAnnotationViewIndentifier @"VehicleGPSListPlaybackAnnotationViewIndentifier"

#define kVehicleGPSListPlaybackStartStopAnnotationViewIndentifier @"VehicleGPSListPlaybackStartStopAnnotationViewIndentifier"

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)aAnnotation
{
    if ([aAnnotation isKindOfClass:[VehicleGPSListPaopaoItem class]])
    {
        //            VehicleStopPaoView *pv = [[VehicleStopPaoView alloc] initWithVehicle:annotation];
        //            vav.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:pv];
        //                vav.
        //            VehicleGPSListPaopaoItem *ani = [];
        
        MKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleGPSListPlaybackAnnotationViewIndentifier];
        VehicleGPSListPaopaoItem *annotation = (VehicleGPSListPaopaoItem *)aAnnotation;
        
        if (vav == nil)
        {
            vav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleGPSListPlaybackAnnotationViewIndentifier];
            vav.canShowCallout = NO;
        }
        
        VehicleStopPaoView *pv = [[VehicleStopPaoView alloc] initWithVehicle:annotation];
        vav.image = [pv captureImage];
        return vav;
    }
    else if ([aAnnotation isKindOfClass:[VehiclePlaybackItem class]])
    {
        
        MKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleGPSListPlaybackStartStopAnnotationViewIndentifier];
        VehiclePlaybackItem *annotation = (VehiclePlaybackItem *)aAnnotation;
        
        if (vav == nil)
        {
            vav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleGPSListPlaybackStartStopAnnotationViewIndentifier];
            vav.canShowCallout = NO;
        }
        
        vav.image = annotation.isStart ? [UIImage imageNamed:@"VRM_i06_010_StartFlag.png"] : [UIImage imageNamed:@"VRM_i06_011_StopFlag.png"];
        return vav;
    }
    
    else
    {
        MKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleAnnotationViewIndentifier];
        VehicleGPSListItem *annotation = (VehicleGPSListItem *)aAnnotation;
        
        if (vav == nil)
        {
            vav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleAnnotationViewIndentifier];
            vav.canShowCallout = NO;
        }
        
        
        VehiclePinView *view = [[VehiclePinView alloc] initWithVehicle:annotation];
        
        NSArray *array = self.orbitBody.VehicleGPSList;
        NSInteger count = array.count;
        if (count > 0)
        {
            if (count == 1)
            {
                [view setGPSVehicle:annotation];
            }
            else
            {
                CLLocationCoordinate2D from = [array[count - 2] coordinate];
                CLLocationCoordinate2D to = [annotation coordinate];
                [view setGPSVehicle:annotation fromPosition:from toPosition:to];
            }
            
        }
        
        vav.image = [view captureImage];
        
        if (annotation.isStaticAnnotaion)
        {
            //        VehicleStopPaoView *pv = [[VehicleStopPaoView alloc] initWithVehicle:annotation];
            //        vav.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:pv];
            vav.canShowCallout = YES;
        }
        return vav;
        
    }
    
    
}

- (void)mapView:(MKMapView *)amapView didSelectAnnotationView:(MKAnnotationView *)view
{
	if ([view.annotation isKindOfClass:[VehicleGPSListItem class]])
    {
        VehicleGPSListItem *annotation = (VehicleGPSListItem *)view.annotation;
        
        if (annotation.isStaticAnnotaion)
        {
            [_mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = [VehicleGPSListPaopaoItem copy:annotation];
            [_mapView addAnnotation:_calloutAnnotation];
        }
	}
}

static NSInteger kCount = 0;

//根据overlay生成对应的View
- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    DebugLog(@"lines = %d,  kCount = %d", _lines.count, kCount);
	if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView* polylineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 4.0;
		return polylineView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)amapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation)
    {
        [_mapView removeAnnotation:_calloutAnnotation];
        _calloutAnnotation = nil;
        
    }
}


#endif

@end

#endif