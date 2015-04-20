//
//  CarElectronicFenceViewController.m
//  CarOnline
//
//  Created by James on 14-8-27.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarElectronicFenceViewController.h"

#if kSupportMap
@interface FenceAnnotatio : NSObject<BMKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation FenceAnnotatio



@end

@interface FenceAnnotatioView : BMKAnnotationView

@end

@implementation FenceAnnotatioView

@end
#endif


@interface CarElectronicFenceViewController ()
{
#if kSupportMap
    BMKCircle *_fenceCircle;
#endif
}

@property (nonatomic, strong) GetElectronicFenceResponseBody *fenceBody;

@end

@implementation CarElectronicFenceViewController


- (void)onGetFence:(GetElectronicFenceResponseBody *)body
{
    self.fenceBody = body;
    [_floatPanel setFenceState:body.IsEnable];
    
    if (body.Enclosure == 0)
    {
        body.Enclosure = 500;
    }
    
    if (body.Lat == 0 && body.Lng == 0)
    {
        body.Lat = self.vehicle.Latidude;
        body.Lng = self.vehicle.Longitude;
    }
    
#if kSupportMap
    
    //    _mapView.zoomLevel = body.Enclosure < 2000 ? 15 : 10;
    
    //    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMakeWithDistance(loc, body.Enclosure, body.Enclosure);
    //    viewRegion.span = BMKCoordinateSpanMake(0.04, 0.04);
    //    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    //    [_mapView setRegion:adjustedRegion animated:YES];
    
    // 设置范围
    FenceAnnotatio *fence = [[FenceAnnotatio alloc] init];
    NSString *enStr = nil;
    if (body.Enclosure > 1000)
    {
        enStr = [NSString stringWithFormat:@"%0.2fkm", body.Enclosure/1000.0];
    }
    else
    {
        enStr = [NSString stringWithFormat:@"%dm", (int)body.Enclosure];
    }
    
    fence.title = [NSString stringWithFormat:@"%@%@", kCarElectronicFence_CurrentLoc_Format_Str, enStr];
    fence.coordinate = CLLocationCoordinate2DMake(body.Lat, body.Lng);
    [_mapView addAnnotation:fence];
    
    
    [self getVehicleAddress:[fence coordinate]];
    
    // 添加范处理
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(body.Lat, body.Lng);
    _fenceCircle = [BMKCircle circleWithCenterCoordinate:loc radius:body.Enclosure];
    [_mapView addOverlay:_fenceCircle];
    
    
    [_mapView setRegion:BMKCoordinateRegionMakeWithDistance(loc, 2*body.Enclosure, 2*body.Enclosure) animated:YES];
    //    [_mapView setCenterCoordinate:loc animated:YES];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    GetElectronicFence *ge = [[GetElectronicFence alloc] initWithHandler:^(BaseRequest *request) {
        
        GetElectronicFenceResponseBody *body = (GetElectronicFenceResponseBody *)request.response.Body;
        [weakSelf onGetFence:body];
        
    }];
    ge.VehicleNumber = self.vehicle.VehicleNumber;
    [[WebServiceEngine sharedEngine] asyncRequest:ge];
    
#if kSupportMap
    _mapView.zoomLevel = 15;
    [_mapView performSelector:@selector(addAnnotation:) withObject:_vehicle afterDelay:0.5];
#endif
    
    [_floatView setGPSListItem:self.vehicle];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if kSupportMap
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 用时，置self
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
#if kSupportMap
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
#endif
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
    _mapView.zoomLevel = 8;
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(_vehicle.Latidude, _vehicle.Longitude);
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(loc, BMKCoordinateSpanMake(0.1,0.1));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self.view addSubview:_mapView];
#endif
    
    _floatView = [[CarStatusFloatView alloc] initWithoutUpdate];
    _floatView.delegate = self;
    [self.view addSubview:_floatView];
    
    
    _floatPanel = [[CarFencePanel alloc] init];
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

- (void)onSetFenceSucc:(BaseResponse *)resp
{
    [_floatPanel switchState];
}

- (void)setElectronicFence:(BOOL)enable
{
    __weak typeof(self) weakSelf = self;
    
    // 点围栏请求处理
    SetElectronicFence *sf = [[SetElectronicFence alloc] initWithHandler:^(BaseRequest *request) {
        //        [[HUDHelper sharedInstance] tipMessage:[request.response message]];
        [weakSelf onSetFenceSucc:request.response];
    }];
    sf.VehicleNumber = self.vehicle.VehicleNumber;
    sf.IsEnable = enable ? 0 : 1;
    sf.Latidude = self.fenceBody.Lat;
    sf.Longitude = self.fenceBody.Lng;
    sf.Enclosure = self.fenceBody.Enclosure;
    [[WebServiceEngine sharedEngine] asyncRequest:sf];
}

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
    
    [_floatPanel sizeWith:CGSizeMake(80, 44 + 37 * 2 + kVerPadding + 1)];
    [_floatPanel alignParentTopWithMargin:20];
    [_floatPanel alignParentRightWithMargin:kRightMargin];
    [_floatPanel relayoutFrameOfSubViews];
}

#if kSupportMap


#define kVehicleAnnotationViewIndentifier @"VehicleAnnotationViewIndentifier"
#define kVehicleFenceAnnotationViewIndentifier @"VehicleFenceAnnotationViewIndentifier"

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)aAnnotation
{
    VehicleGPSListItem *annotation = (VehicleGPSListItem *)aAnnotation;
    if ([annotation isKindOfClass:[VehicleGPSListItem class]])
    {
        BMKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleAnnotationViewIndentifier];
        
        if (vav == nil)
        {
            vav = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleAnnotationViewIndentifier];
        }
        
        VehiclePinView *view = [[VehiclePinView alloc] initWithVehicle:annotation];
        [view setGPSVehicle:annotation];
        
        vav.image = [view captureImage];
        vav.canShowCallout = NO;
        return vav;
    }
    else if ([annotation isKindOfClass:[FenceAnnotatio class]])
    {
        BMKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleFenceAnnotationViewIndentifier];
        
        if (vav == nil)
        {
            vav = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleFenceAnnotationViewIndentifier];
        }
        
        // 在这个委托中实现如下代码
        //        UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 132, 64)];
        //        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 64)];
        //        [imageview setImage:[UIImage imageNamed:@"车位置.png"]];
        //        [viewForImage addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [annotation title];
        label.textColor = kRedColor;
        label.backgroundColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.5];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [label textSizeIn:CGSizeMake(320, 100)];
        label.frame = CGRectMake(0, 0, size.width + 10, 20);
        vav.image = [label captureImage];
        
        vav.canShowCallout = NO;
        vav.layer.zPosition = 10000;
        return vav;
    }
    
    return nil;
    
    
}


//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    // 添加范围覆盖层
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [kRedColor colorWithAlphaComponent:0.5];
        circleView.lineWidth = 2.0;
		return circleView;
    }
    return nil;
}


#endif

@end
