//
//  CarEelecFenceGViewController.m
//  CarOnline
//
//  Created by James on 14-11-17.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//
#if kSupportGMap
#import "CarEelecFenceGViewController.h"


@interface GFenceAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation GFenceAnnotation



@end







@interface CarEelecFenceGViewController ()
{
    MKCircle *_fenceCircle;
}

@property (nonatomic, strong) GetElectronicFenceResponseBody *fenceBody;

@end

@implementation CarEelecFenceGViewController

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
    GFenceAnnotation *fence = [[GFenceAnnotation alloc] init];
    
    
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
    _fenceCircle = [MKCircle circleWithCenterCoordinate:loc radius:body.Enclosure];
    [_mapView addOverlay:_fenceCircle];
    
    [self setCenterCoordinate:loc zoomLevel:13 animated:YES];

    
//    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance([fence coordinate], (double)body.Enclosure * 3/2, (double)body.Enclosure * 3/2);
//    MKCoordinateRegion regf = [_mapView regionThatFits:reg];
//    [_mapView setRegion:regf animated:YES];
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
    
    [_mapView performSelector:@selector(addAnnotation:) withObject:_vehicle afterDelay:0.5];

    
    [_floatView setGPSListItem:self.vehicle];
}

- (void)onGetAddress:(VehicleGPSListItem *)gps;
{
    [self getVehicleAddress:[gps coordinate]];
}

- (void)addOwnViews
{
    [super addOwnViews];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(_vehicle.Latidude, _vehicle.Longitude);
    [self setCenterCoordinate:loc zoomLevel:10 animated:YES];

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



#define kVehicleAnnotationViewIndentifier @"VehicleAnnotationViewIndentifier"
#define kVehicleGFenceAnnotationnViewIndentifier @"VehicleGFenceAnnotationnViewIndentifier"

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)aAnnotation
{
    VehicleGPSListItem *annotation = (VehicleGPSListItem *)aAnnotation;
    if ([annotation isKindOfClass:[VehicleGPSListItem class]])
    {
        MKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleAnnotationViewIndentifier];
        
        if (vav == nil)
        {
            vav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleAnnotationViewIndentifier];
        }
        
        VehiclePinView *view = [[VehiclePinView alloc] initWithVehicle:annotation];
        [view setGPSVehicle:annotation];
        
        vav.image = [view captureImage];
        vav.canShowCallout = NO;
        return vav;
    }
    else if ([annotation isKindOfClass:[GFenceAnnotation class]])
    {
        MKAnnotationView *vav = [mapView dequeueReusableAnnotationViewWithIdentifier:kVehicleGFenceAnnotationnViewIndentifier];
        
        if (vav == nil)
        {
            vav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kVehicleGFenceAnnotationnViewIndentifier];
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
        return vav;
    }
    
    return nil;
    
    
}


////根据overlay生成对应的View
//- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
//{
//    // 添加范围覆盖层
//	if ([overlay isKindOfClass:[BMKCircle class]])
//    {
//        BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
//        circleView.fillColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.5];
//        circleView.strokeColor = [kRedColor colorWithAlphaComponent:0.5];
//        circleView.lineWidth = 2.0;
//		return circleView;
//    }
//    return nil;
//}

- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    //返回覆盖的视图
    MKCircleView *circleView = (MKCircleView *)[mapView viewForOverlay:overlay];
    if (circleView == nil)
    {
        circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [kRedColor colorWithAlphaComponent:0.5];
        circleView.lineWidth = 2.0;
        
    }
    return circleView;
}




@end
#endif