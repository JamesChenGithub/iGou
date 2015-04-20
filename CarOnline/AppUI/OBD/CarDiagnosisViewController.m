//
//  CarDiagnosisViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarDiagnosisViewController.h"

@interface CarDiagnosisViewController ()

@property (nonatomic, assign) BOOL isDiagnosisNoraml;

@end

@implementation CarDiagnosisViewController


- (void)reloadAfterGetOBDFault:(GetOBDFaultResponseBody *)body
{
    
    _isDiagnosisNoraml = YES;
    // obdKeyValue 为 文件对应的数据
//    body.Value = @"P0001";
    NSString *va = [self.obdKeyValue valueForKey:body.Value];
    
    if (![NSString isEmpty:va]) {
        _isDiagnosisNoraml = NO;
        va = va;
    }
    
    
    if (!_isDiagnosisNoraml)
    {
       _data = [NSMutableArray array];
        KeyValue *kv = [KeyValue key:body.Value value:va];
        [_data addObject:kv];
        [_tableView reloadData];
    }
}


- (BOOL)isNormalAtIndexPath:(NSIndexPath *)indexPath
{
    return _isDiagnosisNoraml;
}

- (void)configCell:(UITableViewCell *)cell with:(KeyValue *)kv
{
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", kv.key, kv.value];
}



@end
