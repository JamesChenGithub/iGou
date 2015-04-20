//
//  CarDiagnosisViewController.h
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface CarDiagnosisViewController : OBDKeyValueTableViewController

@property (nonatomic, strong) NSDictionary *obdKeyValue;

- (void)reloadAfterGetOBDFault:(GetOBDFaultResponseBody *)body;

- (BOOL)isDiagnosisNoraml;

@end
