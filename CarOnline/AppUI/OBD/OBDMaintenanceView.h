//
//  OBDMaintenanceView.h
//  CarOnline
//
//  Created by James on 14-11-14.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#if kSupportOldMaintananceUI

@interface OBDMaintenanceView : UIView
{
    UIImageView *_backgroundView;
    UIImageView *_statusImageView;
    MenuButton *_button;
}

- (void)setClickAction:(MenuAction)ac;

- (void)setTitle:(NSString *)title;
- (void)setStatusImage:(UIImage *)image;
- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end

#else

@interface OBDMaintenanceView : UIView
{
    UIImageView *_backgroundView;
    MenuButton *_button;
}

@property (nonatomic, readonly) MenuButton *button;

- (void)setClickAction:(MenuAction)ac;

- (void)setTitle:(NSString *)title;
- (void)setStatusImage:(UIImage *)image;
- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end


@interface OBDMaintenanceValueView : UIView
{
    UILabel     *_value;
    UIImageView *_backgroundView;
}

- (void)setTitle:(NSString *)title;
- (void)setStatusImage:(UIImage *)image;
- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end

#endif
