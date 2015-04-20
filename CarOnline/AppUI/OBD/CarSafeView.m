//
//  CarSafeView.m
//  CarOnline
//
//  Created by James on 14-8-31.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarSafeView.h"

@implementation CarSafeView

- (void)addOwnViews
{
    _carImageView = [[UIImageView alloc] init];
    [self addSubview:_carImageView];
    
    _lightImageView = [[UIImageView alloc] init];
    _lightImageView.image = [UIImage imageNamed:@"car_light.png"];
    _lightImageView.hidden = YES;
    [self addSubview:_lightImageView];
    
    _tailBoxImageView = [[UIImageView alloc] init];
    _tailBoxImageView.image = [UIImage imageNamed:@"car_tailBox.png"];
    _tailBoxImageView.hidden = YES;
    [self addSubview:_tailBoxImageView];
    
    _statusImageVie = [[UIImageView alloc] init];
    _statusImageVie.highlightedImage = [UIImage imageNamed:@"car_status_lock.png"];
    _statusImageVie.image = [UIImage imageNamed:@"car_status_unlock.png"];
    _statusImageVie.highlighted = NO;
    [self addSubview:_statusImageVie];
}

- (void)configOwnViews
{
    _carImageView.image = [self safeImageOf:_safeSate];
}

- (void)setLock:(BOOL)lock
{
    _statusImageVie.highlighted = !lock;
}

- (void)setVibCar:(UIImage *)image
{
    _carImageView.image = image;
    [self relayoutFrameOfSubViews];
}

- (UIImage *)safeImageOf:(CarSafeState)state
{
    switch (state)
    {
        case E_All_Off:
            return [UIImage imageNamed:@"carsafe_all_off.png"];
            break;
            
        case ECarSafe_LF_On:
            return [UIImage imageNamed:@"caresafe_lf_on.png"];
            break;
            
        case ECarSafe_LB_On:
            return [UIImage imageNamed:@"carsafe_lb_on.png"];
            break;
            
        case ECarSafe_RF_On:
            return [UIImage imageNamed:@"carsafe_rf_on.png"];
            break;
            
        case ECarSafe_RB_On:
            return [UIImage imageNamed:@"carsafe_rb_on.png"];
            break;
            
        case ECarSafe_LF_RF_On:
            return [UIImage imageNamed:@"carsafe_lf_rf_on.png"];
            break;
            
        case ECarSafe_LF_LB_On:
            return [UIImage imageNamed:@"carsafe_lf_lb_on.png"];
            break;
            
        case ECarSafe_LF_RB_On:
            return [UIImage imageNamed:@"carsafe_lf_rb_on.png"];
            break;
            
        case ECarSafe_RF_LB_On:
            return [UIImage imageNamed:@"caresafe_rf_lb_on.png"];
            break;
            
        case ECarSafe_RF_RB_On:
            return [UIImage imageNamed:@"carsafe_rf_rb_on.png"];
            break;
            
        case ECarSafe_LB_RB_On:
            return [UIImage imageNamed:@"carsafe_lb_rb_on.png"];
            break;
            
        case ECarSafe_LF_RF_LB_On:
            return [UIImage imageNamed:@"carsafe_lf_rf_lb_on.png"];
            break;
            
        case ECarSafe_LF_RF_RB_On:
            return [UIImage imageNamed:@"carsafe_lf_rf_rb_on.png"];
            break;
            
        case ECarSafe_LF_LB_RB_On:
            return [UIImage imageNamed:@"carsafe_lf_lb_rb_on.png"];
            break;
            
        case ECarSafe_RF_LB_RB_On:
            return [UIImage imageNamed:@"carsafe_rf_lb_rb_on.ong"];
            break;
            
        case ECarSafe_All_On:
            return [UIImage imageNamed:@"carsafe_all_on.png"];
            break;
        default:
            return nil;

    }
    return nil;
    
}

- (void)setSafeSate:(CarSafeState)safeSate
{    
    _safeSate = safeSate;
    UIImage *iamge = [self safeImageOf:safeSate];
    if (iamge)
    {
        _carImageView.image = iamge;
        [self relayoutFrameOfSubViews];
    }
}

#define kCarSize CGSizeMake(240, 291)

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    const CGSize carSize = _carImageView.image.size;
    rect = CGRectInset(rect, (rect.size.width - carSize.width)/2, (rect.size.height - carSize.height)/2);
    
    _carImageView.frame = rect;
    
    [_lightImageView sizeWith:CGSizeMake(110, 33)];
    [_lightImageView alignTop:_carImageView];
    [_lightImageView layoutParentHorizontalCenter];
    
    [_tailBoxImageView sizeWith:CGSizeMake(78, 18)];
    [_tailBoxImageView alignBottom:_carImageView];
    [_tailBoxImageView layoutParentHorizontalCenter];
    
    [_statusImageVie sizeWith:CGSizeMake(28, 28)];
    [_statusImageVie layoutParentCenter];
}



@end
