//
//  OBDDataViewController.m
//  CarOnline
//
//  Created by James on 14-11-12.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDDataViewController.h"

@implementation OBDDataResultView

//- (BOOL)isEnableExpand
//{
//    return _monitorResults.data.count > 0;
//}

- (void)addOwnViews
{
    [super addOwnViews];
    
    _monitorResults = [[CarDataMonitorViewController alloc] init];
    [self addSubview:_monitorResults.view];
}

- (NSArray *)monitorResult
{
    return _monitorResults.data;
}

- (void)configOwnViews
{
    [super configOwnViews];
    _resultLabel.text = kOBDData_Scaning_Str;
}


- (void)showResult:(BaseResponseBody *)body
{
    [super showResult:body];
    
    [_monitorResults reloadAfterGetOBDData:(GetOBDDataResponseBody *)body];
    BOOL isnoraml = [_monitorResults isMonitorNormal];
    _resultLabel.text = isnoraml ? kOBDData_Normal_Str : kOBDData_Abnormal_Str;
    _resultLabel.textColor = isnoraml ? kBlackColor : kRedColor;
    
//    if (!self.isExpand)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            CGRect rect = self.frame;
//            rect.origin.y -= [self expandHeight] - [self unexpandHeight];
//            self.frame = rect;
//            
//        } completion:^(BOOL finished) {
//            self.isExpand = YES;
//        }];
//    }
    
}

- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    
    CGRect rect = self.bounds;
    CGRect lrect = _resultLabel.frame;
    
    rect.origin.y = lrect.origin.y + lrect.size.height;
    rect.size.height -= lrect.origin.y + lrect.size.height;
    
    _monitorResults.view.frame = rect;
    [_monitorResults layoutSubviewsFrame];
}
@end

@implementation OBDDataAnimationView


#define kMinRorateAngle (-M_PI*25/96)

- (void)addOwnViews
{
    _background = [[UIImageView alloc] init];
    if ([IOSDeviceConfig sharedConfig].isIPhone4)
    {
        _background.image = [UIImage imageNamed:@"obd_bg_4.jpg"];
    }
    else
    {
        _background.image = [UIImage imageNamed:@"obd_bg_5.jpg"];
    }
    [self addSubview:_background];
    
    _carMeter = [[UIImageView alloc] init];
    _carMeter.image = [UIImage imageNamed:@"VRM_i14_001_CarMeter.png"];
    [self addSubview:_carMeter];
    
    UIFont *font = [UIFont fontWithName:@"Qhytsdakx" size:8];
    if (!font)
    {
        font = [UIFont systemFontOfSize:6];
    }
    
    _tempPressValue = [[UILabel alloc] init];
    
    
    _tempPressValue.font = font;
    _tempPressValue.textColor = kWhiteColor;
    _tempPressValue.textAlignment = NSTextAlignmentCenter;
    [_carMeter addSubview:_tempPressValue];
    
    _mileGasValue = [[UILabel alloc] init];
    _mileGasValue.font = font;
    _mileGasValue.textColor = kWhiteColor;
    _mileGasValue.textAlignment = NSTextAlignmentCenter;
    [_carMeter addSubview:_mileGasValue];
    
    
    _speedPointer = [[UIImageView alloc] init];
    _speedPointer.image = [UIImage imageNamed:@"VRM_i14_002_Pointer.png"];
    [_carMeter addSubview:_speedPointer];
    
    _speedPointer.frame = CGRectFromCGSize(_speedPointer.image.size);
    _speedPointer.center = CGPointMake(90, 91);
    _speedPointer.layer.anchorPoint = CGPointMake(0.9, 0.5);
    _speedPointer.layer.transform = CATransform3DMakeRotation(kMinRorateAngle, 0, 0, 1);
    
    _warning = [[UIImageView alloc] init];
    _warning.image = [UIImage imageNamed:@"VRM_i14_003_DTCCodeWarning.png"];
    [_carMeter addSubview:_warning];
    
    _water = [[UIImageView alloc] init];
    _water.image = [UIImage imageNamed:@"VRM_i14_004_WaterTemperature.png"];
    [_carMeter addSubview:_water];
    
    
    
    UIFont *font8 = [UIFont fontWithName:@"Qhytsdakx" size:10];
    if (!font8)
    {
        font8 = [UIFont systemFontOfSize:8];
    }

    _waterValue = [[UILabel alloc] init];
    _waterValue.font = font8;
    _waterValue.textColor = kWhiteColor;
    _waterValue.textAlignment = NSTextAlignmentRight;
    _waterValue.adjustsFontSizeToFitWidth = YES;
    [_carMeter addSubview:_waterValue];
    
    _battery = [[UIImageView alloc] init];
    _battery.image = [UIImage imageNamed:@"VRM_i14_005_BatteryVoltage.png"];
    [_carMeter addSubview:_battery];
    
    _batteryValue = [[UILabel alloc] init];
    _batteryValue.font = font8;
    _batteryValue.textColor = kWhiteColor;
    _batteryValue.textAlignment = NSTextAlignmentRight;
    _batteryValue.adjustsFontSizeToFitWidth = YES;
    [_carMeter addSubview:_batteryValue];
    
    _rotatePointer = [[UIImageView alloc] init];
    _rotatePointer.image = [UIImage imageNamed:@"VRM_i14_002_Pointer.png"];
    _rotatePointer.contentMode = UIViewContentModeCenter;
    [_carMeter addSubview:_rotatePointer];
    
//    _rotatePointer.layer.anchorPoint = CGPointMake(0.9, 0.5);
    _rotatePointer.frame = CGRectFromCGSize(_rotatePointer.image.size);
    _rotatePointer.center = CGPointMake(_carMeter.image.size.width - 88, 91);
    _rotatePointer.layer.anchorPoint = CGPointMake(0.9, 0.5);
    _rotatePointer.layer.transform = CATransform3DMakeRotation(kMinRorateAngle, 0, 0, 1);
    
    
    UIFont *font12 = [UIFont fontWithName:@"Qhytsdakx" size:14];
    if (!font12)
    {
        font12 = [UIFont systemFontOfSize:12];
    }

    _vin = [[UILabel alloc] init];
    _vin.font = font12;
    _vin.backgroundColor = kClearColor;
    _vin.textAlignment = NSTextAlignmentCenter;
    _vin.textColor = [kLightGrayColor colorWithAlphaComponent:0.5];
    [self addSubview:_vin];
    
    _startRorate = _speedPointer.transform;
}


- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    
    _background.frame = self.bounds;
    
    [_carMeter sizeWith:_carMeter.image.size];
    [_carMeter layoutParentHorizontalCenter];
    [_carMeter alignParentTopWithMargin:20];
    
    [_tempPressValue sizeWith:CGSizeMake(50, 10)];
    [_tempPressValue layoutParentHorizontalCenter];
    [_tempPressValue alignParentTopWithMargin:32];
    
    [_mileGasValue sizeWith:CGSizeMake(45, 12)];
    [_mileGasValue layoutParentHorizontalCenter];
    [_mileGasValue layoutBelow:_tempPressValue margin:4];
    
    [_warning sizeWith:_warning.image.size];
    [_warning layoutParentHorizontalCenter];
    [_warning alignParentTopWithMargin:60];
    
    // 2 9 2 9 2 15
    [_water sizeWith:_water.image.size];
    [_water alignParentBottomWithMargin:28];
    [_water layoutParentHorizontalCenter];
    [_water move:CGPointMake(-(20 - 7 - 2), 0)];
    
    [_waterValue sizeWith:CGSizeMake(24, 12)];
    [_waterValue alignCenterOf:_water];
    [_waterValue layoutToRightOf:_water];

    [_battery sizeWith:_battery.image.size];
    [_battery alignCenterOf:_water];
    [_battery layoutBelow:_water margin:2];
    
    [_batteryValue sizeWith:CGSizeMake(24, 12)];
    [_batteryValue alignCenterOf:_battery];
    [_batteryValue layoutToRightOf:_battery];
    
//    CGSize spSize = _speedPointer.image.size;
//    [_speedPointer sizeWith:spSize];
//    [_speedPointer moveCenterTo:CGPointMake(91, 91)];
//    [_speedPointer move:CGPointMake(-(spSize.width/2 - 8), 0)];
    
//    CGSize rpSize = _rotatePointer.image.size;
//    [_rotatePointer sizeWith:rpSize];
//    [_rotatePointer moveCenterTo:CGPointMake(_carMeter.image.size.width - 87, 91)];
//    [_rotatePointer move:CGPointMake(-(rpSize.width/2 - 8), 0)];
    
    
    [_vin sizeWith:CGSizeMake(_carMeter.image.size.width, 20)];
    [_vin layoutParentHorizontalCenter];
    [_vin layoutBelow:_carMeter];
    
//    if (!_isInitial)
//    {
//        _isInitial = YES;
//        _speedPointer.layer.transform = CATransform3DMakeRotation(-M_PI*3/8, 0, 0, 1);
//        _speedPointer.layer.position = CGPointMake(91, 91);
////        CGAffineTransformRotate(_speedPointer.transform, -M_PI*5/8);
////        _rotatePointer.transform = CGAffineTransformRotate(_speedPointer.transform, -M_PI*5/8);
//    }
}


- (void)startAnimation
{
//    _speedPointer.transform = CGAffineTransformMakeRotation(5*M_PI/6);
    
    
//    CGSize size = _speedPointer.image.size;
//    CGFloat x = (size.width - 8)/size.width;
//    _speedPointer.layer.anchorPoint = CGPointMake(x, 0.5);
//    _rotatePointer.layer.anchorPoint = CGPointMake(x, 0.5);
    
    
//    _speedPointer.layer.transform = CATransform3DMakeRotation(5*M_PI/6 , 0, 0, 1);
//        _rotatePointer.layer.transform = CATransform3DMakeRotation(-5*M_PI/6 , 0, 0, 1);
//    return;
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.byValue= [NSNumber numberWithFloat:2*M_PI];
//    animation.
//    animation.autoreverses = YES;
//    animation.duration = 1;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.repeatCount = 3;
//    animation.removedOnCompletion = NO;
//    animation.delegate = self;
//    [_scanbgView.layer addAnimation:animation forKey:kRingRorateAnimation];
    
    
    
//    
//    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//    scale.duration = 3;
//    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
//                    [NSNumber numberWithFloat:1.2f],
//                    [NSNumber numberWithFloat:.85f],
//                    [NSNumber numberWithFloat:1.f],
//                    nil];
//    
//    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeIn.duration = duration * .4f;
//    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
//    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
//    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    fadeIn.fillMode = kCAFillModeForwards;
    
    
}

- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    [super stopAnimation:body completion:block];
    
    GetOBDDataResponseBody *data = (GetOBDDataResponseBody *)body;
    _vin.text = data.VIN;
    
    
    // TODO:设置信息
    
    if (block)
    {
        block();
    }
}

- (CGFloat)getValueFrom:(NSString *)str
{
    if ([NSString isEmpty:str])
    {
        return 0;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    CGFloat number;
    [scanner scanFloat:&number];
    return number;
    
//    NSRange range = [string rangeOfString:@"(?:[^,])*\\." options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound) {
//        NSLog(@"%@", [searchText substringWithRange:range]);
//    }
//    options中设定NSRegularExpressionSearch就是表示利用正则表达式匹配，会返回第一个匹配结果的位置。
}

- (void)setMonitorResultEffect:(NSArray *)array
{
    
    NSMutableDictionary *reDic = [NSMutableDictionary dictionary];
    for (KeyValue *kv in array)
    {
        [reDic setObject:kv.value forKey:kv.key];
    }
    
//    1
//    0x0D
//    车速
//    左边指针:进入界面指针从 0 转到当 前值的角度,后面数据一旦变化就缓 慢旋转到更新值。(不能一次变化到 某个新的角度)
    NSString *speedStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x0D]];
    CGFloat speed = [self getValueFrom:speedStr];
    if (speed > 260)
    {
        speed = 260;
    }
    
    CGFloat speedByValue = (speed * 96 * M_PI)/(71*260);
    
    CGAffineTransform speedTo = CGAffineTransformRotate(_startRorate, speedByValue);
    if (!CGAffineTransformEqualToTransform(_speedPointer.transform, speedTo)) {
        [UIView animateWithDuration:2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            _speedPointer.transform = speedTo;
        }];
    }
    
    
    
//    2
//    0x0C
//    发动机转速
//    右边指针:效果同上
    NSString *rorateStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x0C]];
    CGFloat rorate = [self getValueFrom:rorateStr];
    if (rorate > 8000)
    {
        rorate = 8000;
    }
    
    CGFloat rorateByValue = (rorate * 96 * M_PI)/(71*8*1000);
    CGAffineTransform rorateTo = CGAffineTransformRotate(_startRorate, rorateByValue);
    if (!CGAffineTransformEqualToTransform(_rotatePointer.transform, rorateTo)) {
        [UIView animateWithDuration:2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            _rotatePointer.transform = rorateTo;
        }];
    }
    
    
    
    
//    3
//    0x35
//    大气温度
    
    
//    4
//    0x28
//    大气压力
    
    NSString *tempStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x35]];
    NSString *pressStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x28]];
    CGFloat temp = [self getValueFrom:tempStr];
    CGFloat press = [self getValueFrom:pressStr];
    NSString *tempV = (int)temp == 0 ? @"--" : [NSString stringWithFormat:@"% 5d", (int)temp];
    NSString *pressV = (int)press == 0 ? @"--" : [NSString stringWithFormat:@"% 4d", (int)press];
    
    NSString *tpValue = [NSString stringWithFormat:@"%@ ℃ %@ kPa", tempV, pressV];
    _tempPressValue.text = tpValue;
    
//    5
//    0x94
//    本次里程
//    6
//    0x8C
//    本次油耗
    
    NSString *mileStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x94]];
    NSString *gasStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x8C]];
    CGFloat mile = [self getValueFrom:mileStr];
    
    
    if (mile > 9999)
    {
        mile -= 9999;
    }
    
    CGFloat gas = [self getValueFrom:gasStr];
    
    if (gas > 999)
    {
        gas -= 999;
    }
    
    NSString *mgValue = [NSString stringWithFormat:@"% 4d km % 3d L", (int)mile, (int)gas];
    _mileGasValue.text = mgValue;
//    7
//    0x01
//    故障码个数
//    不为零则显示红色倒三角“!”符号, 为零则不显示
    NSString *errStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x01]];
    NSInteger err = (NSInteger)[self getValueFrom:errStr];
    _warning.hidden = err == 0;
    
//    8
//    0x03
//    发动机冷却温度
//    大于 100°C,字体显示红色
    NSString *wtStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x03]];
    CGFloat wtv = [self getValueFrom:wtStr];
    _waterValue.textColor = wtv > 100 ? kRedColor : kWhiteColor;
    _waterValue.text = [NSString stringWithFormat:@"%4d ℃", (int)wtv];
    
//    9
//    0x99
//    电池电压
//    小于 12.0V,字体显示红色
//    10
    NSString *btStr = [reDic objectForKey:[NSString stringWithFormat:@"%d", 0x99]];
    CGFloat btv = [self getValueFrom:btStr];
    _batteryValue.textColor = btv < 12 ? kRedColor : kWhiteColor;
    _batteryValue.text = [NSString stringWithFormat:@"%4d V", (int)btv];
    
//    无
//    VIN 码
//    汽车VIN码
}

@end

@interface OBDDataViewController ()

@property (nonatomic, strong) NSTimer *requestTimer;

@end

@implementation OBDDataViewController

- (Class)animationViewClass
{
    return [OBDDataAnimationView class];
}

- (Class)resultViewClass
{
    return [OBDDataResultView class];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.requestTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(configOwnViews) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.requestTimer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.requestTimer invalidate];
    self.requestTimer = nil;
}


- (void)configOwnViews
{
    __weak typeof(self) we = self;
    GetOBDData *god = [[GetOBDData alloc] initWithHandler:^(BaseRequest *request) {
//        GetOBDDataResponseBody *data = (GetOBDDataResponseBody *)request.response.Body;
//        [we reloadAfterGetOBDData:data];
        [we showResult:request.response.Body];
    }];
    
    [[WebServiceEngine sharedEngine] asyncRequest:god wait:NO];
    
}


- (void)showResult:(BaseResponseBody *)body
{
    __weak typeof(_resultView) wr = _resultView;
    
    __weak typeof(_animationView) wa = _animationView;
    [_animationView stopAnimation:body completion:^{
        [wr showResult:body];
        
        NSArray *array = [(OBDDataResultView *)wr monitorResult];
        [(OBDDataAnimationView *)wa setMonitorResultEffect:array];
    }];
    
}

- (void)addOwnViews
{
    [super addOwnViews];
    [_resultView setIsExpand:YES];
}

@end
