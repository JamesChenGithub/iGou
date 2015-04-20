//
//  OBDAnimationBaseView.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDAnimationBaseView : UIView<OBDAnimationAbleView>

@property (nonatomic, strong) BaseResponseBody *responseBody;
@property (nonatomic, copy) OBDAnimationOverBlock animationOver;

@end
