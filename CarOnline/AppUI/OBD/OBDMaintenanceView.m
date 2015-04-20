//
//  OBDMaintenanceView.m
//  CarOnline
//
//  Created by James on 14-11-14.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDMaintenanceView.h"

#if kSupportOldMaintananceUI

@implementation OBDMaintenanceView

- (void)addOwnViews
{
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = [UIImage imageNamed:@"VRM_i15_007_UpRouting.png"];
    [self addSubview:_backgroundView];
    
    _statusImageView = [[UIImageView alloc] init];

    [self addSubview:_statusImageView];
    
    _button = [[MenuButton alloc] init];
    _button.titleLabel.font = [[FontHelper shareHelper] fontWithSize:12];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"VRM_i15_003_NumberCircle.png"] forState:UIControlStateNormal];
    _button.titleLabel.numberOfLines = 2;
    _button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_button];
    
    self.clipsToBounds = NO;
}

- (void)setClickAction:(MenuAction)ac
{
    [_button setClickAction:ac];
}

- (void)setTitle:(NSString *)title
{
    [_button setTitle:title forState:UIControlStateNormal];
}

- (void)setStatusImage:(UIImage *)image
{
    _statusImageView.image = image;
    [_statusImageView sizeWith:_statusImageView.image.size];
    [_statusImageView layoutParentHorizontalCenter];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    [_button setTitle:title forState:UIControlStateNormal];
    _statusImageView.image = image;
}

- (void)relayoutFrameOfSubViews
{
    _backgroundView.frame = self.bounds;
    [_statusImageView sizeWith:_statusImageView.image.size];
    [_statusImageView layoutParentHorizontalCenter];
    
    [_button sizeWith:[_button backgroundImageForState:UIControlStateNormal].size];
    [_button alignTop:_backgroundView];
    [_button alignHorizontalCenterOf:_backgroundView];
    [_button move:CGPointMake(-1, 0)];
}

@end

#else

@implementation OBDMaintenanceView

- (void)addOwnViews
{
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = [UIImage imageNamed:@"VRM_i15_008_TargetValue.png"];
    [self addSubview:_backgroundView];
    
    _button = [[MenuButton alloc] init];
    _button.titleLabel.font = [[FontHelper shareHelper] fontWithSize:12];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button setTitleColor:kGrayColor forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"VRM_i15_009_TargetButtonOff.png"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"VRM_i15_010_TargetButtonOn.png"] forState:UIControlStateSelected];
    [_button setBackgroundImage:[UIImage imageNamed:@"VRM_i15_010_TargetButtonOn.png"] forState:UIControlStateHighlighted];
    _button.titleLabel.numberOfLines = 2;
    _button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_button];
}

- (void)setClickAction:(MenuAction)ac
{
    [_button setClickAction:ac];
}

- (void)setTitle:(NSString *)title
{
    [_button setTitle:title forState:UIControlStateNormal];
}

- (void)setStatusImage:(UIImage *)image
{
//    _statusImageView.image = image;
//    [_statusImageView sizeWith:_statusImageView.image.size];
//    [_statusImageView layoutParentHorizontalCenter];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    [_button setTitle:title forState:UIControlStateNormal];
//    _statusImageView.image = image;
}

- (void)relayoutFrameOfSubViews
{
    _backgroundView.frame = self.bounds;
    
    [_button sizeWith:[_button backgroundImageForState:UIControlStateNormal].size];
    [_button alignTop:_backgroundView];
    [_button alignHorizontalCenterOf:_backgroundView];
    [_button move:CGPointMake(-1, 0)];
}

@end



@implementation OBDMaintenanceValueView

- (void)addOwnViews
{
    _value = [[UILabel alloc] init];
    _value.font = [[FontHelper shareHelper] fontWithSize:12];
    _value.textAlignment = NSTextAlignmentCenter;
    _value.textColor = kWhiteColor;
    _value.numberOfLines = 2;
    _value.backgroundColor = kRedColor;
    _value.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_value];
    
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = [UIImage imageNamed:@"VRM_i15_008_TargetValue.png"];
    [self addSubview:_backgroundView];
    
    self.clipsToBounds = NO;
}

- (void)setTitle:(NSString *)title
{
    _value.text = title;
}

- (void)setStatusImage:(UIImage *)image
{
    _backgroundView.image = image;
//    [_backgroundView sizeWith:_backgroundView.image.size];
//    [_backgroundView layoutParentHorizontalCenter];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
//    [_button setTitle:title forState:UIControlStateNormal];
    _value.text = title;
    _backgroundView.image = image;
//    [_backgroundView sizeWith:_backgroundView.image.size];
//    [_backgroundView layoutParentHorizontalCenter];
    //    _statusImageView.image = image;
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
//    CGRect vRect = rect;
//    vRect.size.height = rect.size.width/2;
//    _value.frame = vRect;
//    
//    rect.origin.y += vRect.size.height;
//    rect.size.height -= vRect.size.height;
    
    _backgroundView.frame = rect;
    
    [_value sizeWith:CGSizeMake(rect.size.width, rect.size.width)];
    [_value layoutAbove:_backgroundView];
}

@end

#endif