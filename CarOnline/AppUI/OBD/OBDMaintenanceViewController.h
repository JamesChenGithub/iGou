//
//  OBDMaintenanceViewController.h
//  CarOnline
//
//  Created by James on 14-11-14.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDBaseViewController.h"


@interface OBDMaintenanceResultView : OBDResultBaseView
{
    OBDKeyValueTableViewController *_maintenanceResults;
}

@end

#if kSupportOldMaintananceUI

@interface OBDMaintenanceAnimationView : OBDAnimationBaseView
{
    UIImageView *_background;
    
    UISwitch *_totalMileageSwitch;
    OBDMaintenanceView *_totalMileageView;
    OBDMaintenanceView *_maintainceMileageView;
    
    UISwitch *_totalDaySwitch;
    OBDMaintenanceView *_totalDayView;
    OBDMaintenanceView *_maintainceDayView;
}

@end

#else

@interface OBDMaintenanceAnimationView : OBDAnimationBaseView
{
    OBDMaintenanceView *_totalMileageView;
    OBDMaintenanceValueView *_maintainceMileageView;
    
    OBDMaintenanceView *_totalDayView;
    OBDMaintenanceValueView *_maintainceDayView;
}

@end

#endif





@interface OBDMaintenanceViewController : OBDBaseViewController

@end
