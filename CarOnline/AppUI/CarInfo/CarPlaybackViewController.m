//
//  CarPlaybackViewController.m
//  CarOnline
//
//  Created by James on 14-8-28.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarPlaybackViewController.h"

@interface CarPlaybackViewController ()

@property (nonatomic, strong) GetOrbitDataResponseBody *orbitBody;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer *playBackTimer;

@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) VehicleGPSListItem *lastAnnotation;

@property (nonatomic, strong) NSMutableArray *stoppedAnnotations;

@end





@interface CarPlaybackAnnotion : VehicleGPSListItem

@end

@implementation CarPlaybackViewController



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
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kCarPlayback_Playover_Str delegate:nil cancelButtonTitle:kOK_Str otherButtonTitles:nil, nil];
//        [alert show];
        
        AlertPopup *alert = [[AlertPopup alloc] initWithTitle:nil message:kCarPlayback_Playover_Str];
        [alert addButtonWithTitle:kOK_Str];
        [PopupView alertInWindow:alert];
        
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
    
    
    if (_currentIndex == 0)
    {
        VehiclePlaybackItem *start = [VehiclePlaybackItem copy:last];
        start.isStart = YES;
        [_mapView addAnnotation:start];
    }
    
    
    
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
        
        BMKPolyline *pLine = [BMKPolyline polylineWithCoordinates:line count:2];
        [_mapView addOverlay:pLine];
        [_lines addObject:pLine];
    }
    _currentIndex++;
    
    if (_currentIndex >= self.orbitBody.VehicleGPSList.count)
    {
        VehiclePlaybackItem *end = [VehiclePlaybackItem copy:last];
        end.isStart = NO;
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
    
#if kSupportMap
    [_mapView performSelector:@selector(addAnnotation:) withObject:_vehicle afterDelay:0.5];
    _mapView.zoomLevel = _mapView.maxZoomLevel;
#endif
    
    [_floatView updateStatusText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if kSupportMap
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 不用时，置nil
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
#if kSupportMap
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
#endif
    
    [self toPausePlayback];
}

- (void)onGetAddress:(VehicleGPSListItem *)gps;
{
    [self getVehicleAddress:[gps coordinate]];
}

- (void)addOwnViews
{
#if kSupportMap
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showMapScaleBar = YES;
    _mapView.zoomLevel = 16;
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(_vehicle.Latidude, _vehicle.Longitude);
    //    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(loc, BMKCoordinateSpanMake(0.2,0.2));
    //    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    //    [_mapView setRegion:adjustedRegion animated:YES];
    [_mapView setCenterCoordinate:loc animated:YES];
    
    [self.view addSubview:_mapView];
#endif
    
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
#if kSupportMap
    [_mapView zoomIn];
#endif
}

- (void)toZoomDecMap
{
#if kSupportMap
    [_mapView zoomOut];
#endif
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
    CGRect rect = self.view.bounds;
    
#if kSupportMap
    _mapView.frame = rect;
    _mapView.mapScaleBarPosition = CGPointMake(10, _mapView.bounds.size.height - 50);
#endif
    
    [_floatView sizeWith:CGSizeMake(rect.size.width, kCarStatusFloatViewHeight)];
    [_floatView relayoutFrameOfSubViews];
    
    [_floatPanel sizeWith:CGSizeMake(44, 37 * 5 + kVerPadding + 1)];
    [_floatPanel alignParentTopWithMargin:20];
    [_floatPanel alignParentRightWithMargin:kRightMargin];
    [_floatPanel relayoutFrameOfSubViews];
}

#if kSupportMap


#define kVehicleAnnotationViewIndentifier @"VehicleAnnotationViewIndentifier"
#define kVehicleAnnotationViewPlaybackIndentifier @"VehicleAnnotationViewPlaybackIndentifier"

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)aAnnotation
{
    if ([aAnnotation isKindOfClass:[VehiclePlaybackItem class]])
    {
        BMKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleAnnotationViewPlaybackIndentifier];
        VehiclePlaybackItem *annotation = (VehiclePlaybackItem *)aAnnotation;
        
        if (vav == nil)
        {
            vav = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleAnnotationViewPlaybackIndentifier];
            vav.canShowCallout = NO;
        }
        
        
        vav.image = annotation.isStart ? [UIImage imageNamed:@"VRM_i06_010_StartFlag.png"] : [UIImage imageNamed:@"VRM_i06_011_StopFlag.png"];
        
        return vav;
    }
    else
    {
        BMKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleAnnotationViewIndentifier];
        VehicleGPSListItem *annotation = (VehicleGPSListItem *)aAnnotation;
        
        if (vav == nil)
        {
            vav = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleAnnotationViewIndentifier];
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
            VehicleStopPaoView *pv = [[VehicleStopPaoView alloc] initWithVehicle:annotation];
            vav.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:pv];
            vav.canShowCallout = YES;
        }
        return vav;
    }
}

static NSInteger kCount = 0;

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    DebugLog(@"lines = %d,  kCount = %d", _lines.count, kCount);
	if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 4.0;
		return polylineView;
    }
    return nil;
}


#endif

@end
