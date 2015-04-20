//
//  CarListSectionView.h
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarListSectionView;
typedef void (^CarListSectionViewClickBolok)(CarListSectionView *view);

@interface CarListSectionView : UIView
{
@protected
    UIImageView *_expand;
    UILabel *_title;
    GroupListItem *_section;
    CarListSectionViewClickBolok _clickAction;
}

- (void)configWith:(GroupListItem *)item clickAction:(CarListSectionViewClickBolok)block;

@end
