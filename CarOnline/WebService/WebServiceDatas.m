//
//  WebServiceDatas.m
//  CarOnline
//
//  Created by James on 14-8-19.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "WebServiceDatas.h"

@implementation GroupListItem

@end

//@implementation VehicleGPSListItem
//
//@end

@implementation VehicleGPSListItem


- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(_Latidude, _Longitude);
}


- (NSString *)title
{
    return _DeviceName;
}

- (id)copyWithZone:(NSZone *)zone
{
    VehicleGPSListItem *newItem = [[VehicleGPSListItem allocWithZone:zone] init];
    newItem.ID = _ID;
    newItem.VehicleNumber = _VehicleNumber;
    newItem.VehicleSpeed = _VehicleSpeed;
    newItem.Longitude = _Longitude;
    newItem.VehicleNumber = _VehicleNumber;
    newItem.Latidude = _Latidude;
    newItem.Date = _Date;
    
    newItem.Status = _Status;
    newItem.Direction = _Direction;
    newItem.DirectionDegree = _DirectionDegree;
    newItem.DeviceName = _DeviceName;
    newItem.Address = _Address;
    newItem.SpeedAlert = _SpeedAlert;
    newItem.Distance = _Distance;
    newItem.VehicleStatus = _VehicleStatus;
    newItem.Enclosure = _Enclosure;
    newItem.isStaticAnnotaion = _isStaticAnnotaion;
    
    
    return newItem;
}

- (void)merge:(VehicleGPSListItem *)item
{
    self.ID = item.ID;
    self.VehicleNumber = item.VehicleNumber;
    self.VehicleSpeed = item.VehicleSpeed;
    self.Longitude = item.Longitude;
    self.VehicleNumber = item.VehicleNumber;
    self.Latidude = item.Latidude;
    self.Date = item.Date;
    
    self.Status = item.Status;
    self.Direction = item.Direction;
    self.DirectionDegree = item.DirectionDegree;
    self.DeviceName = item.DeviceName;
    self.Address = item.Address;
    self.SpeedAlert = item.SpeedAlert;
    self.Distance = item.Distance;
    self.VehicleStatus = item.VehicleStatus;
    self.Enclosure = item.Enclosure;
    self.isStaticAnnotaion = item.isStaticAnnotaion;
}

#if kSupportGoogleMap

+ (GMSMarker *)addVehicle:(VehicleGPSListItem *)item toMapView:(GMSMapView *)map
{
    if (!map)
    {
        return nil;
    }
    VehiclePinView *view = [[VehiclePinView alloc] initWithVehicle:item];
    [view setGPSVehicle:item];
    
    //    vav.image = [view captureImage];
    //    vav.canShowCallout = NO;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = [item coordinate];
    marker.icon = [view captureImage];
    marker.map = map;
    return marker;
}

- (GMSMarker *)addToMapView:(GMSMapView *)map
{
    if (!map)
    {
        return nil;
    }
    VehiclePinView *view = [[VehiclePinView alloc] initWithVehicle:self];
    [view setGPSVehicle:self];
    
//    vav.image = [view captureImage];
//    vav.canShowCallout = NO;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = [self coordinate];
    marker.icon = [view captureImage];
    marker.map = map;
    marker.userData = self;
    
//    if (self.isStaticAnnotaion)
//    {
//        GMSPanoramaView *pv = [[GMSPanoramaView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        marker.panoramaView = pv;
//        pv.backgroundColor = kRedColor;
////        VehicleStopPaoView *pv = [[VehicleStopPaoView alloc] initWithVehicle:annotation];
////        vav.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:pv];
////        vav.canShowCallout = YES;
//    }
    self.marker = marker;
    return marker;
}
//- (GMSMarker *)addStopToMapView:(GMSMapView *)map
//{
//    if (!map)
//    {
//        return nil;
//    }
//    
//    VehicleStopPaoView *pv = [[VehicleStopPaoView alloc] initWithVehicle:self];
//    //    vav.image = [view captureImage];
//    //    vav.canShowCallout = NO;
//    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = [self coordinate];
//    marker.icon = [pv captureImage];
//    marker.map = map;
//    return marker;
//}
#endif


@end

@implementation VehicleGPSListPaopaoItem 

+ (instancetype)copy:(VehicleGPSListItem *)item;
{
    VehicleGPSListPaopaoItem *newItem = [[VehicleGPSListPaopaoItem alloc] init];
    newItem.ID = item.ID;
    newItem.VehicleNumber = item.VehicleNumber;
    newItem.VehicleSpeed = item.VehicleSpeed;
    newItem.Longitude = item.Longitude;
    newItem.VehicleNumber = item.VehicleNumber;
    newItem.Latidude = item.Latidude;
    newItem.Date = item.Date;
    
    newItem.Status = item.Status;
    newItem.Direction = item.Direction;
    newItem.DirectionDegree = item.DirectionDegree;
    newItem.DeviceName = item.DeviceName;
    newItem.Address = item.Address;
    newItem.SpeedAlert = item.SpeedAlert;
    newItem.Distance = item.Distance;
    newItem.VehicleStatus = item.VehicleStatus;
    newItem.Enclosure = item.Enclosure;
    newItem.isStaticAnnotaion = item.isStaticAnnotaion;
    newItem.stopDuration = item.stopDuration;
    
    return newItem;
}
//- (id)copyWithZone:(NSZone *)zone
//{
//    VehicleGPSListPaopaoItem *newItem = [[VehicleGPSListPaopaoItem allocWithZone:zone] init];
//    newItem.ID = self.ID;
//    newItem.VehicleNumber = self.VehicleNumber;
//    newItem.VehicleSpeed = self.VehicleSpeed;
//    newItem.Longitude = self.Longitude;
//    newItem.VehicleNumber = self.VehicleNumber;
//    newItem.Latidude = self.Latidude;
//    newItem.Date = self.Date;
//    
//    newItem.Status = self.Status;
//    newItem.Direction = self.Direction;
//    newItem.DirectionDegree = self.DirectionDegree;
//    newItem.DeviceName = self.DeviceName;
//    newItem.Address = self.Address;
//    newItem.SpeedAlert = self.SpeedAlert;
//    newItem.Distance = self.Distance;
//    newItem.VehicleStatus = self.VehicleStatus;
//    newItem.Enclosure = self.Enclosure;
//    newItem.isStaticAnnotaion = self.isStaticAnnotaion;
//    
//    
//    return newItem;
//}

@end

@implementation VehiclePlaybackItem

+ (instancetype)copy:(VehicleGPSListItem *)item;
{
    VehiclePlaybackItem *newItem = [[VehiclePlaybackItem alloc] init];
    newItem.ID = item.ID;
    newItem.VehicleNumber = item.VehicleNumber;
    newItem.VehicleSpeed = item.VehicleSpeed;
    newItem.Longitude = item.Longitude;
    newItem.VehicleNumber = item.VehicleNumber;
    newItem.Latidude = item.Latidude;
    newItem.Date = item.Date;
    
    newItem.Status = item.Status;
    newItem.Direction = item.Direction;
    newItem.DirectionDegree = item.DirectionDegree;
    newItem.DeviceName = item.DeviceName;
    newItem.Address = item.Address;
    newItem.SpeedAlert = item.SpeedAlert;
    newItem.Distance = item.Distance;
    newItem.VehicleStatus = item.VehicleStatus;
    newItem.Enclosure = item.Enclosure;
    newItem.isStaticAnnotaion = item.isStaticAnnotaion;
    newItem.stopDuration = item.stopDuration;
    
    return newItem;
}


- (GMSMarker *)addToMapView:(GMSMapView *)map
{
    if (!map)
    {
        return nil;
    }
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = [self coordinate];
    marker.icon = _isStart ? [UIImage imageNamed:@"VRM_i06_010_StartFlag.png"] : [UIImage imageNamed:@"VRM_i06_011_StopFlag.png"];
    marker.map = map;
    marker.userData = self;
    self.marker = marker;
    return marker;
}

@end


@implementation AlertListItem

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:kAlertListItem_Description_Format_Str, _DeviceName, _AlertContent, _AlertAddress, _AlertOn];
    return desc;
}

@end