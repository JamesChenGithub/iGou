//
//  OBDBaseViewController.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"

@interface OBDBaseViewController ()
{
    BOOL _moveByHand;
    CGFloat _yOffset;
    CGFloat _lastYOff;
}
@end

@implementation OBDBaseViewController

- (Class)animationViewClass
{
    return [OBDAnimationBaseView class];
}

- (Class)resultViewClass
{
    return [OBDResultBaseView class];
}

- (void)addOwnViews
{
    _animationView = [[[self animationViewClass] alloc] init];
    [self.view addSubview:_animationView];
    
    
    _resultView = [[[self resultViewClass] alloc] init];
    [self.view addSubview:_resultView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanHeaderView:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [[_resultView headerView] addGestureRecognizer:pan];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UISwipeGestureRecognizer *exswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(expandResult:)];
    exswip.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:exswip];
    
    UISwipeGestureRecognizer *whswip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawResult:)];
    whswip.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:whswip];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawOnTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_animationView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_hasStartedAnimation)
    {
        _hasStartedAnimation = YES;
        [_animationView performSelector:@selector(startAnimation) withObject:nil afterDelay:0.3];
    }
}

- (void)expandResult:(UISwipeGestureRecognizer *)ges
{
    [_resultView expand];
}

- (void)withdrawResult:(UISwipeGestureRecognizer *)ges
{
    [_resultView withdraw];
}

- (void)withdrawOnTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [_resultView withdraw];
    }
}

- (void)layoutOnIPhone
{
    [self layoutAnimationView];
    [self layoutResultView];
}

- (void)layoutAnimationView
{
    CGRect rect = self.view.bounds;
    [_animationView setFrameAndLayout:rect];
}
- (void)layoutResultView
{
    CGRect rect = self.view.bounds;
    
    NSInteger height = [_resultView expandHeight];
    [_resultView sizeWith:CGSizeMake(rect.size.width, height)];
    
    NSInteger margin = 0;
    
    if (![_resultView isExpand])
    {
        margin = [_resultView unexpandHeight] - height;
    }
    [_resultView alignParentBottomWithMargin:margin];
    [_resultView relayoutFrameOfSubViews];
}

- (void)showResult:(BaseResponseBody *)body
{
    __weak typeof(_resultView) wr = _resultView;
    [_animationView stopAnimation:body completion:^{
        [wr showResult:body];
    }];
    
}





- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [_resultView isEnableExpand];
}

- (void)onPanHeaderView:(UIPanGestureRecognizer *)panGesture
{
    NSInteger yoff = [panGesture locationInView:self.view].y;
    CGRect rect = self.view.bounds;
    CGFloat maxY = rect.origin.y + rect.size.height - [_resultView unexpandHeight];
    CGFloat minY = rect.origin.y + rect.size.height - [_resultView expandHeight];
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _yOffset  = yoff;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (yoff >= minY && yoff <= maxY)
            {
                CGRect r = _resultView.frame;
                r.origin.y = yoff;
                _resultView.frame = r;
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            BOOL down = yoff - minY > (maxY - minY)/2;
            if (down)
            {
                // 向下
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect r = _resultView.frame;
                    r.origin.y = maxY;
                    _resultView.frame = r;
                    _resultView.isExpand = NO;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect r = _resultView.frame;
                    r.origin.y = minY;
                    _resultView.frame = r;
                _resultView.isExpand = YES;
                }];
            }
            break;
        }
        default:
            break;
    }
}


@end
