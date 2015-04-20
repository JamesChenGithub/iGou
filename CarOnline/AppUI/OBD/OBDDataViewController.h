//
//  OBDDataViewController.h
//  CarOnline
//
//  Created by James on 14-11-12.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"



@interface OBDDataResultView : OBDResultBaseView
{
    CarDataMonitorViewController *_monitorResults;
}

- (NSArray *)monitorResult;

@end

@interface OBDDataAnimationView : OBDAnimationBaseView
{
    UIImageView *_background;
    
    UIImageView *_carMeter;
    UIImageView *_speedPointer;
    UIImageView *_warning;
    UIImageView *_water;
    UIImageView *_battery;
    UIImageView *_rotatePointer;
    UILabel     *_vin;
    
    
    UILabel *_tempPressValue;
    UILabel *_mileGasValue;
    UILabel *_waterValue;
    UILabel *_batteryValue;
    
    CGAffineTransform _startRorate;
}

- (void)setMonitorResultEffect:(NSArray *)array;

@end

@interface OBDDataViewController : OBDBaseViewController

@end
