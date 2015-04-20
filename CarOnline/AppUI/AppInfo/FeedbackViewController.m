//
//  FeedbackViewController.m
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController


- (void)addOwnViews
{
    _textView = [[UITextView alloc] init];
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = kLightGrayColor.CGColor;
    _textView.text = @"请输入您的意见或建议";
    [self.view addSubview:_textView];
    
    _commitButton = [UIButton buttonWithTip:@"提交"];
    _commitButton.backgroundColor = kRedColor;
    [_commitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_commitButton addTarget:self action:@selector(onCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitButton];
}

- (void)onCommit:(UIButton *)button
{
    [[AppDelegate sharedAppDelegate] popViewController];
}

- (void)layoutSubviewsFrame
{
    [_textView sizeWith:CGSizeMake(290, 100)];
    [_textView layoutParentHorizontalCenter];
    [_textView alignParentTopWithMargin:10];
    
    [_commitButton sizeWith:CGSizeMake(290, 44)];
    [_commitButton layoutParentHorizontalCenter];
    [_commitButton layoutBelow:_textView margin:20];
}

@end
