//
//  OBDTireViewController.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDTireViewController.h"



@implementation OBDTireResultView


- (void)addOwnViews
{
    [super addOwnViews];
    
    _tireResults = [[OBDKeyValueTableViewController alloc] init];
    [self addSubview:_tireResults.view];
}

- (void)configOwnViews
{
    [super configOwnViews];
    _resultLabel.text = kOBDTire_Scaning_Str;
}


- (void)showResult:(BaseResponseBody *)body tireCheckResult:(NSArray *)results
{
    [self showResult:body];
    
    BOOL isnoraml = results.count == 0;
    _resultLabel.text = isnoraml ? kOBDTire_Normal_Str : kOBDTire_Abnormal_Str;
    _resultLabel.textColor = isnoraml ? kBlackColor : kRedColor;
    
    _tireResults.data = [NSMutableArray arrayWithArray:results];
    [_tireResults.tableView reloadData];
}

- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    
    CGRect rect = self.bounds;
    CGRect lrect = _resultLabel.frame;
    
    rect.origin.y = lrect.origin.y + lrect.size.height;
    rect.size.height -= lrect.origin.y + lrect.size.height;
    
    _tireResults.view.frame = rect;
    [_tireResults layoutSubviewsFrame];
}


@end

@implementation OBDTireAnimationView

- (void)addOwnViews
{
    _carTire = [[CarTirePressureViewController alloc] init];
    [self addSubview:_carTire.view];
}

- (void)relayoutFrameOfSubViews
{
    _carTire.view.frame = self.bounds;
    [_carTire layoutSubviewsFrame];
}

- (NSArray *)tireCheckResult
{
    return _carTire.checkResults;
}

- (void)stopAnimation:(BaseResponseBody *)body completion:(OBDAnimationOverBlock)block
{
    [_carTire onGetTire:(GetTireResponseBody *)body];
    if (block)
    {
        block();
    }
    
}


@end

@interface OBDTireViewController ()

@end

@implementation OBDTireViewController

- (Class)animationViewClass
{
    return [OBDTireAnimationView class];
}

- (Class)resultViewClass
{
    return [OBDTireResultView class];
}

- (void)configOwnViews
{
    __weak typeof(self) weakSelf = self;
    GetTire *gt = [[GetTire alloc] initWithHandler:^(BaseRequest *request) {
        [weakSelf showResult:request.response.Body];
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:gt wait:NO];
}

- (void)showResult:(BaseResponseBody *)body
{
    __weak typeof(_resultView) wr = _resultView;
    __weak typeof(_animationView) wa = _animationView;
    [_animationView stopAnimation:body completion:^{
//        [_resultView showResult:body];
        NSArray *array = [(OBDTireAnimationView *)wa tireCheckResult];
        [(OBDTireResultView *)wr showResult:body tireCheckResult:array];
//        ((OBDDignosisAnimationView *)_animationView).isDignosisNormal = [(OBDDignosisResultView *)_resultView isDignosisNormal];
    }];
    
}


@end
