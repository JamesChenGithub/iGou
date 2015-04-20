//
//  CarEelecFenceGoogleMapViewController.m
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarEelecFenceGoogleMapViewController.h"


@interface GoogleFenceAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation GoogleFenceAnnotation

@end







@interface CarEelecFenceGoogleMapViewController ()


@property (nonatomic, strong) GetElectronicFenceResponseBody *fenceBody;

@end

@implementation CarEelecFenceGoogleMapViewController

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

    // 设置范围
    GoogleFenceAnnotation *fence = [[GoogleFenceAnnotation alloc] init];
    
    
    NSString *enStr = nil;
    if (body.Enclosure > 1000)
    {
        enStr = [NSString stringWithFormat:@"%0.2fkm", body.Enclosure/1000.0];
    }
    else
    {
        enStr = [NSString stringWithFormat:@"%dm", (int)body.Enclosure];
    }
    
//    _vehicle.marker.map = nil;
    
    fence.title = [NSString stringWithFormat:@"%@%@", kCarElectronicFence_CurrentLoc_Format_Str, enStr];
    fence.coordinate = CLLocationCoordinate2DMake(body.Lat, body.Lng);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [fence title];
    label.textColor = kRedColor;
    label.backgroundColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.5];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label textSizeIn:CGSizeMake(320, 100)];
    label.frame = CGRectMake(0, 0, size.width + 10, 20);
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(body.Lat, body.Lng);
    marker.icon = [label captureImage];
    marker.map = _mapView;
    marker.zIndex = 100000;
    
//    [_vehicle performSelector:@selector(addToMapView:) withObject:_mapView afterDelay:2];
    
    [self getVehicleAddress:[fence coordinate]];
    
    GMSCircle *circle = [GMSCircle circleWithPosition:CLLocationCoordinate2DMake(body.Lat, body.Lng) radius:body.Enclosure];
    circle.fillColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.5];
    circle.strokeColor = [kRedColor colorWithAlphaComponent:0.5];
    circle.strokeWidth = 2.0;
    circle.map = _mapView;
//    circle.zIndex = -100;
//zoomAtCoordinate:(CLLocationCoordinate2D)coordinate
//forMeters:(CLLocationDistance)meters
////perPoints:(CGFloat)points;
    
    float zoom = [GMSCameraPosition zoomAtCoordinate:CLLocationCoordinate2DMake(body.Lat, body.Lng)
                                              forMeters:4 * body.Enclosure
                                              perPoints:2 * body.Enclosure];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:body.Lat longitude:body.Lng zoom:zoom];
    
    _mapView.camera = camera;
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
    
    [_vehicle addToMapView:_mapView];
    
    
    [_floatView setGPSListItem:self.vehicle];
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
    [self.view addSubview:_floatView];
    
    
    _floatPanel = [[CarFencePanel alloc] init];
    _floatPanel.delegate = self;
    [self.view addSubview:_floatPanel];
}

- (void)toZoomAddMap
{
    [self zoomIn];
}

- (void)toZoomDecMap
{
    [self zoomOut];
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
    [super layoutOnIPhone];
    
    CGRect rect = self.view.bounds;
    
    [_floatView sizeWith:CGSizeMake(rect.size.width, kCarStatusFloatViewHeight)];
    [_floatView relayoutFrameOfSubViews];
    
    [_floatPanel sizeWith:CGSizeMake(80, 44 + 37 * 2 + kVerPadding + 1)];
    [_floatPanel alignParentTopWithMargin:20];
    [_floatPanel alignParentRightWithMargin:kRightMargin];
    [_floatPanel relayoutFrameOfSubViews];
}





@end