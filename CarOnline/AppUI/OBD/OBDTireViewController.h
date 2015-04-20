//
//  OBDTireViewController.h
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"


@interface OBDTireResultView : OBDResultBaseView
{
    OBDKeyValueTableViewController *_tireResults;
}

- (void)showResult:(BaseResponseBody *)body tireCheckResult:(NSArray *)results;

@end

@interface OBDTireAnimationView : OBDAnimationBaseView
{
    CarTirePressureViewController *_carTire;
}

- (NSArray *)tireCheckResult;

@end

@interface OBDTireViewController : OBDBaseViewController

@end
