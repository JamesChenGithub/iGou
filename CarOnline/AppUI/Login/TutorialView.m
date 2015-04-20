//
//  TutorialView.m
//  CarOnline
//
//  Created by James on 7/18/14.
//  Copyright (c) 2014 James. All rights reserved.
//

#import "TutorialView.h"

@interface TutorialView()

@property (nonatomic, strong) NSArray *portaitPages;
@property (nonatomic, assign) BOOL isUsePortraitPages;

@end

@implementation TutorialView

- (instancetype)initWith:(NSArray *)images
{
    if (self = [super initWithFrame:CGRectZero])
    {
        [self addOwnViews];
        
        self.portaitPages = images;
        _isUsePortraitPages = YES;
        
        _tutorialViews = [NSMutableArray array];
        for (UIImage *img in images)
        {
            UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
            [_tutorialViews addObject:imgv];
        }
        [self configOwnViews];
    }
    return self;
}

- (void)setIsUsePortraitPages:(BOOL)isUsePortraitPages
{
    if (_isUsePortraitPages == isUsePortraitPages)
    {
        return;
    }
    _isUsePortraitPages = isUsePortraitPages;
    
    if (_isUsePortraitPages)
    {
        for (NSInteger i = 0; i < _tutorialViews.count; i++)
        {
            UIImageView *imageview = _tutorialViews[i];
            imageview.image = _portaitPages[i];
        }
    }
    else
    {
        for (NSInteger i = 0; i < _tutorialViews.count; i++)
        {
            UIImageView *imageview = _tutorialViews[i];
            imageview.image = _landScapPages[i];
        }
    }
}


- (void)addOwnViews
{
    _scrollView = [[PageScrollView alloc] init];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
//    _scrollView.pageControl.hidden = NO;
    _scrollView.pageControl.pageIndicatorTintColor = kBlackColor;
    _scrollView.pageControl.currentPageIndicatorTintColor = kRedColor;
    
    _button = [[UIButton alloc] init];
    [_button setBackgroundImage:[UIImage imageNamed:@"VRM_i02_002_ButtonGo.png"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"VRM_i02_003_ButtonGoPressed.png"] forState:UIControlStateHighlighted];
    [_button setImage:[UIImage imageNamed:@"VRM_i02_001_ButtonGoLetter.png"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onEnterApp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

- (void)onEnterApp
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES] forKey:kHasShowTutorial];
    [ud synchronize];
    [[AppDelegate sharedAppDelegate] enterMainUI];
}

- (void)configOwnViews
{
    _button.hidden = !(_scrollView.pageIndex == _scrollView.pageCount - 1);
}

- (void)relayoutFrameOfSubViews
{
    self.isUsePortraitPages = [IOSDeviceConfig sharedConfig].isPortrait;
    
    if (_scrollView.pages.count == 0)
    {
        [_scrollView setFrameAndLayout:self.bounds withPages:_tutorialViews];
        [self configOwnViews];
    }
    else
    {
        [_scrollView setFrameAndLayout:self.bounds withPages:_tutorialViews];
    }
    
    [_scrollView.pageControl alignParentBottomWithMargin:20];
    
    [_button sizeWith:CGSizeMake(100, 35)];
    [_button layoutParentHorizontalCenter];
    [_button alignParentBottomWithMargin:44];
}

- (void)onPageScrollView:(PageScrollView *)pageView scrollToPage:(NSInteger)pageIndex
{
    [self configOwnViews];
}

@end
