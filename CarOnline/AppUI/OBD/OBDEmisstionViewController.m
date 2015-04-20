//
//  OBDEmisstionViewController.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDEmisstionViewController.h"

@implementation OBDEmisstionAnimationView

- (void)addOwnViews
{
    _bgView = [[UIImageView alloc] init];
    _bgView.image = [UIImage imageNamed:@"VRM_i11_003_GasBlack.png"];
    [self addSubview:_bgView];
    
    _carView = [[UIImageView alloc] init];
    _carView.image = [UIImage imageNamed:@"VRM_i11_008_Car.png"];
    [self addSubview:_carView];
    
    _scanbgView = [[UIImageView alloc] init];
    _scanbgView.image = [UIImage imageNamed:@"VRM_i11_001_ScanBackground.png"];
    [self addSubview:_scanbgView];
    
    _scaningView = [[UIImageView alloc] init];
    _scaningView.image = [UIImage imageNamed:@"VRM_i11_002_ScanCircle.png"];
    [_scanbgView addSubview:_scaningView];
    
    _scanResultView = [[UIImageView alloc] init];
    [_scanbgView addSubview:_scanResultView];
    
}

- (void)configOwnViews
{
    _scanbgView.hidden = YES;
    _scaningView.hidden = YES;
    _scanResultView.hidden = YES;
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    _bgView.frame = rect;
    
    CGSize carSize = _carView.image.size;
    if (CGRectEqualToRect(_carView.frame, CGRectZero))
    {
        [_carView sizeWith:carSize];
        [_carView layoutParentHorizontalCenter];
        [_carView alignParentBottomWithMargin:-carSize.height/2];
    }
    
    
    [_scanbgView sizeWith:_scanbgView.image.size];
    [_scanbgView layoutParentHorizontalCenter];
    [_scanbgView alignParentTopWithMargin:(carSize.height - _scanbgView.image.size.height)/2];
    
    [_scaningView sizeWith:_scaningView.image.size];
    [_scaningView alignParentLeft];
    [_scaningView alignParentBottom];
    
    [_scanResultView sizeWith:_scanResultView.image.size];
    [_scanResultView alignParentCenter];

}

- (void)setIsEmissionNormal:(BOOL)isEmissionNormal
{
    _isEmissionNormal = isEmissionNormal;
    isEmissionNormal = NO;
    _bgView.image = isEmissionNormal ? [UIImage imageNamed:@"VRM_i11_004_GasGreen.png"] : [UIImage imageNamed:@"VRM_i11_005_GasRed.png"];
    UIImage *image = isEmissionNormal ? [UIImage imageNamed:@"VRM_i11_006_PassFlag.png"] : [UIImage imageNamed:@"VRM_i11_007_FaultFlag.png"];
    _scanResultView.hidden = NO;
    _scaningView.hidden = YES;
    _scanResultView.image = image;
    [_scanResultView sizeWith:_scanResultView.image.size];
    [_scanResultView alignParentCenter];
}

- (void)startAnimation
{
    [UIView animateWithDuration:2.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGSize carSize = _carView.image.size;
        [_carView alignParentTopWithMargin:-carSize.height/2];
    } completion:^(BOOL finished) {
        
        [self startScaning];
        
    }];
}

#define kRingRorateAnimation @"RingRorateAnimation"


- (void)startScaning
{
    if (_isScaning)
    {
        return;
    }
    
    _scanbgView.hidden = NO;
    _scaningView.hidden = NO;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.byValue= [NSNumber numberWithFloat:2*M_PI];
    animation.autoreverses = NO;
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = 3;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [_scanbgView.layer addAnimation:animation forKey:kRingRorateAnimation];
}

- (void)onScaningOver
{
    if (self.responseBody)
    {
        [self setIsEmissionNormal:[((GetOBDEmissionResponseBody *)self.responseBody) isEmissionNormal]];
        
        if (self.animationOver)
        {
            self.animationOver();
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self onScaningOver];
}

- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    [super stopAnimation:body completion:block];
    
    if (_isScaning)
    {
        [_scanbgView.layer removeAnimationForKey:kRingRorateAnimation];
        [self onScaningOver];
    }
}


@end

@implementation OBDEmisstionResultView


- (void)addOwnViews
{
    [super addOwnViews];
    
    _emissionResult = [[VehicleEmissionViewController alloc] init];
    [self addSubview:_emissionResult.view];
}

- (void)configOwnViews
{
    [super configOwnViews];
    _resultLabel.text = kOBDEmission_Scaning_Str;
}

- (void)showResult:(BaseResponseBody *)body
{
    [super showResult:body];
    GetOBDEmissionResponseBody *emBody = (GetOBDEmissionResponseBody *)body;
    BOOL isnoraml = [emBody isEmissionNormal];
    _resultLabel.text = isnoraml ? kOBDEmission_EmissionNormal_Str : kOBDEmission_EmissionAbnormal_Str;
    _resultLabel.textColor = isnoraml ? kBlackColor : kRedColor;
    
    [_emissionResult reloadAfterGetOBDEmission:emBody];
}

- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    
    CGRect rect = self.bounds;
    CGRect lrect = _resultLabel.frame;
    
    rect.origin.y = lrect.origin.y + lrect.size.height;
    rect.size.height -= lrect.origin.y + lrect.size.height;
    
    _emissionResult.view.frame = rect;
    [_emissionResult layoutSubviewsFrame];
}

@end



@interface OBDEmisstionViewController ()


@end

@implementation OBDEmisstionViewController

- (Class)animationViewClass
{
    return [OBDEmisstionAnimationView class];
}

- (Class)resultViewClass
{
    return [OBDEmisstionResultView class];
}



- (void)configOwnViews
{
    __weak typeof(self) weakSelf = self;
    GetOBDEmission *goe = [[GetOBDEmission alloc] initWithHandler:^(BaseRequest *request) {
        [weakSelf showResult:request.response.Body];
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:goe wait:NO];
}


@end
