//
//  CarTirePressureViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarTirePressureViewController.h"

@implementation CarTireCell


- (NSArray *)checkResults
{
    return _checkResults;
}

- (void)addOwnViews
{
    _pressure = [[UILabel alloc] init];
    _pressure.font = [UIFont boldSystemFontOfSize:50];
    _pressure.backgroundColor = kClearColor;
    _pressure.textColor = kWhiteColor;
    _pressure.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pressure];
    
    
    _pressureUnit = [[UILabel alloc] init];
    _pressureUnit.font = [UIFont boldSystemFontOfSize:24];
    _pressureUnit.backgroundColor = kClearColor;
    _pressureUnit.textColor = kWhiteColor;
    _pressureUnit.text = kOBDTire_PressUnit_Str;
    _pressureUnit.textAlignment = NSTextAlignmentCenter;
//    _pressureUnit.hidden = YES;
    [self addSubview:_pressureUnit];
    
    _temperature = [[UILabel alloc] init];
    _temperature.font = [UIFont boldSystemFontOfSize:32];
    _temperature.backgroundColor = kClearColor;
    _temperature.textColor = kWhiteColor;
    _temperature.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_temperature];
    
    _temperatureUnit = [[UILabel alloc] init];
    _temperatureUnit.font = [UIFont boldSystemFontOfSize:24];
    _temperatureUnit.backgroundColor = kClearColor;
    _temperatureUnit.textColor = kWhiteColor;
    _temperatureUnit.text = kOBDTire_TempUnit_Str;
    _temperatureUnit.textAlignment = NSTextAlignmentCenter;
//    _temperatureUnit.hidden = YES;
    [self addSubview:_temperatureUnit];
    
    self.backgroundColor = kBlackColor;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    
    //    {"Head":{"ResultCode":"00","ResultInfo":""},"Body":{"Tpms1":35,"Temp1":112,"Tpms2":69,"Temp2":128,"Tpms3":103,"Temp3":144,"Tpms4":137,"Temp4":160}}
    
    _checkResults = [NSMutableArray array];
}

//- (void)setDirection:(CarTireDirection)direction
//{
//    _direction = direction;
//    
//    switch (_direction)
//    {
//        case ECarTire_LeftFront:
//        case ECarTire_LeftBack:
//        {
//            _pressure.textAlignment = NSTextAlignmentLeft;
//            _temperature.textAlignment = NSTextAlignmentLeft;
//        }
//            break;
//        case ECarTire_RightFront:
//        case ECarTire_RightBack:
//        {
//            _pressure.textAlignment = NSTextAlignmentRight;
//            _temperature.textAlignment = NSTextAlignmentRight;
//        }
//            break;
//        default:
//            break;
//    }
//}

- (NSString *)tireName
{
    switch (_direction)
    {
        case ECarTire_LeftFront:
            return kOBDTire_LFTire_Str;
        case ECarTire_LeftBack:
            return kOBDTire_LBTire_Str;
        case ECarTire_RightFront:
            return kOBDTire_RFTire_Str;
        case ECarTire_RightBack:
            return kOBDTire_RBTire_Str;
        default:
            return nil;
    }
}

- (void)setTemperature:(CGFloat)temp pressure:(CGFloat)press
{
    _temperature.text = temp == 0 ? kOBDTire_NoSignal_Str : [NSString stringWithFormat:@"%ld", (long)temp];
    _pressure.text = press == 0 ? kOBDTire_NoSignal_Str : [NSString stringWithFormat:@"%ld", (long)press];
    
//    _temperatureUnit.hidden = temp == 0;
//    _pressureUnit.hidden = press == 0;
    
    
    NSString *tireName = [self tireName];
    if (temp == 0 || press == 0) {
        KeyValue *kv = [KeyValue key:tireName value:kOBDTire_NoSignalTip_Str];
        [_checkResults addObject:kv];
        self.backgroundColor = [UIColor redColor];
    }

    
    NSString *tempExce = nil;
    if (temp > 85)
    {
        tempExce = kOBDTire_TempTooHigh_Str;
    }
    
    // 先检查温度
    NSString *pressExce = nil;
    if (press < 1.6 && press != 0)
    {
        pressExce = kOBDTire_PressTooLow_Str;
    }
    else if (press > 2.5)
    {
        pressExce = kOBDTire_PressTooHigh_Str;
    }
    

    if (![NSString isEmpty:tempExce] || ![NSString isEmpty:pressExce]) {
        self.backgroundColor = [UIColor redColor];
    }
    
    if (![NSString isEmpty:pressExce])
    {
        _pressure.textColor = kWhiteColor;
        _pressureUnit.textColor = kWhiteColor;
//        [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
//            _pressure.alpha = 0.5;
//        } completion:^(BOOL finished) {
//            _pressure.alpha = 1;
//        }];
        KeyValue *kv = [KeyValue key:tireName value:pressExce];
        [_checkResults addObject:kv];
    }

    
    if (![NSString isEmpty:tempExce])
    {
        _temperature.textColor = kWhiteColor;
        _temperatureUnit.textColor = kWhiteColor;
//        [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
//            _temperature.alpha = 0.5;
//        } completion:^(BOOL finished) {
//            _temperature.alpha = 1;
//        }];
        
        KeyValue *kv = [KeyValue key:tireName value:tempExce];
        [_checkResults addObject:kv];
    }
    
    
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    
    CGRect bounds = self.bounds;
    bounds.size.height = bounds.size.width;
//    bounds = CGRectInset(bounds, 5, 0);
    CGSize pressureSize = [_pressure textSizeIn:bounds.size];
    CGSize pressureUnitSize = [_pressureUnit textSizeIn:bounds.size];
    
    CGSize temperatureSize = [_temperature textSizeIn:bounds.size];
    CGSize temperatureUnitSize = [_temperatureUnit textSizeIn:bounds.size];
    
    
    CGFloat yOff = bounds.size.height/8;
    CGFloat xPOff = 0; //(bounds.size.width - pressureSize.width)/2;
    CGFloat xTOff = 0; //(bounds.size.width - temperatureSize.width)/2;
    
    CGFloat margin = 10;
    
    
    CGFloat backYOff = self.bounds.size.height/2 - self.bounds.size.width/2;
    
    switch (_direction)
    {
        case ECarTire_LeftFront:
        {
            
            [_pressure sizeWith:pressureSize];
            [_pressure alignParentCenter:CGPointMake(-xPOff, -yOff)];
            [_pressure alignParentLeftWithMargin:margin];
            
            [_pressureUnit sizeWith:pressureUnitSize];
            [_pressureUnit layoutToRightOf:_pressure];
            [_pressureUnit alignTop:_pressure];
            
            [_temperature sizeWith:temperatureSize];
            [_temperature alignParentCenter:CGPointMake(-xTOff, yOff)];
            [_temperature alignParentLeftWithMargin:margin];
            
            [_temperatureUnit sizeWith:temperatureUnitSize];
            [_temperatureUnit layoutToRightOf:_temperature];
            [_temperatureUnit alignTop:_temperature];

        }
            break;
        case ECarTire_RightFront:
        {
            [_pressure sizeWith:pressureSize];
            [_pressure alignParentCenter:CGPointMake(xPOff, -yOff)];
            
            [_pressureUnit sizeWith:pressureUnitSize];
            [_pressureUnit layoutToRightOf:_pressure];
            [_pressureUnit alignTop:_pressure];
            
            [_pressureUnit alignParentRightWithMargin:margin];
            [_pressure layoutToLeftOf:_pressureUnit];
            
            
            [_temperature sizeWith:temperatureSize];
            [_temperature alignParentCenter:CGPointMake(xTOff, yOff)];
            
            [_temperatureUnit sizeWith:temperatureUnitSize];
            [_temperatureUnit layoutToRightOf:_temperature];
            [_temperatureUnit alignTop:_temperature];
            
            [_temperatureUnit alignParentRightWithMargin:margin];
            [_temperature layoutToLeftOf:_temperatureUnit];
        }
            break;
        case ECarTire_LeftBack:
        {
            [_temperature sizeWith:temperatureSize];
            [_temperature alignParentCenter:CGPointMake(-xTOff, -yOff)];
            [_temperature alignParentLeftWithMargin:margin];
            
            [_temperatureUnit sizeWith:temperatureUnitSize];
            [_temperatureUnit layoutToRightOf:_temperature];
            [_temperatureUnit alignTop:_temperature];
            
            
            [_pressure sizeWith:pressureSize];
            [_pressure alignParentCenter:CGPointMake(-xPOff, yOff)];
            [_pressure alignParentLeftWithMargin:margin];
            
            [_pressureUnit sizeWith:pressureUnitSize];
            [_pressureUnit layoutToRightOf:_pressure];
            [_pressureUnit alignBottom:_pressure];
            
            
            CGPoint c = _temperature.center;
            c.y -= backYOff;
            _temperature.center = c;
            
            c = _temperatureUnit.center;
            c.y -= backYOff;
            _temperatureUnit.center = c;
            
            c = _pressure.center;
            c.y -= backYOff;
            _pressure.center = c;
            
            c = _pressureUnit.center;
            c.y -= backYOff;
            _pressureUnit.center = c;
        }
            break;
        case ECarTire_RightBack:
        {
            [_temperature sizeWith:temperatureSize];
            [_temperature alignParentCenter:CGPointMake(xTOff, -yOff)];
            
            [_temperatureUnit sizeWith:temperatureUnitSize];
            [_temperatureUnit layoutToRightOf:_temperature];
            [_temperatureUnit alignTop:_temperature];
            
            [_temperatureUnit alignParentRightWithMargin:margin];
            [_temperature layoutToLeftOf:_temperatureUnit];
            
            [_pressure sizeWith:pressureSize];
            [_pressure alignParentCenter:CGPointMake(xPOff, yOff)];
            
            [_pressureUnit sizeWith:pressureUnitSize];
            [_pressureUnit layoutToRightOf:_pressure];
            [_pressureUnit alignBottom:_pressure];
            
            [_pressureUnit alignParentRightWithMargin:margin];
            [_pressure layoutToLeftOf:_pressureUnit];
            
            CGPoint c = _temperature.center;
            c.y -= backYOff;
            _temperature.center = c;
            
            c = _temperatureUnit.center;
            c.y -= backYOff;
            _temperatureUnit.center = c;
            
            c = _pressure.center;
            c.y -= backYOff;
            _pressure.center = c;
            
            c = _pressureUnit.center;
            c.y -= backYOff;
            _pressureUnit.center = c;
            
            
        }
            break;
            
        default:
            break;
    }
}


@end

//============================

@interface CarTirePressureViewController ()

@end

@implementation CarTirePressureViewController


- (void)addOwnViews
{
    _lfTire = [[CarTireCell alloc] init];
    _lfTire.direction = ECarTire_LeftFront;
    [self.view addSubview:_lfTire];
    
    _rfTire = [[CarTireCell alloc] init];
    _rfTire.direction = ECarTire_RightFront;
    [self.view addSubview:_rfTire];
    
    _lbTire = [[CarTireCell alloc] init];
    _lbTire.direction = ECarTire_LeftBack;
    [self.view addSubview:_lbTire];
    
    _rbTire = [[CarTireCell alloc] init];
    _rbTire.direction = ECarTire_RightBack;
    [self.view addSubview:_rbTire];
    
    _carImage = [[UIImageView alloc] init];
    _carImage.image = [UIImage imageNamed:@"VRM_i17_001_TPMSCar.png"];
    [self.view addSubview:_carImage];
}



- (void)onGetTire:(GetTireResponseBody *)body
{
    _checkArray = [NSMutableArray array];
    
    [_lfTire setTemperature:body.Temp1 pressure:body.Tpms1];
    [_checkArray addObjectsFromArray:_lfTire.checkResults];

    
    [_rfTire setTemperature:body.Temp2 pressure:body.Tpms2];
    [_checkArray addObjectsFromArray:_rfTire.checkResults];
    
    [_lbTire setTemperature:body.Temp3 pressure:body.Tpms3];
    [_checkArray addObjectsFromArray:_lbTire.checkResults];
    
    [_rbTire setTemperature:body.Temp4 pressure:body.Tpms4];
    [_checkArray addObjectsFromArray:_rbTire.checkResults];
}

- (NSArray *)checkResults
{
    return _checkArray;
}

- (void)layoutOnIPhone
{
    CGRect bounds = self.view.bounds;
    
    CGSize size = bounds.size;
    
    CGSize frontSize = size;
    frontSize.width /= 2;
    frontSize.height = frontSize.width;
    [_lfTire sizeWith:frontSize];
    [_lfTire relayoutFrameOfSubViews];
    
    [_rfTire sameWith:_lfTire];
    [_rfTire layoutToRightOf:_lfTire];
    [_rfTire relayoutFrameOfSubViews];
    
    
    CGSize backSize = frontSize;
    backSize.height = size.height - frontSize.height;
    
    [_lbTire sizeWith:backSize];
    [_lbTire layoutBelow:_lfTire];
    [_lbTire relayoutFrameOfSubViews];
    
    [_rbTire sameWith:_lbTire];
    [_rbTire layoutToRightOf:_lbTire];
    [_rbTire relayoutFrameOfSubViews];
    
    [_carImage sizeWith:_carImage.image.size];
    CGRect lfFrame = _lfTire.frame;
    _carImage.center = CGPointMake(lfFrame.origin.x + lfFrame.size.width, lfFrame.origin.y + lfFrame.size.height);
}


@end
