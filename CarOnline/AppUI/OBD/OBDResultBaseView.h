//
//  OBDResultBaseView.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "OBDResultHeaderView.h"

@interface OBDResultBaseView : UIView<OBDResultAbleView>
{
@protected
    OBDResultHeaderView *_headerView;
    UILabel *_resultLabel;
}

@property (nonatomic, strong) BaseResponseBody *responseBody;

@property (nonatomic, assign) BOOL isExpand;


@end
