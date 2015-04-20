//
//  OBDBaseViewController.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"


#import "OBDResultProtocol.h"





@interface OBDBaseViewController : BaseViewController<UIGestureRecognizerDelegate>
{
@protected
    UIView<OBDAnimationAbleView>    *_animationView;
    UIView<OBDResultAbleView>       *_resultView;
    
    BOOL _hasStartedAnimation;
}


- (Class)animationViewClass;
- (Class)resultViewClass;

- (void)layoutAnimationView;
- (void)layoutResultView;

- (void)showResult:(BaseResponseBody *)body;

@end
