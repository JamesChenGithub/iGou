//
//  OBDResultHeaderView.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDResultHeaderView : UIView<MFMailComposeViewControllerDelegate>
{
    UIImageView *_bgView;
    UIImageView *_leftLine;
    UILabel *_deviceName;
    UIButton *_pullButton;
    UIButton *_help;
    UIImageView *_rightLine;
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;





@end
