//
//  CarDataMonitorViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "CarDataMonitorViewController.h"

@interface CarDataMonitorViewController ()
{
    BOOL _isMonitorNormal;
}

@end

@implementation CarDataMonitorViewController

- (BOOL)isMonitorNormal
{
    return _isMonitorNormal;
}

- (CGFloat)getValueFrom:(NSString *)str
{
    if ([NSString isEmpty:str])
    {
        return 0;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    CGFloat number;
    [scanner scanFloat:&number];
    return number;
}

- (void)reloadAfterGetOBDData:(GetOBDDataResponseBody *)body
{
    _data = [NSMutableArray array];
//    [_data addObject:[NSString stringWithFormat:@"VIN：%@", body.VIN]];
    
    [_data addObjectsFromArray:[OBDConstHelper changeCodeToName:body.Value]];
    
    _isMonitorNormal = YES;
    NSString *errCountKey = [NSString stringWithFormat:@"%d", 0x01];
    for (KeyValue *kv in _data)
    {
        if ([kv.key isEqualToString:errCountKey])
        {
            NSInteger err = (NSInteger)[self getValueFrom:[kv.value description]];
            _isMonitorNormal = err == 0;
            break;
        }
    }
    
    [_tableView reloadData];
}

//- (void)configOwnViews
//{
//    __weak typeof(self) we = self;
//    GetOBDData *god = [[GetOBDData alloc] initWithHandler:^(BaseRequest *request) {
//        GetOBDDataResponseBody *data = (GetOBDDataResponseBody *)request.response.Body;
//        [we reloadAfterGetOBDData:data];
//    }];
//    
//    [[WebServiceEngine sharedEngine] asyncRequest:god];
//
//}

#define kWTATableCellIdentifier  @"WTATableCellIdentifier"

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValue *kv = _data[indexPath.row];
    CGSize size = [[kv.value description] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, HUGE_VALF) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height > 50 ? size.height : 50;
}

- (BOOL)isNormalAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    KeyValue *kv = _data[indexPath.row];
    cell.textLabel.text = [kv.value description];
    
    BOOL isNorma = [self isNormalAtIndexPath:indexPath];
    
    cell.textLabel.textColor = isNorma ? kBlackColor : kRedColor;
    cell.detailTextLabel.textColor = isNorma ? kBlackColor : kRedColor;
    
    cell.backgroundColor = indexPath.row % 2 ? kWhiteColor : RGB(240, 240, 240);
    
    return cell;
}

@end
