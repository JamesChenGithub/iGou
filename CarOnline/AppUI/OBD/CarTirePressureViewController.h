//
//  CarTirePressureViewController.h
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, CarTireDirection)
{
    ECarTire_LeftFront,
    ECarTire_RightFront,
    ECarTire_LeftBack,
    ECarTire_RightBack
};

@interface CarTireCell : UIView
{
    UILabel *_pressure;
    UILabel *_pressureUnit;
    UILabel *_temperature;
    UILabel *_temperatureUnit;

    NSMutableArray *_checkResults;
    
}

@property (nonatomic, assign) CarTireDirection direction;

- (NSArray *)checkResults;


- (void)setTemperature:(CGFloat)temp pressure:(CGFloat)press;

@end

@interface CarTirePressureViewController : BaseViewController
{
    CarTireCell *_lfTire;
    CarTireCell *_rfTire;
    CarTireCell *_lbTire;
    CarTireCell *_rbTire;
    
    UIImageView *_carImage;
    
    NSMutableArray *_checkArray;
}

- (void)onGetTire:(GetTireResponseBody *)body;

- (NSArray *)checkResults;

@end
