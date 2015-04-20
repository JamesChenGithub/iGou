//
//  AboutUsViewController.m
//  CarOnline
//
//  Created by James on 14-7-21.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)reloadAfterGetServ:(GetServResponseBody *)body
{
    
    //{"Body":{"serverName":"深圳市谷英技术有限公司","serverTp":"谷英","serverTelephone":"13534118825","serverEmail":"info@growwin.com.cn","serverPhone":"0755-29823518","serverAddress":"广东省深圳市宝安区龙华民清路光辉科技园2栋2单元3楼"},"Head":{"ResultCode":"00","ResultInfo":""}}
    // 请求到排放的处理
    _data = [NSMutableArray array];
    KeyValue *kv = [KeyValue key:kAppInfo_AboutUs_ServerName_Str value:body.serverName];
    [_data addObject:kv];
    
    kv = [KeyValue key:kAppInfo_AboutUs_Contact_Str value:body.serverName];
    [_data addObject:kv];
    
    kv = [KeyValue key:kAppInfo_AboutUs_Tel_Str value:body.serverTelephone];
    [_data addObject:kv];
    
    kv = [KeyValue key:kAppInfo_AboutUs_Mail_Str value:body.serverEmail];
    [_data addObject:kv];
    
    kv = [KeyValue key:kAppInfo_AboutUs_Phone_Str value:body.serverPhone];
    [_data addObject:kv];
    
    kv = [KeyValue key:kAppInfo_AboutUs_Address_Str value:body.serverAddress];
    [_data addObject:kv];
    
    
    
    [_tableView reloadData];
    
}

- (void)configOwnViews
{
    
    __weak typeof(self) weakSelf = self;
    GetServ *goe = [[GetServ alloc] initWithHandler:^(BaseRequest *request) {
        GetServResponseBody *body = (GetServResponseBody *)request.response.Body;
        [weakSelf reloadAfterGetServ:body];
    }];
    [[WebServiceEngine sharedEngine] asyncRequest:goe wait:YES];
}


#define kWTATableCellIdentifier @"kWTATableCellIdentifier"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kBlackColor;
        cell.detailTextLabel.textColor = kBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = -1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    KeyValue *kv = _data[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", kv.key, kv.value];
    
    return cell;
}

@end
