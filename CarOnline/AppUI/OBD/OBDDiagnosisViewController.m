//
//  OBDDiagnosisViewController.m
//  CarOnline
//
//  Created by James on 14-11-11.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDDiagnosisViewController.h"

@implementation OBDDignosisAnimationView

- (void)addOwnViews
{
    _isScaning = YES;
    _bgView = [[UIImageView alloc] init];
    _bgView.backgroundColor = kBlackColor;;
    [self addSubview:_bgView];
    
    _engineView = [[UIImageView alloc] init];
    _engineView.image = [UIImage imageNamed:@"VRM_i13_002_CarFrame.png"];
    [self addSubview:_engineView];
    
//    _engineMask = [[UIImageView alloc] init];
//    _engineMask.opaque = NO;
//    _engineMask.image = [UIImage imageNamed:@"VRM_i11_001_ScanBackground.png"];
//    _engineMask.backgroundColor = kRedColor;
//    [self addSubview:_engineMask];
    
    
    _carView = [[UIImageView alloc] init];
    _carView.image = [UIImage imageNamed:@"VRM_i11_008_Car.png"];
    [self addSubview:_carView];
    
    
    
    _scanbgView = [[UIImageView alloc] init];
    _scanbgView.image = [UIImage imageNamed:@"VRM_i11_001_ScanBackground.png"];
    [self addSubview:_scanbgView];
    
    _scaningView = [[UIImageView alloc] init];
    _scaningView.image = [UIImage imageNamed:@"VRM_i13_001_ScanBar.png"];
    [self addSubview:_scaningView];
    
    _scanResultView = [[UIImageView alloc] init];
    [_scanbgView addSubview:_scanResultView];
    
}

- (void)configOwnViews
{
    
    _carView.alpha = 0.9;
    
    _engineView.hidden = YES;
    _scanbgView.hidden = YES;
//    _scaningView.hidden = YES;
    _scanResultView.hidden = YES;
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    _bgView.frame = rect;
    
    
    CGSize carSize = _carView.image.size;
    [_carView sizeWith:carSize];
    [_carView layoutParentHorizontalCenter];
    [_carView alignParentTopWithMargin:30];
    
    [_engineView sizeWith:_engineView.image.size];
    [_engineView alignCenterOf:_carView];
    
//    [_engineMask sameWith:_engineView];
//    _engineMask.alpha = 1;
//    _engineMask.opaque = YES;
    
    [_scanbgView sizeWith:_scanbgView.image.size];
    [_scanbgView layoutParentHorizontalCenter];
    _scanbgView.center = _carView.center;

    CGSize size = _scaningView.image.size;
    _scaningView.frame = CGRectMake(0, -size.height, size.width, size.height);
    [_scaningView layoutParentHorizontalCenter];

    
    [_scanResultView sizeWith:_scanResultView.image.size];
    [_scanResultView alignParentCenter];
    
}

- (void)setIsDignosisNormal:(BOOL)isDignosisNormal
{
    _isDignosisNormal = isDignosisNormal;
    _bgView.backgroundColor = isDignosisNormal ? kGreenColor : kRedColor;
    UIImage *image = isDignosisNormal ? [UIImage imageNamed:@"VRM_i11_006_PassFlag.png"] : [UIImage imageNamed:@"VRM_i11_007_FaultFlag.png"];
    _scanbgView.hidden = NO;
    _scanResultView.hidden = NO;
    _scaningView.hidden = YES;
    _scanResultView.image = image;
    [_scanResultView sizeWith:_scanResultView.image.size];
    [_scanResultView alignParentCenter];
}

#define kScaningAnimation @"ScaningAnimation"

- (void)startAnimation
{
    CGRect rect = _scaningView.frame;
    _scanbgView.alpha = 0.6;
//    CGRect maskRect = _engineMask.frame;
    
    
    CGRect engEndRect = _engineView.frame;
    _engineView.contentMode = UIViewContentModeTop;
    _engineView.clipsToBounds = YES;
    CGRect engStartRect = engEndRect;
    engStartRect.size.height = 1;
    _engineView.frame = engStartRect;
    
    _engineView.hidden = NO;
    
    [UIView animateWithDuration:3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _scaningView.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
        
        _carView.alpha = 0.5;
    } completion:^(BOOL finished) {
        _isScaning = NO;
        [self stopAnimation:self.responseBody completion:self.animationOver];
        
    }];
    
    [UIView animateWithDuration:1.6 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        _engineView.frame = engEndRect;
    } completion:nil];
    
    
    
    

    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.fromValue = [NSValue valueWithCGPoint:_scaningView.layer.position];
//    animation.toValue = [NSValue valueWithCGPoint:self.layer.position];
//    animation.autoreverses = NO;
//    animation.duration = 3;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.repeatCount = HUGE_VAL;
//    animation.removedOnCompletion = YES;
//    [_scaningView.layer addAnimation:animation forKey:kScaningAnimation];
}



- (void)onScaningOver
{
    if (self.responseBody)
    {
        if (self.animationOver)
        {
            self.animationOver();
        }
    }
}

- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    [super stopAnimation:body completion:block];
    
//    CGRect rect = _scaningView.frame;
    if (!_isScaning)
    {
        [self onScaningOver];
    }
}


@end

@implementation OBDDignosisResultView


//- (BOOL)isEnableExpand
//{
//    return _diagnosisResult.data.count > 0;
//}

- (void)addOwnViews
{
    [super addOwnViews];
    
    _diagnosisResult = [[CarDiagnosisViewController alloc] init];
    [self addSubview:_diagnosisResult.view];
}

- (void)configOwnViews
{
    [super configOwnViews];
    _resultLabel.text = kOBDDiagnosis_Scaning_Str;
}

- (void)showResult:(BaseResponseBody *)body
{
    [super showResult:body];
    
    GetOBDFaultResponseBody *fbody = (GetOBDFaultResponseBody *)body;

    [_diagnosisResult reloadAfterGetOBDFault:fbody];
    
    BOOL isnoraml = [_diagnosisResult isDiagnosisNoraml];
    _resultLabel.text = isnoraml ? kOBDDiagnosis_DiagnosisNormal_Str : kOBDDiagnosis_DiagnosisAbnormal_Str;
    _resultLabel.textColor = isnoraml ? kBlackColor : kRedColor;
}

- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    
    CGRect rect = self.bounds;
    CGRect lrect = _resultLabel.frame;
    
    rect.origin.y = lrect.origin.y + lrect.size.height;
    rect.size.height -= lrect.origin.y + lrect.size.height;
    
    _diagnosisResult.view.frame = rect;
    [_diagnosisResult layoutSubviewsFrame];
}

- (BOOL)isDignosisNormal
{
    return [_diagnosisResult isDiagnosisNoraml];
}

- (void)setOBDDictionary:(NSDictionary *)dic
{
    _diagnosisResult.obdKeyValue = dic;
}


@end



@interface OBDDiagnosisViewController ()


@end

@implementation OBDDiagnosisViewController

- (Class)animationViewClass
{
    return [OBDDignosisAnimationView class];
}

- (Class)resultViewClass
{
    return [OBDDignosisResultView class];
}



- (void)configOwnViews
{
    [(OBDDignosisResultView *)_resultView setOBDDictionary:self.obdKeyValue];
    __weak typeof(self) weakself = self;
    GetOBDFault *gof = [[GetOBDFault alloc] initWithHandler:^(BaseRequest *request) {
        [weakself showResult:request.response.Body];
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:gof wait:NO];
}

- (void)showResult:(BaseResponseBody *)body
{
    __weak typeof(_resultView) wr = _resultView;
    __weak typeof(_animationView) wa = _animationView;
    [_animationView stopAnimation:body completion:^{
        [wr showResult:body];
        ((OBDDignosisAnimationView *)wa).isDignosisNormal = [(OBDDignosisResultView *)wr isDignosisNormal];
    }];
    
}


@end
