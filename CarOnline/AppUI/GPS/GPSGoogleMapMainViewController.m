//
//  GPSGoogleMapMainViewController.m
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GPSGoogleMapMainViewController.h"

@interface GPSGoogleMapMainViewController ()

@property (nonatomic, strong) NSArray *vehicleGPSList;

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *linesGPSItem;

@property (nonatomic, assign) BOOL isSettingCenter;


@property (nonatomic, strong) VehiclePaopaoView *selectPaopaoView;

@end

@implementation GPSGoogleMapMainViewController



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
            _calloutAnnotation.map = nil;
            _calloutAnnotation = nil;
        }
        [self removeVehicleGPSListAnnotations];
        _vehicleGPSList = nil;
        
        //        [_mapView removeOverlays:_lines];
        [self removeLinesOverlay];
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
    
    self.selectPaopaoView = [[VehiclePaopaoView alloc] init];
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
            //            [_mapView removeAnnotations:self.vehicleGPSList];
            [self removeVehicleGPSListAnnotations];
            self.vehicleGPSList = @[we.vehicle];
            //            [_mapView addAnnotations:self.vehicleGPSList];
            [self addVehicleGPSListAnnotations];
        }
    }
    
    if (![we isTracking])
    {
        //        [_mapView removeOverlays:_lines];
        [self removeLinesOverlay];
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
        
        if (_hadSetCenter)
        {
            [self setCenter:we.vehicle];
        }
        else
        {
            _hadSetCenter = YES;
            [self setCenterOf:[we.vehicle coordinate] zoom:17];
        }
        
        
        //        [_mapView setCenterCoordinate:[we.vehicle coordinate] animated:YES];
        
        [self performSelector:@selector(resetSettingCenter) withObject:nil afterDelay:0.5];
    }
#endif
}

- (void)removeLinesOverlay
{
    for (GMSPolyline *line in _lines)
    {
        line.map = nil;
    }
}

- (void)removeVehicleGPSListAnnotations
{
    for (VehicleGPSListItem *item in _vehicleGPSList)
    {
        item.marker.map = nil;
    }
}

- (void)addVehicleGPSListAnnotations
{
    for (VehicleGPSListItem *item in _vehicleGPSList)
    {
        [item addToMapView:_mapView];
    }
}


//- (void)mergeGPSList:(NSArray *)list
//{
//    if (list)
//    {
//    
//    NSMutableArray *array = [NSMutableArray arrayWithArray:self.vehicleGPSList];
//    
//    NSMutableArray *tarlist = [NSMutableArray arrayWithArray:list];
//    
//    for (VehicleGPSListItem *item in tarlist)
//    {
//        for (VehicleGPSListItem *veh in array)
//        {
//            if (veh.ID == item.ID)
//            {
//                [veh merge:item];
//                [array removeObject:veh];
//                break;
//            }
//        }
//        
//        tarlist removeAllObjects
//    }
//    }
//    
//}


- (void)onGetVehicleGPSList:(NSArray *)list
{
//    [self mergeGPSList:list];
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
            _calloutAnnotation.map = nil;
            _calloutAnnotation = nil;
            //            [_mapView removeAnnotation:_calloutAnnotation];
        }
        
        if (_vehicleGPSList)
        {
            [self removeVehicleGPSListAnnotations];
        }
        
        self.vehicleGPSList = list;
        [self adjustCenter];
        //        [_mapView addAnnotations:_vehicleGPSList];
        [self addVehicleGPSListAnnotations];
        
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
                    //                    CLLocationCoordinate2D line[2] = {[start coordinate], [end coordinate]};
                    
                    
                    GMSMutablePath *path = [GMSMutablePath path];
                    [path addCoordinate:[start coordinate]];
                    [path addCoordinate:[end coordinate]];
                    
                    GMSPolyline *pLine = [GMSPolyline polylineWithPath:path];
                    pLine.strokeColor = [UIColor redColor];
                    pLine.strokeWidth = 2;
                    pLine.map = _mapView;
                    [_lines addObject:pLine];
                    
                    //                    MKPolyline *pLine = [MKPolyline polylineWithCoordinates:line count:2];
                    //                    [_mapView addOverlay:pLine];
                    //                    [_lines addObject:pLine];
                }
                
                
            }
            
        }
    }
    
#endif
}

- (void)getVehicleAddress:(CLLocationCoordinate2D)loc
{
    __weak typeof(self) ws = self;
    [self asyncGetAddress:loc addressCompletion:^(NSDictionary *result) {
        
        //        NSString *address = [result objectForKey:@"formatted_address"];
        ws.selectPaopaoView.address.text = result[@"formatted_address"];
        NSArray *addCom = [result objectForKey:@"address_components"];
        if (addCom.count >= 2)
        {
            NSDictionary *street = [addCom objectAtIndex:1];
            ws.title = street[@"long_name"];
            
            
        }
        
    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (void)addOwnViews
{
    
    
    // 向界面上添加相关的数据
#if kSupportMap
    NSNumber *latNum = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:kLastUserLocationLatitude];
    NSNumber *longNum = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:kLastUserLocationLongitude];
    GMSMutableCameraPosition *camera = nil;
    if (latNum && longNum)
    {
        double latitude = latNum.doubleValue;
        double longitude = longNum.doubleValue;
        camera = [GMSMutableCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:17];
        _hadSetCenter = YES;
    }
    //    if (!camera)
    //    {
    //        camera = [[GMSMutableCameraPosition alloc] init];
    //        camera.zoom = 13.0f;
    //    }
    
    if (_hadSetCenter)
    {
        _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    }
    else
    {
        _mapView = [[GMSMapView alloc] init];
    }
    _mapView.delegate = self;
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



#define kVehicleAnnotationViewIndentifier @"VehicleAnnotationViewIndentifier"
#define kVehiclePaoPaoViewIndentifier @"VehiclePaoPaoViewIndentifier"
- (UIView *)mapView:(GMSMapView *)mapView newmarkerInfoWindow:(GMSMarker *)marker
{
    VehicleGPSListItem *item = (VehicleGPSListItem *)marker.userData;
    if ([item isKindOfClass:[VehicleGPSListItem class]])
    {
        return self.selectPaopaoView;
    }
    return nil;
}



- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    VehicleGPSListItem *item = (VehicleGPSListItem *)marker.userData;
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
        if (self.selectPaopaoView.paopaoItem == item)
        {
            return self.selectPaopaoView;
        }
        
        VehiclePaopaoView *pv = self.selectPaopaoView;
        
        [pv setGPSVehicle:item];
        
#if kShowGoogleStreet
        NSString *geocodeUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%@&language=en&sensor=false", [NSString stringWithFormat:@"%f,%f", item.Latidude, item.Longitude]];
        
        NSURL *url = [NSURL URLWithString:geocodeUrl];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
        
        
        __weak typeof(self) ws = self;
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSDictionary *dic = [data objectFromJSONData];
            DebugLog(@"%@", dic);
            
            NSString *string = (NSString *)[dic objectForKey:@"status"];
            if ([string isEqualToString:@"OK"])
            {
                NSArray *array = [dic objectForKey:@"results"];
                
                for (NSDictionary *dic in array)
                {
                    NSArray *addCom = [dic objectForKey:@"address_components"];
                    if (addCom.count > 2)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ws.selectPaopaoView.address.text = dic[@"formatted_address"];
                            NSDictionary *street = [addCom objectAtIndex:1];
                            ws.title = street[@"long_name"];
                            
                            if (mapView.selectedMarker == marker)
                            {
                                [mapView setSelectedMarker:marker];
                            }
                        });
                        break;
                    }
                }
            }
        }];
        
        //        NSString *geocodeUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%@&language=en&sensor=false", [NSString stringWithFormat:@"%f,%f", item.Latidude, item.Longitude]];
        //
        //        NSURL *url = [NSURL URLWithString:geocodeUrl];
        //        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
        //
        //        NSURLResponse *response = nil;
        //        NSError *error = nil;
        //        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        //
        //        NSDictionary *dic = [data objectFromJSONData];
        //        DebugLog(@"%@", dic);
        //
        //        NSString *string = (NSString *)[dic objectForKey:@"status"];
        //        if ([string isEqualToString:@"OK"])
        //        {
        //            NSArray *array = [dic objectForKey:@"results"];
        //
        //            for (NSDictionary *dic in array)
        //            {
        //                NSArray *addCom = [dic objectForKey:@"address_components"];
        //                if (addCom.count > 2)
        //                {
        //                    pv.address.text = dic[@"formatted_address"];
        //                    NSDictionary *street = [addCom objectAtIndex:1];
        //                    self.title = street[@"long_name"];
        //                    break;
        //                }
        //            }
        //        }
//        
//        [self getVehicleAddress:[item coordinate]];
        
#else
        NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=%@&callback=renderReverse&location=%f,%f&output=json&pois=1", kServerAppKey, item.Latidude, item.Longitude];
        
        NSURL *URL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"GET"];
        
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *jsonstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSRange range = [jsonstring rangeOfString:@"renderReverse&&renderReverse("];
        if (range.length)
        {
            NSString *json = [jsonstring substringAtRange:NSMakeRange(range.location + range.length, jsonstring.length - range.length - range.location - 1)];
            NSDictionary *dic = [json objectFromJSONString];
            if ([dic[@"status"] integerValue] == 0)
            {
                NSDictionary *result = dic[@"result"];
                
                if (result)
                {
                    NSDictionary *comp = result[@"addressComponent"];
                    pv.address.text = [NSString stringWithFormat:@"%@%@%@", comp[@"city"], comp[@"district"], comp[@"street"]];
                    self.title = result[@"street"];
                }
            }
        }
        
#endif
        
        return pv;
    }
    return nil;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    VehicleGPSListItem *item = (VehicleGPSListItem *)marker.userData;
    CarInfoViewController *info = [NSObject loadClass:[CarInfoViewController class]];
    info.vehicle = item;
    [[AppDelegate sharedAppDelegate] pushViewController:info];
}


- (void)showFloatPanel
{
    [_floatPanel show];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    [self showFloatPanel];
}


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self showFloatPanel];
}


- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self showFloatPanel];
}

@end
