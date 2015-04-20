//
//  BaseViewController.h
//  TCLSales
//
//  Created by 陈耀武 on 14-1-15.
//  Copyright (c) 2014年 CarOnline. All rights reserved.
//

#import "CommonBaseViewController.h"
//#import "ReqDelegate.h"

@interface BaseViewController : CommonBaseViewController
#if kSupportMap
<BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_geocodesearch;// = [[BMKGeoCodeSearch alloc] init];
}

@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

#endif
//+ (BMKCoordinateRegion)regionForAnnotations:(NSArray *) annotations;

- (void)getVehicleAddress:(CLLocationCoordinate2D)loc;
- (void)asyncGetAddress:(CLLocationCoordinate2D)loc addressCompletion:(void (^)(NSDictionary *address))action;

- (void)showNotification:(UILocalNotification *)notify;

@end
