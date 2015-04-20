//
//  TutorialView.h
//  CarOnline
//
//  Created by James on 7/18/14.
//  Copyright (c) 2014 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialView : UIView<PageScrollViewDelegate>
{
    NSMutableArray      *_tutorialViews;
    UIButton    *_button;
    PageScrollView      *_scrollView;
}

@property (nonatomic, strong) NSArray *landScapPages;

- (instancetype)initWith:(NSArray *)images;



@end
