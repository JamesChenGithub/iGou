//
//  OBDDiagnosisViewController.h
//  CarOnline
//
//  Created by James on 14-11-11.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"

@class CarDiagnosisViewController;

@interface OBDDignosisResultView : OBDResultBaseView
{
    CarDiagnosisViewController *_diagnosisResult;
}

- (void)setOBDDictionary:(NSDictionary *)dic;

- (BOOL)isDignosisNormal;

@end

@interface OBDDignosisAnimationView : OBDAnimationBaseView
{
    UIImageView *_bgView;
    UIImageView *_carView;
    UIImageView *_engineView;
    UIImageView *_scanbgView;
    UIImageView *_scaningView;
    UIImageView *_scanResultView;
    
    BOOL _isScaning;
}


@property (nonatomic, assign) BOOL isDignosisNormal;


@end

@interface OBDDiagnosisViewController : OBDBaseViewController

@property (nonatomic, strong) NSDictionary *obdKeyValue;

@end
