//
//  MessageBoxTableViewCell.h
//  CarOnline
//
//  Created by James on 14-7-26.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBoxTableViewCell : UITableViewCell
{
    UIView *_messageBg;
    UIImageView *_messageAlert;
    UILabel *_messageText;
    UIButton *_messageDelete;
    
    
}

+ (CGFloat)heightOf:(NSString *)text;

- (void)config:(AlertListItem *)message;

@end
