//
//  CarDataMonitorViewController.h
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface CarDataMonitorViewController : KeyValueTableViewController


- (BOOL)isMonitorNormal;

- (void)reloadAfterGetOBDData:(GetOBDDataResponseBody *)body;
@end
