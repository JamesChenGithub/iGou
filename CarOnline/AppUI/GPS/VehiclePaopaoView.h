//
//  VehiclePaopaoView.h
//  CarOnline
//
//  Created by James on 14-8-23.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface VehiclePinView : UIView
{
@private
    UIImageView *_deviceNameBg;
    UILabel *_deviceName;
    UIImageView *_directionView;
}

- (instancetype)initWithVehicle:(VehicleGPSListItem *)item;

- (void)setGPSVehicle:(VehicleGPSListItem *)item;

- (void)setGPSVehicle:(VehicleGPSListItem *)item fromPosition:(CLLocationCoordinate2D)from toPosition:(CLLocationCoordinate2D)to;

@end

@interface VehicleStopPaoView : UIView
{
    UIImageView *_deviceNameBg;
    UILabel *_deviceName;
}

- (instancetype)initWithVehicle:(VehicleGPSListItem *)item;

@end



@interface VehiclePaopaoView : UIView
{
    UIButton *_positionView;
    
    UILabel *_statusSpeed;
    UILabel *_address;
    UIImageView *_arrow;
}

@property (nonatomic, readonly) UILabel *address;

- (void)setGPSVehicle:(VehicleGPSListItem *)item;

- (VehicleGPSListItem *)paopaoItem;

@end


@interface GVehiclePaopaoView : MKAnnotationView
{
    VehiclePaopaoView *_paopaoView;
}

@property (nonatomic, readonly) VehiclePaopaoView *paopaoView;

- (void)setGPSVehicle:(VehicleGPSListItem *)item;

@end

@interface VehicleFencePaopaoView : UIView
{
    UIButton *_deviceName;
}



- (void)setGPSVehicle:(VehicleGPSListItem *)item;

@end

@interface FencePaopaoView : UIView
{
    UILabel *_range;
}

@property (nonatomic, readonly) UILabel *range;

@end

