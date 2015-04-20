//
//  OBDEmisstionViewController.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"

@class VehicleEmissionViewController;

@interface OBDEmisstionResultView : OBDResultBaseView
{
    VehicleEmissionViewController *_emissionResult;
}

@end

@interface OBDEmisstionAnimationView : OBDAnimationBaseView
{
    UIImageView *_bgView;
    UIImageView *_carView;
    UIImageView *_scanbgView;
    UIImageView *_scaningView;
    UIImageView *_scanResultView;
    
    BOOL _isScaning;
}


@property (nonatomic, assign) BOOL isEmissionNormal;


@end



@interface OBDEmisstionViewController : OBDBaseViewController

@end




