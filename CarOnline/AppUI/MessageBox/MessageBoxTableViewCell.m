//
//  MessageBoxTableViewCell.m
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "MessageBoxTableViewCell.h"

@interface MessageBoxTableViewCell ()

@property (nonatomic, strong) AlertListItem *message;

@end

@implementation MessageBoxTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _messageBg = [[UIView alloc] init];
#if kSupportOldUI
        _messageBg.layer.borderWidth = 1;
        _messageBg.layer.cornerRadius = 6;
        _messageBg.layer.borderColor = kGrayColor.CGColor;
        _messageBg.backgroundColor = [UIColor flatWhiteColor];
#endif
        [self.contentView addSubview:_messageBg];
        
        _messageAlert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VRM_i08_001_Bell.png"]];
        [_messageBg addSubview:_messageAlert];
        
        _messageText = [[UILabel alloc] init];
        _messageText.font = [UIFont systemFontOfSize:14];
        _messageText.textColor = kBlackColor;
        _messageText.backgroundColor = kClearColor;
        _messageText.numberOfLines = 0;
        _messageText.lineBreakMode = NSLineBreakByWordWrapping;
        [_messageBg addSubview:_messageText];
        
        _messageDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageDelete setImage:[UIImage imageNamed:@"VRM_i08_002_DEL.png"] forState:UIControlStateNormal];
        
#if kSupportOldUI
        [_messageDelete setBackgroundImage:[UIImage imageNamed:@"VRM_i04_011_ButtonCircle.png"] forState:UIControlStateSelected];
        [_messageDelete setBackgroundImage:[UIImage imageNamed:@"VRM_i04_011_ButtonCircle.png"] forState:UIControlStateHighlighted];
#else
        UIImage *simg = [[UIImage imageNamed:@"VRM_i08_002_DEL.png"] imageWithTintColor:kBlackColor];
        [_messageDelete setImage:simg forState:UIControlStateSelected];
        [_messageDelete setImage:simg forState:UIControlStateHighlighted];
        [_messageDelete setBackgroundImage:[UIImage imageWithColor:[UIColor flatWhiteColor]] forState:UIControlStateSelected];
        [_messageDelete setBackgroundImage:[UIImage imageWithColor:[UIColor flatWhiteColor]] forState:UIControlStateHighlighted];
#endif
        [_messageDelete addTarget:self action:@selector(onDeleteAlert) forControlEvents:UIControlEventTouchUpInside];
        [_messageBg addSubview:_messageDelete];
        
        
        self.backgroundColor = kClearColor;
    }
    return self;
}

#define kVerMargin 5

#define kVerPadding 10

#define kMinMessageHeight 24

#if kSupportOldUI
#define kMessageWidth 196
#else
#define kMessageWidth (kMainScreenWidth - 110)
#endif

#define kAlarmDelHorMargin 10

+ (CGFloat)heightOf:(NSString *)text
{
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kMessageWidth, HUGE_VALF) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    if (size.height < kMinMessageHeight)
    {
        size.height = kMinMessageHeight;
    }
    
    return size.height + 2*kVerPadding + 2*kVerMargin;
}

- (void)config:(AlertListItem *)message
{
    self.message = message;
    //    _messageText.backgroundColor = kRedColor;
    //    _messageAlert.backgroundColor = kBlueColor;
    //    _messageDelete.backgroundColor = kYellowColor;
    _messageText.text = [self.message description];
}

// 删除警告信息
- (void)onDeleteAlert
{
    __weak typeof(self) ws = self;
    DelAlarmInfo *del = [[DelAlarmInfo alloc] initWithHandler:^(BaseRequest *request) {
//        [[HUDHelper sharedInstance] tipMessage:[request.response message]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteAlarmNotify object:ws.message];
    }];
    del.MessageType = self.message.MessageType;
    del.AlertId = self.message.AlertId;
    [[WebServiceEngine sharedEngine] asyncRequest:del wait:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

#define kAlarmAlarmSize CGSizeMake(24, 24)
#define kAlarmDelSize CGSizeMake(44, 44)

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
#if kSupportOldUI
    rect = CGRectInset(rect, 8, kVerMargin);
    
    _messageBg.frame = rect;
    
    
    
    [_messageAlert sizeWith:kAlarmAlarmSize];
    [_messageAlert layoutParentVerticalCenter];
    [_messageAlert alignParentLeftWithMargin:kAlarmDelHorMargin];
    
    [_messageDelete sizeWith:kAlarmDelSize];
    [_messageDelete layoutParentVerticalCenter];
    [_messageDelete alignParentRightWithMargin:kAlarmDelHorMargin];
    
    rect = _messageBg.bounds;
    //    rect = CGRectInset(rect, kAlarmAlarmSize.width + 2*kAlarmDelHorMargin, kVerPadding);
    rect.origin.y += kVerPadding;
    rect.size.height -= 2*kVerPadding;
    rect.origin.x += 2*kAlarmDelHorMargin + kAlarmAlarmSize.width;
    rect.size.width -= 4*kAlarmDelHorMargin + kAlarmAlarmSize.width + kAlarmDelSize.width;
    _messageText.frame = rect;
#else
    
    _messageBg.frame = rect;
    
    [_messageAlert sizeWith:_messageAlert.image.size];
    [_messageAlert layoutParentVerticalCenter];
    [_messageAlert alignParentLeftWithMargin:50 - _messageAlert.image.size.width];
    
    [_messageDelete sizeWith:CGSizeMake(55, rect.size.height)];
    [_messageDelete alignParentRight];
    
    [_messageText sizeWith:rect.size];
    [_messageText layoutToRightOf:_messageAlert margin:5];
    [_messageText scaleToLeftOf:_messageDelete];
    
#endif
}

@end
