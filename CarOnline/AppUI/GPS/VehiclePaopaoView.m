//
//  VehiclePaopaoView.m
//  CarOnline
//
//  Created by James on 14-8-23.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "VehiclePaopaoView.h"


@implementation VehiclePinView

static UIImage *kDirectionImage = nil;

- (instancetype)initWithVehicle:(VehicleGPSListItem *)item
{
    if (item.isStaticAnnotaion)
    {
//        CGFloat width = 30;
        
        if (self = [super initWithFrame:CGRectMake(0, 0, 21, 27)])
        {
            _deviceNameBg = [[UIImageView alloc] init];
            _deviceNameBg.image = [UIImage imageNamed:@"VRM_i06_011_StopFlag.png"];
            _deviceNameBg.frame = CGRectMake(0, 0, 21, 27);
//            _deviceNameBg.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:_deviceNameBg];
            
//            _deviceName = [[UILabel alloc] init];
//            _deviceName.textColor = kWhiteColor;
//            _deviceName.text = kVehicle_Status_Stop_Str;
//            _deviceName.font = [UIFont systemFontOfSize:12];
//            _deviceName.backgroundColor = RGB(220, 0, 10);
//            _deviceName.adjustsFontSizeToFitWidth = YES;
//            _deviceName.adjustsLetterSpacingToFitWidth = YES;
//            _deviceName.textAlignment = NSTextAlignmentCenter;
//            _deviceName.frame = CGRectMake(4, 8, 28, 18);
//            [self addSubview:_deviceName];
        }
        return self;
    }
    else
    {
        CGFloat width = 80;
        NSString *devName = [item DeviceName];
        CGSize size = [devName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(HUGE_VAL, 30)];
        if ((NSInteger)size.width > 74)
        {
            width = (NSInteger)size.width + 6;
        }

        CGFloat selfheight = [AppDelegate sharedAppDelegate].isChinese ? 108 : 68;
        if (self = [super initWithFrame:CGRectMake(0, 0, width, selfheight)])
        {
            _deviceNameBg = [[UIImageView alloc] init];
            _deviceNameBg.image = [UIImage imageNamed:@"VRM_i04_002_SmallPlate.png"];
            _deviceNameBg.frame = CGRectMake(0, 0, width, 40);
            _deviceNameBg.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:_deviceNameBg];
            
            _deviceName = [[UILabel alloc] init];
            _deviceName.textColor = kWhiteColor;
            _deviceName.text = devName;
            _deviceName.font = [UIFont systemFontOfSize:12];
            _deviceName.backgroundColor = kClearColor;
            _deviceName.adjustsFontSizeToFitWidth = YES;
            _deviceName.adjustsLetterSpacingToFitWidth = YES;
            _deviceName.textAlignment = NSTextAlignmentCenter;
            _deviceName.frame = CGRectMake(1, 0, width - 6, 30);
            [self addSubview:_deviceName];
            
            _directionView = [[UIImageView alloc] init];
            
            if (!kDirectionImage)
            {
//                kDirectionImage = [[UIImage imageNamed:@"gps_button.png"] imageWithTintColor:kRedColor];
                kDirectionImage = [UIImage imageNamed:@"VRM_i04_001_Device.png"];
            }
            
            _directionView.image = kDirectionImage;
            [self addSubview:_directionView];
            [_directionView sizeWith:CGSizeMake(21, 27)];
            if ([AppDelegate sharedAppDelegate].isChinese)
            {
                _directionView.center = self.center;
            }
            else
            {
                [_directionView alignParentBottom];
                [_directionView layoutParentHorizontalCenter];
            }
            
//            _directionView.layer.shadowColor = [UIColor blackColor].CGColor;
//            _directionView.layer.masksToBounds = YES;
//            _directionView.layer.shadowOpacity = 1;
//            _directionView.layer.shadowOffset = CGSizeMake(5, 5);
            
        }
        return self;
    }
    
    
}

- (void)setDeviceNameText:(NSString *)deviceName
{
    if (_directionView)
    {
        _deviceName.text = deviceName;
        CGSize size = [deviceName sizeWithFont:_deviceName.font constrainedToSize:CGSizeMake(HUGE_VAL, 30)];
        if (size.width > 70)
        {
            self.frame = CGRectMake(0, 0, size.width + 10, 100);
            _deviceName.frame = CGRectMake(2, 0, size.width, 30);
            _deviceNameBg.frame = CGRectMake(0, 0, size.width + 10, 40);
            
            _directionView.center = self.center;
        }
    }
    
}

// 设置角度
- (void)setGPSVehicle:(VehicleGPSListItem *)item
{
//    if (_directionView)
//    {
//        if (item.DirectionDegree != 0)
//        {
//            if (item.DirectionDegree > 180)
//            {
//                _directionView.transform = CGAffineTransformMakeRotation(M_PI * (item.DirectionDegree - 360)/180);
//            }
//            else
//            {
//                _directionView.transform = CGAffineTransformMakeRotation(M_PI * item.DirectionDegree/180);
//            }
//        }
//    }
    
}

- (void)setGPSVehicle:(VehicleGPSListItem *)item fromPosition:(CLLocationCoordinate2D)from toPosition:(CLLocationCoordinate2D)to
{
//    if (_directionView)
//    {
//        if (item.DirectionDegree != 0)
//        {
//            if (item.DirectionDegree > 180)
//            {
//                _directionView.transform = CGAffineTransformMakeRotation(M_PI * (item.DirectionDegree - 360)/180);
//            }
//            else
//            {
//                _directionView.transform = CGAffineTransformMakeRotation(M_PI * item.DirectionDegree/180);
//            }
//            
//        }
//    }
}

@end

@implementation VehicleStopPaoView

- (instancetype)initWithVehicle:(VehicleGPSListItem *)item
{
    CGFloat width = 80;
    NSString *devName = [item stopDuration];
    CGSize size = [devName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(HUGE_VAL, 30)];
    if ((NSInteger)size.width > 74)
    {
        width = (NSInteger)size.width + 6;
    }
    
    NSInteger height = [AppDelegate sharedAppDelegate].isChinese ? 40 : 40;
    
    
    if (self = [super initWithFrame:CGRectMake(0, 0, width, height)])
    {
        _deviceNameBg = [[UIImageView alloc] init];
        _deviceNameBg.image = [UIImage imageNamed:@"VRM_i04_002_SmallPlate.png"];
        _deviceNameBg.frame = CGRectMake(0, 0, width, 40);
        _deviceNameBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_deviceNameBg];
        
        _deviceName = [[UILabel alloc] init];
        _deviceName.textColor = kWhiteColor;
        _deviceName.text = devName;
        _deviceName.font = [UIFont systemFontOfSize:12];
        _deviceName.backgroundColor = kClearColor;
        _deviceName.adjustsFontSizeToFitWidth = YES;
        _deviceName.adjustsLetterSpacingToFitWidth = YES;
        _deviceName.textAlignment = NSTextAlignmentCenter;
        _deviceName.frame = CGRectMake(1, 0, width - 6, 30);
        [self addSubview:_deviceName];
    }
    return self;
}

@end


@interface VehiclePaopaoView ()

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@end

@implementation VehiclePaopaoView

- (VehicleGPSListItem *)paopaoItem
{
    return _vehicle;
}

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 200, 60)])
    {
        CGRect rect = self.bounds;
        
        _positionView = [[UIButton alloc] init];
        [_positionView setBackgroundImage:[UIImage imageNamed:@"VRM_i04_003_BigPlate.png"] forState:UIControlStateNormal];
        _positionView.frame = CGRectMake(0, 0, rect.size.width, 60);
        [self addSubview:_positionView];
        [_positionView addTarget:self action:@selector(toDeviceInfo) forControlEvents:UIControlEventTouchUpInside];
        
        const NSInteger kArrowSize = 24;
        const NSInteger kVerMargin = 5;
        const NSInteger kHorMargin = 8;
        
        
        const NSInteger kLabelWidth = (rect.size.width - kArrowSize - 3*kHorMargin);
        const NSInteger kLabelHeight = 20;
        
        
        _statusSpeed = [[UILabel alloc] init];
        _statusSpeed.textColor = kWhiteColor;
        _statusSpeed.font = [UIFont systemFontOfSize:12];
        _statusSpeed.backgroundColor = kClearColor;
//        _statusSpeed.adjustsFontSizeToFitWidth = YES;
        _statusSpeed.frame = CGRectMake(kHorMargin, kVerMargin, kLabelWidth, kLabelHeight);
        [_positionView addSubview:_statusSpeed];
        
        _address = [[UILabel alloc] init];
        _address.textColor = kWhiteColor;
        _address.backgroundColor = kClearColor;
        _address.font = [UIFont systemFontOfSize:12];
//        _address.adjustsFontSizeToFitWidth = YES;
//        _address.adjustsLetterSpacingToFitWidth = YES;
        _address.lineBreakMode = NSLineBreakByTruncatingTail;
        _address.frame = CGRectMake(kHorMargin, kLabelHeight, kLabelWidth, 50 - kLabelHeight);
        [_positionView addSubview:_address];
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VRM_i04_004_FunctionArrow.png"]];
        _arrow.frame = CGRectMake(_positionView.frame.size.width - kArrowSize - kHorMargin, (_positionView.frame.size.height - 10 - kArrowSize)/2, kArrowSize, kArrowSize);
        [_positionView addSubview:_arrow];
    }
    return self;
}

//- (void)onClickDevice
//{
//    _positionView.hidden = NO;
//}

- (void)setGPSVehicle:(VehicleGPSListItem *)item;
{
    self.vehicle = item;
    NSString *status = item.Status.integerValue == 0 ?  kVehicle_Status_Offline_Str :  item.VehicleSpeed == 0 ? kVehicle_Status_Static_Str : kVehicle_Status_Running_Str;
    NSString *speed = [NSString stringWithFormat:kVehicle_Speed_Format_Str, (int)item.VehicleSpeed];
    
    _statusSpeed.text = [NSString stringWithFormat:@"%@-%@", status, speed];
    _address.text = item.Address;
}

- (void)toDeviceInfo
{
    CarInfoViewController *info = [NSObject loadClass:[CarInfoViewController class]];
    info.vehicle = self.vehicle;
    [[AppDelegate sharedAppDelegate] pushViewController:info];
}

@end


@implementation GVehiclePaopaoView

- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        CGRect rect = CGRectMake(0, 0, 200, 60);
        _paopaoView = [[VehiclePaopaoView alloc] init];
        [self addSubview:_paopaoView];
        self.frame = rect;
        self.centerOffset = CGPointMake(0, -75);
    }
    return self;
}

- (void)setGPSVehicle:(VehicleGPSListItem *)item;
{
    [_paopaoView setGPSVehicle:item];
}

- (void)toDeviceInfo
{
    [_paopaoView toDeviceInfo];
}

@end



@interface VehicleFencePaopaoView ()

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@end

@implementation VehicleFencePaopaoView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 80, 40)])
    {
        _deviceName = [[UIButton alloc] init];
        [_deviceName setBackgroundImage:[UIImage imageNamed:@"VRM_i04_002_SmallPlate.png"] forState:UIControlStateNormal];
        _deviceName.frame = CGRectMake(0, 0, 80, 40);
        [_deviceName setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _deviceName.titleLabel.font = [UIFont systemFontOfSize:12];
        _deviceName.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        [self addSubview:_deviceName];
    }
    return self;
}

- (void)setGPSVehicle:(VehicleGPSListItem *)item;
{
    self.vehicle = item;
#if kSupportMap
    [_deviceName setTitle:[item title] forState:UIControlStateNormal];
#endif
    
}

@end



@implementation FencePaopaoView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 120, 20)])
    {
        _range = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        _range.textColor = kBlackColor;
        _range.backgroundColor = kClearColor;
        _range.font = [UIFont systemFontOfSize:13];
        _range.adjustsFontSizeToFitWidth = YES;
        _range.adjustsLetterSpacingToFitWidth = YES;
        [self addSubview:_range];
    }
    return self;
}

@end
