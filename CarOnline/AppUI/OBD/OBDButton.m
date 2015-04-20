//
//  OBDButton.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDButton.h"

@implementation OBDButton

//- (instancetype)init
//{
//    if (self = [super initWithStyle:EImageTopTitleBottom])
//    {
//        UIImage *icon = [UIImage imageWithColor:kRandomFlatColor size:CGSizeMake(50, 50)];
//        [self setImage:icon forState:UIControlStateNormal];
//        
//        _statusIcon = [UIImage imageWithColor:kRandomFlatColor size:CGSizeMake(16, 16)];
//        _statusIconView = [[UIImageView alloc] initWithImage:_statusIcon];
//        [self addSubview:_statusIconView];
//    }
//    return self;
//}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action
{
    if (self = [super initWithTitle:title icon:icon action:action])
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIImage *selectIcon = [UIImage imageNamed:@"VRM_i09_014_AlarmFlag.png"];
        _statusIconView = [[UIImageView alloc] initWithImage:selectIcon];
        _statusIconView.hidden = YES;
        [self insertSubview:_statusIconView atIndex:0];
        
//        self.backgroundColor = RGBA(80, 80, 80, 0.5);
        
        [self setBackgroundImage:[UIImage imageNamed:@"VRM_i09_011_ButtonBlock.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"VRM_i09_012_ButtonBlockPressed.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    // 显示警告状态信息
    [super setSelected:selected];
    _statusIconView.hidden = !selected;
}


#define kDefaultIconSize CGSizeMake(44, 44)
#define kImageViewTitlePadding 10
#define kTitleHeight 20

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;

    
    UIImage *img = [self imageForState:UIControlStateNormal];
    
    
    CGSize size = kDefaultIconSize;
    
    if (!CGSizeEqualToSize(img.size, CGSizeZero))
    {
        size = img.size;
    }

    [self.imageView sizeWith:size];
    [self.imageView layoutParentHorizontalCenter];
    [self.imageView alignParentTopWithMargin:15];
    
    [self.titleLabel sizeWith:CGSizeMake(rect.size.width, rect.size.height - 15 - size.height)];
    [self.titleLabel layoutBelow:self.imageView];
    
    
    [_statusIconView sizeWith:_statusIconView.image.size];
    [_statusIconView alignParentRight];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.bounds.size.width != 0 && self.bounds.size.height != 0)
    {
        [self relayoutFrameOfSubViews];
    }
}


@end
