//
//  CarInfoViewController.h
//  CarOnline
//
//  Created by James on 14-7-23.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "KeyValueTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface CarInfoViewController : KeyValueTableViewController<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@end
