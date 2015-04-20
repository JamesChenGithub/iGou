//
//  TutorialViewController.m
//  CarOnline
//
//  Created by James on 14-8-20.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)addOwnViews
{
    IOSDeviceConfig *cfg = [IOSDeviceConfig sharedConfig];
    // 显示对应的图片
    if (cfg.isIPhone)
    {
        if ([cfg isIPhone5])
        {
            UIImage *image1 = UIJPGImageNamed(@"tutorial_1_5");
            UIImage *image2 = UIJPGImageNamed(@"tutorial_2_5");
            UIImage *image3 = UIJPGImageNamed(@"tutorial_3_5");
            _tutorialView = [[TutorialView alloc] initWith:@[image2, image1, image3]];
        }
        else
        {
            UIImage *image1 = UIJPGImageNamed(@"tutorial_1_4");
            UIImage *image2 = UIJPGImageNamed(@"tutorial_2_4");
            UIImage *image3 = UIJPGImageNamed(@"tutorial_3_4");
            _tutorialView = [[TutorialView alloc] initWith:@[image2, image1, image3]];
        }
    }
    
    [self.view addSubview:_tutorialView];
}

- (void)layoutOnIPhone
{
    [_tutorialView setFrameAndLayout:self.view.bounds];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
