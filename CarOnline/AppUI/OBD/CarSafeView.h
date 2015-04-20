//
//  CarSafeView.h
//  CarOnline
//
//  Created by James on 14-8-31.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CarSafeState)
{
    E_All_Off,              // = 0x0000,
    ECarSafe_RB_On,         // = 0x0001,
    ECarSafe_LB_On,         // = 0x0010,
    ECarSafe_LB_RB_On,      // = 0x0011,
    ECarSafe_RF_On,         // = 0x0100,
    ECarSafe_RF_RB_On,      // = 0x0101,
    ECarSafe_RF_LB_On,      // = 0x0110,
    ECarSafe_RF_LB_RB_On,   // = 0x0111,
    ECarSafe_LF_On,         // = 0x1000,
    ECarSafe_LF_RB_On,      // = 0x1001,
    ECarSafe_LF_LB_On,      // = 0x1010,
    ECarSafe_LF_LB_RB_On,   // = 0x1011,
    ECarSafe_LF_RF_On,      // = 0x1100,
    ECarSafe_LF_RF_RB_On,   // = 0x1101,
    ECarSafe_LF_RF_LB_On,   // = 0x1110,
    ECarSafe_All_On,        // = 0x1111,
};

@interface CarSafeView : UIView
{
@private
    UIImageView *_carImageView;
    UIImageView *_lightImageView;
    UIImageView *_tailBoxImageView;
    UIImageView *_statusImageVie;
}

@property (nonatomic, readonly) UIImageView *carImageView;
@property (nonatomic, readonly) UIImageView *lightImageView;
@property (nonatomic, readonly) UIImageView *tailBoxImageView;

@property (nonatomic, assign) CarSafeState safeSate;

- (void)setVibCar:(UIImage *)image;

- (void)setLock:(BOOL)lock;

@end
