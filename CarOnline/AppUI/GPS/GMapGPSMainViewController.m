//
//  GMapGPSMainViewController.m
//  CarOnline
//
//  Created by James on 14-11-24.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GMapGPSMainViewController.h"

@interface GMapGPSMainViewController ()

@property (nonatomic, strong) NSArray *vehicleGPSList;

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *linesGPSItem;

@property (nonatomic, assign) BOOL isSettingCenter;

@end

@implementation GMapGPSMainViewController



//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}


- (void)notifyFloatViewRequest
{
    _hadGetDevList = YES;
    
//    [_floatView startRequest:YES];
    
    [_floatPanel startRequest];
    
}

- (void)onTrackChanged
{
#if kSupportMap
    dispatch_async(dispatch_get_main_queue(), ^{
        // 跟踪状态改变回调
        if (_calloutAnnotation)
        {
            [_mapView removeAnnotation:_calloutAnnotation];
        }
        [_mapView removeAnnotations:_vehicleGPSList];
        _vehicleGPSList = nil;
        
        [_mapView removeOverlays:_lines];
        if ([WebServiceEngine sharedEngine].isTracking)
        {
            // isTracking from NO  to YES 或换车进行跟踪的时候
            // 重置相关的内容
            [_lines removeAllObjects];
            [_linesGPSItem removeAllObjects];
            _lines = [NSMutableArray array];
            _linesGPSItem = [NSMutableArray array];
        }
        else
        {
            // isTracking from NO  to YES
            [_lines removeAllObjects];
            [_linesGPSItem removeAllObjects];
            _lines = nil;
            _linesGPSItem = nil;
        }
    });
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTrackChanged) name:kTrackChangedNotify object:nil];
    
    //    UIButton *button = [UIButton buttonWithTip:@"/"];
    //    UIImage *norImag = [UIImage imageNamed:@"VRM_i04_011_ButtonCircle.png"];
    //    [button setBackgroundImage:norImag forState:UIControlStateNormal];
    //    [button setBackgroundImage:[UIImage imageNamed:@"VRM_i04_011_ButtonCirclePressed.png"] forState:UIControlStateHighlighted];
    //    [button sizeWith:CGSizeMake(37, 37)];
    //    [button addTarget:self action:@selector(toAppInfo) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:button];
    ////    bar.target = self;
    ////    bar.action = @selector(toAppInfo);
    //    self.navigationItem.rightBarButtonItem = bar;
    
    __weak typeof(self) weakSelf = self;
    
    GetDevList *getDevList = [[GetDevList alloc] initWithHandler:^(BaseRequest *request) {
        
        GetDevListResponseBody *body = (GetDevListResponseBody *)request.response.Body;
        
        [[WebServiceEngine sharedEngine] setVehicleFrom:body];
        
        [weakSelf notifyFloatViewRequest];
        
    }];
    
    [[WebServiceEngine sharedEngine] asyncRequest:getDevList];
    
    //    [self performSelector:@selector(startLocation) withObject:nil afterDelay:0.3];
#if kSupportMap
    
    [self startLocation];
#else
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlank:)];
    [self.view addGestureRecognizer:tap];
#endif
}

- (void)onTapBlank:(UITapGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        [_floatPanel show];
    }
}

#if kSupportMap
- (void)startLocation
{
    //    [_locService startUserLocationService];
    //    _mapView.userTrackingMode = MKUserTrackingModeNone;//设置定位的状态
    
}
#endif

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    //#if kSupportMap
    //    // 设置国图相关的回高
    //    [_mapView viewWillAppear];
    //    _mapView.delegate = self; // 不用时，置nil
    //    _locService.delegate = self;
    //#endif
    
    
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    
    if (we.vehicle)
    {
        _floatView.vehicle = we.vehicle;
    }
    
#if kSupportMap
    
    if (![we isMuiltMonitor])
    {
        if (we.vehicle)
        {
            [_mapView removeAnnotations:self.vehicleGPSList];
            self.vehicleGPSList = @[we.vehicle];
            [_mapView addAnnotations:self.vehicleGPSList];
        }
    }
    
    if (![we isTracking])
    {
        [_mapView removeOverlays:_lines];
        _lines = nil;
    }
    else
    {
        [_mapView setNeedsDisplay];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
#endif
    
    //    [self requestOnViewWillAppear];
    [self performSelector:@selector(requestOnViewWillAppear) withObject:nil afterDelay:0.5];
}

- (void)reloadMapView
{
    
}

- (void)requestOnViewWillAppear
{
    // 显示界面时，重新请求相关的数据
    if (_hadGetDevList)
    {
        [_floatView resetAndStartRequest];
        [_floatPanel show];
        [_floatPanel startRequest];
    }
    else
    {
        [_floatView startRequest:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 界面不显示时，地图暂不响应，并停止该界面的请求
    //#if kSupportMap
    //    [_mapView viewWillDisappear];
    //
    //    _mapView.delegate = nil; // 不用时，置nil
    //    _locService.delegate = nil;
    //
    //#endif
    
    if (![WebServiceEngine sharedEngine].isTracking)
    {
        [_floatView stopRequest];
        [_floatPanel stopRequest];
    }
}

//- (void)toAppInfo
//{
//    AppInfoViewController *app = [NSObject loadClass:[AppInfoViewController class]];
//    [[AppDelegate sharedAppDelegate] pushViewController:app];
//}

- (void)onGetAddress:(VehicleGPSListItem *)gps
{
    // 解析车所在的地址信息
    [self getVehicleAddress:[gps coordinate]];
}

- (void)resetSettingCenter
{
    _isSettingCenter = NO;
}

- (void)adjustCenter
{
#if kSupportMap
    // 调整地图和中心位置，以当前选中的为中心
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    if (we.vehicle && we.vehicle.Latidude != 0 && we.vehicle.Longitude != 0)
    {
        _isSettingCenter = YES;
        [_mapView setCenterCoordinate:[we.vehicle coordinate] animated:YES];
        
        [self performSelector:@selector(resetSettingCenter) withObject:nil afterDelay:0.5];
    }
#endif
}


- (void)onGetVehicleGPSList:(NSArray *)list
{
#if kSupportMap
    
    
    
    // 刷新地图上的数据
    if (list.count)
    {
        if (!_hadGetGPSList)
        {
            _hadGetGPSList = YES;
        }
        
        if (_calloutAnnotation)
        {
            [_mapView removeAnnotation:_calloutAnnotation];
        }
        
        if (_vehicleGPSList)
        {
            [_mapView removeAnnotations:_vehicleGPSList];
        }
        self.vehicleGPSList = list;
        [self adjustCenter];
        [_mapView addAnnotations:_vehicleGPSList];
        
        // 在跟踪的时候，还要在地图上划线
        if ([WebServiceEngine sharedEngine].isTracking)
        {
            [_linesGPSItem addObjectsFromArray:list];
            
            if (_linesGPSItem.count >= 2)
            {
                VehicleGPSListItem *start = [_linesGPSItem objectAtIndex:_linesGPSItem.count - 2];
                VehicleGPSListItem *end = _linesGPSItem.lastObject;
                
                if (start.Latidude == end.Latidude && start.Longitude == end.Longitude)
                {
                    [_linesGPSItem removeLastObject];
                    return;
                }
                else
                {
                    CLLocationCoordinate2D line[2] = {[start coordinate], [end coordinate]};
                    
                    MKPolyline *pLine = [MKPolyline polylineWithCoordinates:line count:2];
                    [_mapView addOverlay:pLine];
                    [_lines addObject:pLine];
                }
                
                
            }
            
        }
    }
    
#endif
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (void)addOwnViews
{
    
    
    // 向界面上添加相关的数据
#if kSupportMap
    //    _locService = [[BMKLocationService alloc]init];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //    _mapView.showsUserLocation = YES;
    //    _mapView.showMapScaleBar = YES;
    _mapView.delegate = self;
    _mapView.zoomLevel = 16;
    
    NSNumber *latNum = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:kLastUserLocationLatitude];
    NSNumber *longNum = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:kLastUserLocationLongitude];
    
    if (latNum && longNum)
    {
        double latitude = latNum.doubleValue;
        double longitude = longNum.doubleValue;
        
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
        //        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(loc, BMKCoordinateSpanMake(0.2,0.2));
        //        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        //        [_mapView setRegion:adjustedRegion animated:YES];
        [_mapView setCenterCoordinate:loc animated:YES];
        
    }
    
    
    [self.view addSubview:_mapView];
#endif
    
    _titleBg = [[UIView alloc] init];
    //    _titleBg.backgroundColor = [RGB(20, 20, 20) colorWithAlphaComponent:0.3];
    [self.view addSubview:_titleBg];
    
    _titleView = [[UILabel alloc] init];
    _titleView.backgroundColor = [RGB(20, 20, 20) colorWithAlphaComponent:0.3];
    _titleView.textColor = kWhiteColor;
    _titleView.font = [UIFont systemFontOfSize:16];
    _titleView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleView];
    
    //    [_locService startUserLocationService];
    //    _mapView.showsUserLocation = YES;//先关闭显示的定位图层
    //    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    //    _mapView.showsUserLocation = YES;//显示定位图层
    
    // TODO: add Map View
    _floatView = [[CarStatusFloatView alloc] init];
    _floatView.delegate = self;
    [self.view addSubview:_floatView];
    
    
    _floatPanel = [[GPSMainFloatPanel alloc] init];
    _floatPanel.delegate = self;
    [self.view addSubview:_floatPanel];
    [_floatPanel show];
}

- (void)toCarManage
{
    // 跳转到车辆管理
    CarListViewController *car = [NSObject loadClass:[CarListViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:car];
}


- (void)toOBD
{
    // 跳转到OBD
    OBDMainViewController *obd = [NSObject loadClass:[OBDMainViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:obd];
}

- (void)toMessage
{
    // 跳转到警告信息
    MessageBoxViewController *msg = [NSObject loadClass:[MessageBoxViewController class]];
    [[AppDelegate sharedAppDelegate] pushViewController:msg];
}

- (void)toZoomAddMap
{
    // 地图放大
#if kSupportMap
    [self zoomIn];
#else
    CarInfoViewController *info = [NSObject loadClass:[CarInfoViewController class]];
    info.vehicle = [WebServiceEngine sharedEngine].vehicle;
    [[AppDelegate sharedAppDelegate] pushViewController:info];
#endif
}

- (void)toZoomDecMap
{
    // 地图缩小
#if kSupportMap
    [self zoomOut];
#else
    CarInfoViewController *info = [NSObject loadClass:[CarInfoViewController class]];
    info.vehicle = [WebServiceEngine sharedEngine].vehicle;
    [[AppDelegate sharedAppDelegate] pushViewController:info];
#endif
}

#define kRightMargin 15
#define kVerPadding 15

- (void)layoutOnIPhone
{
    // 对界面的控件进行布局
    CGRect rect = self.view.bounds;
    
#if kSupportMap
    _mapView.frame = rect;
    //    _mapView.mapScaleBarPosition = CGPointMake(10, _mapView.bounds.size.height - 50);
    
#endif
    
    if ([IOSDeviceConfig sharedConfig].isIOS6Later)
    {
        [_titleBg sizeWith:CGSizeMake(rect.size.width, 64)];
#if kSupportMap
        _mapView.frame = CGRectMake(0, 20, rect.size.width, rect.size.height - 20);
        //        _mapView.mapScaleBarPosition = CGPointMake(10, _mapView.bounds.size.height - 50);
#endif
    }
    else
    {
        [_titleBg sizeWith:CGSizeMake(rect.size.width, 44)];
#if kSupportMap
        _mapView.frame = rect;
        //        _mapView.mapScaleBarPosition = CGPointMake(10, _mapView.bounds.size.height - 50);
#endif
    }
    
    [_titleView sizeWith:CGSizeMake(rect.size.width, 44)];
    [_titleView alignBottom:_titleBg];
    
    [_floatView sizeWith:CGSizeMake(rect.size.width, kCarStatusFloatViewHeight)];
    [_floatView layoutBelow:_titleView];
    [_floatView relayoutFrameOfSubViews];
    
    [_floatPanel sizeWith:CGSizeMake(40 + 2*kRightMargin, 37 * 5 + kVerPadding*3 + 1)];
    [_floatPanel layoutBelow:_floatView margin:15];
    [_floatPanel alignParentRightWithMargin:0];
    [_floatPanel relayoutFrameOfSubViews];
    
    
#if kSupportMap
    //    if ([IOSDeviceConfig sharedConfig].isIOS6Later)
    //    {
    //        _mapView.compassPosition = CGPointMake(10, 80);
    //    }
    //    else
    //    {
    //        _mapView.compassPosition = CGPointMake(10, 60);
    //    }
#endif
}

/////////////////////////////////////////////////////
// 地图相关回调
#if kSupportMap

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

//- (void)getVehicleAddress:(CLLocationCoordinate2D)loc
//{
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//	if (_coordinateXText.text != nil && _coordinateYText.text != nil) {
//		pt = (CLLocationCoordinate2D){[_coordinateYText.text floatValue], [_coordinateXText.text floatValue]};
//	}
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = loc;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
////    [reverseGeocodeSearchOption release];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
//}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    [_mapView updateLocationData:userLocation];
    
    if (!_hadGetGPSList)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            MKCoordinateRegion region;
            region.center.latitude  = userLocation.location.coordinate.latitude;
            region.center.longitude = userLocation.location.coordinate.longitude;
            region.span.latitudeDelta  = 0.2;
            region.span.longitudeDelta = 0.2;
            if (_mapView)
            {
                _mapView.region = region;
                NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
            }
            
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[NSNumber numberWithFloat:userLocation.location.coordinate.latitude] forKey:kLastUserLocationLatitude];
            [ud setObject:[NSNumber numberWithFloat:userLocation.location.coordinate.longitude] forKey:kLastUserLocationLongitude];
            
            NSLog(@"heading is %@",userLocation.heading);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [_mapView updateLocationData:userLocation];
                [_mapView setCenterCoordinate:[userLocation.location coordinate] animated:YES];
            });
        });
    }
    
    //    [self getVehicleAddress:userLocation.location.coordinate];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
//- (void)mapView:(MKMapView *)mapView onClickedMapPoi:(KMapPoi*)mapPoi
//{
//    [_floatPanel show];
//}

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
//- (void)mapView:(MKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
//{
//    [_floatPanel show];
//}


/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
//- (void)mapview:(MKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
//{
//    [_floatPanel show];
//}


/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
//- (void)mapview:(MKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
//{
//    [_floatPanel show];
//}


#define kVehicleAnnotationViewIndentifier @"VehicleAnnotationViewIndentifier"
#define kVehiclePaoPaoViewIndentifier @"VehiclePaoPaoViewIndentifier"
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    VehicleGPSListItem *item = (VehicleGPSListItem *)view.annotation;
    if (![we isMuiltMonitor])
    {
        [we setVehicle:item];
    }
    else
    {
        [we setVehicleOnMuiltMonitor:item];
    }
    [_floatView setGPSListItem:item];
    [_floatView setVehicle:item];
    [_floatPanel show];
    
    
    if ([item isKindOfClass:[VehicleGPSListItem class]])
    {
        VehicleGPSListPaopaoItem *paoitem = [VehicleGPSListPaopaoItem copy:item];
        _calloutAnnotation = paoitem;
        [_mapView addAnnotation:paoitem];
    }
}

- (void)mapView:(MKMapView *)amapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation)
    {
        [_mapView removeAnnotation:_calloutAnnotation];
        _calloutAnnotation = nil;
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)aAnnotation
{
    DebugLog(@"-------------->>>>mapView.annotation.count = %ld", (long)mapView.annotations.count);
    if ([aAnnotation isKindOfClass:[VehicleGPSListPaopaoItem class]])
    {
        GVehiclePaopaoView *vav = (GVehiclePaopaoView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kVehiclePaoPaoViewIndentifier];
        VehicleGPSListPaopaoItem *annotation = (VehicleGPSListPaopaoItem *)aAnnotation;
        if (vav == nil)
        {
            vav = [[GVehiclePaopaoView alloc] initWithAnnotation:annotation reuseIdentifier:kVehiclePaoPaoViewIndentifier];
            vav.canShowCallout = NO;
        }
        
        [vav setGPSVehicle:annotation];
        
        __weak VehiclePaopaoView *wpv = vav.paopaoView;
        [self asyncGetAddress:[annotation coordinate] addressCompletion:^(NSDictionary *address) {
            if (address)
            {
                NSDictionary *comp = address[@"addressComponent"];
                wpv.address.text = [NSString stringWithFormat:@"%@%@%@", comp[@"city"], comp[@"district"], comp[@"street"]];
            }
        }];
        
        return vav;
    }
    else if ([aAnnotation isKindOfClass:[VehicleGPSListItem class]])
    {
        MKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleAnnotationViewIndentifier];
        VehicleGPSListItem *annotation = (VehicleGPSListItem *)aAnnotation;
        
        if (vav == nil)
        {
            vav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleAnnotationViewIndentifier];
            vav.canShowCallout = NO;
        }
        
        // 向地图上添加相关的注释
        
        vav.annotation = annotation;
        
        VehiclePinView *view = [[VehiclePinView alloc] initWithVehicle:annotation];
        NSInteger count = _lines.count;
        
        if ([WebServiceEngine sharedEngine].isTracking)
        {
            if (count > 0)
            {
                if (count == 1)
                {
                    [view setGPSVehicle:annotation];
                }
                else
                {
                    CLLocationCoordinate2D from = [_lines[count - 2] coordinate];
                    CLLocationCoordinate2D to = [annotation coordinate];
                    [view setGPSVehicle:annotation fromPosition:from toPosition:to];
                }
            }
        }
        else
        {
            [view setGPSVehicle:annotation];
        }
        
        vav.image = [view captureImage];
        return vav;
        
    }
    return nil;
    
    
}


- (void)mapView:(MKMapView *)mapView annotationViewForBubble:(MKAnnotationView *)view
{
    DebugLog(@"asdasdfsdf");
}



- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!_isSettingCenter)
    {
        [_floatPanel show];
    }
}

//根据overlay生成对应的View
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    // 画线
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        MKPolylineView* polylineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 4.0;
        return polylineView;
    }
    return nil;
}

#endif


@end
