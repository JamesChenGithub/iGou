//
//  CarListItemTableViewCell.h
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarListItemTableViewCell : UITableViewCell
{
@private
    UIImageView     *_icon;
    UILabel         *_name;
    UILabel         *_status;
    UIButton        *_location;
    VehicleGPSListItem *_vehicle;
}

@property (nonatomic, readonly) UIButton *location;

- (void)configWith:(VehicleGPSListItem *)vehicle;

@end
