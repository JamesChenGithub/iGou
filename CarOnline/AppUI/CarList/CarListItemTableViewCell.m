//
//  CarListItemTableViewCell.m
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarListItemTableViewCell.h"

@implementation CarListItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"car_flag.png"];
        [self.contentView addSubview:_icon];
        
        _name = [[UILabel alloc] init];
        _name.textColor = kBlackColor;
        _name.backgroundColor = kClearColor;
        _name.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_name];
        
        _status = [[UILabel alloc] init];
        _status.textColor = kBlackColor;
        _status.backgroundColor = kClearColor;
        _status.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_status];
        

        _location = [UIButton buttonWithType:UIButtonTypeCustom];
        [_location setImage:[UIImage imageNamed:@"VRM_i07_003_CarSelected.png"] forState:UIControlStateNormal];
        [_location addTarget:self action:@selector(toLocate:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_location];
        _location.hidden = YES;
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:kOrangeColor]];
        
        
        self.backgroundColor = kClearColor;
    }
    return self;
}

// 点击监控按钮，开始跟踪
- (void)toLocate:(UIButton *)button
{
    WebServiceEngine *eng = [WebServiceEngine sharedEngine];
//    BOOL hasChangedVehicle = YES;
//    if ([eng.vehicle.DeviceName isEqualToString:_vehicle.DeviceName])
//    {
//        hasChangedVehicle = NO;
//    }
    
    eng.vehicle = _vehicle;
    
    eng.isTracking = NO;
    
//    // 从GPS和OBD里面进入到CarList时，点Locate操作处理不一样
//    if ([AppDelegate sharedAppDelegate].navigationViewController.viewControllers.count == 2)
//    {
//        if (eng.isTracking)
//        {
//            // 从GPSmain中进入
//            if (hasChangedVehicle)
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kTrackChangedNotify object:nil userInfo:nil];
//            }
//            else
//            {
//                // 不作任何操作
//                [WebServiceEngine sharedEngine].isTracking = NO;
//            }
//        }
//        else
//        {
//            [WebServiceEngine sharedEngine].isTracking = YES;
//        }
//    }
    
    [[AppDelegate sharedAppDelegate] popViewController];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
#if kSupportOldUI
    
    [_icon sizeWith:CGSizeMake(20, 20)];
    [_icon layoutParentVerticalCenter];
    [_icon alignParentLeftWithMargin:20];
    
    [_name sizeWith:CGSizeMake(100, rect.size.height)];
    [_name layoutToRightOf:_icon margin:15];
    
    [_status sameWith:_name];
    [_status layoutToRightOf:_name margin:20];
    
    [_location sizeWith:CGSizeMake(rect.size.height, rect.size.height)];
    [_location alignParentRight];
#else
    
    _icon.hidden = YES;
//    _status.hidden = YES;
//    [_icon sizeWith:CGSizeMake(20, 20)];
//    [_icon layoutParentVerticalCenter];
//    [_icon alignParentLeftWithMargin:20];
    
//    [_name sizeWith:CGSizeMake(100, rect.size.height)];
//    [_name layoutToRightOf:_icon margin:15];
    
//    [_status sameWith:_name];
//    [_status layoutToRightOf:_name margin:20];
    
    CGSize size = CGSizeMake(rect.size.height, rect.size.height);//[_location imageForState:UIControlStateNormal].size;
    [_location sizeWith:size];
    [_location layoutParentVerticalCenter];
    [_location alignParentRight];
    
    [_name sizeWith:CGSizeMake((rect.size.width - size.width - 20)/2, rect.size.height)];
    [_name alignParentLeftWithMargin:20];
//    [_name scaleToLeftOf:_location margin:20];
    
    [_status sameWith:_name];
    [_status layoutToRightOf:_name];
    [_status scaleToLeftOf:_location];
    
#endif
    
}

- (void)configWith:(VehicleGPSListItem *)vehicle
{
    _vehicle = vehicle;
    _name.text = vehicle.DeviceName;
    _status.text = vehicle.VehicleStatus.intValue == 0 ?  kVehicle_Status_Offline_Str : kVehicle_Status_Online_Str;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
