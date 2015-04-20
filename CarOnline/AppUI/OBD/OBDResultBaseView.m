//
//  OBDResultBaseView.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDResultBaseView.h"

@implementation OBDResultBaseView

- (void)dealloc
{
    DebugLog(@"");
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)addOwnViews
{
    _headerView = [[OBDResultHeaderView alloc] init];
    [self addSubview:_headerView];
    
    _resultLabel = [[UILabel alloc] init];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_resultLabel];
}




- (OBDResultHeaderView *)headerView
{
    return _headerView;
}

- (void)configOwnViews
{
    _headerView.vehicle = [WebServiceEngine sharedEngine].vehicle;
}


- (void)showResult:(BaseResponseBody *)body
{
    self.responseBody = body;
}

- (BOOL)isEnableExpand
{
    return YES;
//    return self.responseBody != nil;
}

- (BOOL)isExpand
{
    BOOL isenable = [self isEnableExpand];
    return isenable ? _isExpand : isenable;
}

#define kHeaderHeight 44

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    [_headerView setFrameAndLayout:CGRectMake(0, 0, rect.size.width, kHeaderHeight)];
    
    [_resultLabel sameWith:_headerView];
    [_resultLabel layoutBelow:_headerView];
    
}

- (NSInteger)unexpandHeight
{
    return kHeaderHeight * 2;
}
- (NSInteger)expandHeight
{
    return kHeaderHeight * 7;
}

- (void)expand
{
    if ([self isEnableExpand])
    {
        if (self.isExpand)
        {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            CGRect rect = self.frame;
            rect.origin.y -= [self expandHeight] - [self unexpandHeight];
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            self.isExpand = YES;
        }];
    }
}
- (void)withdraw
{
    if ([self isEnableExpand])
    {
        if (!self.isExpand)
        {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            CGRect rect = self.frame;
            rect.origin.y += [self expandHeight] - [self unexpandHeight];
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            self.isExpand = NO;
        }];
    }
}

//- (UIView *)move:(CGPoint)vec
//{
//    [super move:vec];
//    
//    CGFloat sbh = self.superview.bounds.size.height;
//    CGRect rect = self.frame;
//    if (rect.origin.y < sbh - [self unexpandHeight])
//    {
//        self.isExpand = YES;
//    }
//    return self;
//}

@end
