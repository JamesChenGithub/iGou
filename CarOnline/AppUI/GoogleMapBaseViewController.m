//
//  GeoMapBaseViewController.m
//  CarOnline
//
//  Created by James on 14-12-9.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "GoogleMapBaseViewController.h"

@interface GoogleMapBaseViewController ()

@end

@implementation GoogleMapBaseViewController

- (void)addOwnViews
{
    [super addOwnViews];
    
    // Do any additional setup after loading the view.
    // 创建一个GMSCameraPosition,告诉map在指定的zoom level下显示指定的点
    VehicleGPSListItem *item = [WebServiceEngine sharedEngine].vehicle;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:item.Latidude longitude:item.Longitude zoom:17];
    _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

- (void)layoutOnIPhone
{
    _mapView.frame = self.view.bounds;
}

- (void)zoomIn
{
    VehicleGPSListItem *item = [WebServiceEngine sharedEngine].vehicle;
    [self setCenterOf:[item coordinate] zoom:_mapView.camera.zoom + 1];
}


- (void)zoomOut
{
    VehicleGPSListItem *item = [WebServiceEngine sharedEngine].vehicle;
    [self setCenterOf:[item coordinate] zoom:_mapView.camera.zoom - 1];
}

- (void)setCenter:(VehicleGPSListItem *)item
{
    [self setCenterOf:[item coordinate]];
}

- (void)setCenterOf:(CLLocationCoordinate2D)item
{
    [self setCenterOf:item zoom:_mapView.camera.zoom];
}


- (void)setCenterOf:(CLLocationCoordinate2D)item zoom:(CGFloat)zoom
{
    if (zoom == 0)
    {
        zoom = 13;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:item.latitude longitude:item.longitude zoom:zoom];
    [_mapView animateToCameraPosition:camera];
}

#if kShowGoogleStreet

- (void)asyncGetAddress:(CLLocationCoordinate2D)loc addressCompletion:(void (^)(NSDictionary *address))action
{
    if (action)
    {
        NSString *geocodeUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%@&language=en&sensor=false", [NSString stringWithFormat:@"%f,%f", loc.latitude, loc.longitude]];
        
        NSURL *url = [NSURL URLWithString:geocodeUrl];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
        
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
                        action(dic);
                        break;
                    }
                }
            }
        }];
    
    }
    
    
    
    
}

- (void)getVehicleAddress:(CLLocationCoordinate2D)loc
{
    __weak typeof(self) ws = self;
    [self asyncGetAddress:loc addressCompletion:^(NSDictionary *result) {
        
//        NSString *address = [result objectForKey:@"formatted_address"];

        NSArray *addCom = [result objectForKey:@"address_components"];
        if (addCom.count >= 2)
        {
            NSDictionary *street = [addCom objectAtIndex:1];
            ws.title = street[@"long_name"];
        }

//        if (addCom.count >= 2)
//        {
//           NSDictionary *last = [addCom objectAtIndex:addCom.count - 1];
//           NSDictionary *last2 = [addCom objectAtIndex:addCom.count - 2];
//
//           self.cityString = [NSString stringWithFormat:@"%@%@", [last objectForKey:@"long_name"], [last2 objectForKey:@"objc_getProtocol"]];
//
//        }
//        else
//        {
//           self.cityString = address;
//        }
//
//        [self reverseAddress:address];
        
//        NSDictionary *address = result[@"addressComponent"];
//        ws.title = address[@"street"];
    }];
}
#endif

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView startRendering];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView stopRendering];
    [super viewWillDisappear:animated];
}


@end
