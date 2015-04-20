//
//  OBDSafeViewController.m
//  CarOnline
//
//  Created by James on 14-11-8.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDSafeViewController.h"


@implementation OBDSafeResultView

- (BOOL)isEnableExpand
{
    return [_data count] > 0;
}

//- (NSInteger)expandHeight
//{
//    return [self unexpandHeight] + _data.count * 44;
//}

- (void)setSecurity:(BOOL)isSec SafeData:(NSArray *)data
{
    if (isSec)
    {
        [self setLock:YES];
    }
    else
    {
        _resultLabel.textColor = kRedColor;
        _resultLabel.text = kOBDSafe_Alerting_Str;
    }

    _data = [NSMutableArray arrayWithArray:data];
    
    CGRect rect = self.frame;
    rect.size.height = [self expandHeight];
    [self setFrameAndLayout:rect];
    [_tableView reloadData];
}

- (void)setLock:(BOOL)lock
{
    [_data removeAllObjects];
    _resultLabel.textColor = kBlackColor;
    _resultLabel.text = !lock ? kOBDSafe_SetSecurity_On_Str : kOBDSafe_SetSecurity_Off_Str;
}

- (void)addOwnViews
{
    [super addOwnViews];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 50;
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    [self addSubview:_tableView];
}

- (void)relayoutFrameOfSubViews
{
    [super relayoutFrameOfSubViews];
    CGRect rect = self.bounds;
    CGRect lrect = _resultLabel.frame;
    
    rect.origin.y = lrect.origin.y + lrect.size.height;
    rect.size.height -= lrect.origin.y + lrect.size.height;
    _tableView.frame = rect;
}

#define kWTATableCellIdentifier  @"WTATableCellIdentifier"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTATableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kWTATableCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kBlackColor;
        cell.detailTextLabel.textColor = kBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    KeyValue *kv = _data[indexPath.row];
    cell.textLabel.text = kv.key;
    cell.detailTextLabel.text = [kv.value description];
    
    cell.backgroundColor = indexPath.row % 2 ? kWhiteColor : RGB(240, 240, 240);
    
    return cell;
}


@end

@implementation OBDSafeAnimationView

- (void)setLockAntion:(MenuAction)action
{
    [_lock setClickAction:action];
}

- (void)addOwnViews
{
    _carView = [[UIImageView alloc] init];
    _normalCarImage = [UIImage imageNamed:@"VRM_i11_008_Car.png"];
    _carView.image = _normalCarImage;
    [self addSubview:_carView];
    
    _lockbgView = [[UIImageView alloc] init];
    _lockbgView.image = [UIImage imageNamed:@"VRM_i11_001_ScanBackground.png"];
    [self addSubview:_lockbgView];
    _lockbgView.userInteractionEnabled = YES;
    _lockbgView.backgroundColor = [kLightGrayColor colorWithAlphaComponent:0.25];

    
    _lock = [[MenuButton alloc] init];
    [_lock setImage:[UIImage imageNamed:@"VRM_i12_002_Lock.png"] forState:UIControlStateNormal];
    [_lock setImage:[UIImage imageNamed:@"VRM_i12_001_Unlock.png"] forState:UIControlStateSelected];
    [self addSubview:_lock];
    _lock.hidden = YES;
}

- (void)relayoutFrameOfSubViews
{
    CGSize carSize = _carView.image.size;
    
    if (CGSizeEqualToSize(carSize, _normalCarImage.size))
    {
        [_carView sizeWith:carSize];
        [_carView layoutParentHorizontalCenter];
        [_carView alignParentTopWithMargin:30];
    }
    else
    {
        CGPoint center = _carView.center;
        [_carView sizeWith:_carView.image.size];
        _carView.center = center;
    }
    
    
    
    
    
    
    [_lockbgView sizeWith:_lockbgView.image.size];
    _lockbgView.center = _carView.center;
    _lockbgView.layer.cornerRadius = _lockbgView.image.size.width/2;
    
    [_lock sizeWith:[_lock imageForState:UIControlStateNormal].size];
    _lock.center = _lockbgView.center;
}

- (void)setLock:(BOOL)lock
{
    _lock.hidden = NO;
    _lock.selected = lock;
    
    if (lock)
    {
        [self setVibrate:NO];
    }
}

- (void)setVibrate:(BOOL)vbr
{
    CGPoint center = _carView.center;
    _carView.image = vbr ? [UIImage imageNamed:@"VRM_i12_003_VibrationCar.png"] : _normalCarImage;
    [_carView sizeWith:_carView.image.size];
    _carView.center = center;
}


@end



@interface OBDSafeViewController ()

@property (nonatomic, strong) GetSafetyResponseBody *safetyBody;
@property (nonatomic, strong) GetSecurityResponseBody *securityBody;

@end

@implementation OBDSafeViewController

- (Class)animationViewClass
{
    return [OBDSafeAnimationView class];
}

- (Class)resultViewClass
{
    return [OBDSafeResultView class];
}

- (void)onGetSafety:(GetSafetyResponseBody *)body
{
    self.safetyBody = body;
    
    NSInteger type = [body.Type integerValue];
    
    OBDSafeAnimationView *safeView = (OBDSafeAnimationView *)_animationView;
    OBDSafeResultView *safeResultView = (OBDSafeResultView *)_resultView;
    NSMutableArray *data = [NSMutableArray array];
    
    if (type <= 1)
    {
        // 没有问题
        // 无报警
        [safeView setVibrate:NO];
//        _safeView.safeSate = E_All_Off;
    }
    else if (type == 2)
    {
        [safeView setVibrate:YES];
        KeyValue *kv = [KeyValue key:kOBDSafe_VibrateAlert_Str  value:kOBD_Result_Emerge_Str];
        [data addObject:kv];
//        [_safeView setVibCar:[UIImage imageNamed:@"vibCar.png"]];
    }
    
    NSString *value = body.Info;
//    value = @"111111";
    
    if (![NSString isEmpty:value] && value.length >= 6)
    {
        const char *valueChars = [value cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger state = 0;
        if (valueChars[0] == '1')
        {
            
            state += 8;
            KeyValue *kv = [KeyValue key:kOBDSafe_LFDoor_Str  value:kOBD_Result_TurnOn_Str];
            [data addObject:kv];
        }
        
        if (valueChars[1] == '1')
        {
            state += 4;
            
            KeyValue *kv = [KeyValue key:kOBDSafe_RFDoor_Str  value:kOBD_Result_TurnOn_Str];
            [data addObject:kv];
        }
        
        if (valueChars[2] == '1')
        {
            state += 2;
            
            KeyValue *kv = [KeyValue key:kOBDSafe_LBDoor_Str  value:kOBD_Result_TurnOn_Str];
            [data addObject:kv];
        }
        
        if (valueChars[3] == '1')
        {
            state += 1;
            
            KeyValue *kv = [KeyValue key:kOBDSafe_RBDoor_Str  value:kOBD_Result_TurnOn_Str];
            [data addObject:kv];
        }
        
        
        if (valueChars[4] == '1')
        {
            KeyValue *kv = [KeyValue key:kOBDSafe_Light_Str  value:kOBD_Result_TurnOn_Str];
            [data addObject:kv];
        }
        
        if (valueChars[5] == '1')
        {
            KeyValue *kv = [KeyValue key:kOBDSafe_TailBox_Str  value:kOBD_Result_TurnOn_Str];
            [data addObject:kv];
        }
    }
    
    if (self.securityBody)
    {
        if (self.securityBody.IsSecurity)
        {
            [safeView setVibrate:NO];
        }
        else
        {
            [safeResultView setSecurity:NO SafeData:data];
        }
    }
}


- (void)onGetSecurity:(GetSecurityResponseBody *)body
{
    self.securityBody = body;
    
    OBDSafeAnimationView *safeView = (OBDSafeAnimationView *)_animationView;
    [safeView setLock:self.securityBody.IsSecurity];
    
    OBDSafeResultView *safeResult = (OBDSafeResultView *)_resultView;
    [safeResult setLock:self.securityBody.IsSecurity];
}

- (void)addOwnViews
{
    [super addOwnViews];
    
    OBDSafeAnimationView *animation = (OBDSafeAnimationView *)_animationView;
    
    __weak typeof(self) ws = self;
    [animation setLockAntion:^(MenuButton *menu) {
        if (menu.selected)
        {
            [ws onLockRemoteView];
        }
        else
        {
            [ws onUnlockRemoteView];

            
        }
    }];
}

- (void)configOwnViews
{
    
    __weak typeof(self) weakSelf = self;
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    
    GetSecurity *gsc = [[GetSecurity alloc] initWithHandler:^(BaseRequest *request) {
        GetSecurityResponseBody *body = (GetSecurityResponseBody *)request.response.Body;
        [weakSelf onGetSecurity:body];
    }];
    [we asyncRequest:gsc];
    
    GetSafety *gs = [[GetSafety alloc] initWithHandler:^(BaseRequest *request) {
        GetSafetyResponseBody *body = (GetSafetyResponseBody *)request.response.Body;
        [weakSelf onGetSafety:body];
    }];
    [we asyncRequest:gs];
}



- (void)onUnlockRemoteView
{
    if (!self.securityBody.IsSecurity)
    {
        __weak typeof(self) weakSelf = self;
        __weak typeof(_animationView) wa = _animationView;
        __weak typeof(_resultView) wr = _resultView;
        SetSecurity *ss = [[SetSecurity alloc] initWithHandler:^(BaseRequest *request) {
            
            if ([request.response success])
            {
                weakSelf.securityBody.IsSecurity = YES;
                OBDSafeAnimationView *safeView = (OBDSafeAnimationView *)wa;
                [safeView setLock:weakSelf.securityBody.IsSecurity];
                
                OBDSafeResultView *safeResult = (OBDSafeResultView *)wr;
                [safeResult setLock:weakSelf.securityBody.IsSecurity];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearCarWarningNotify" object:nil userInfo:nil];
            }
            
//            [[HUDHelper sharedInstance] tipMessage:[request.response message]];
            
        }];
        ss.IsSecurity = 1;
        [[WebServiceEngine sharedEngine] asyncRequest:ss];
    }
}

- (void)onLockRemoteView
{
    if (self.securityBody.IsSecurity)
    {
        __weak typeof(self) weakSelf = self;
        __weak typeof(_animationView) wa = _animationView;
        __weak typeof(_resultView) wr = _resultView;
        SetSecurity *ss = [[SetSecurity alloc] initWithHandler:^(BaseRequest *request) {
            
            if ([request.response success])
            {
                weakSelf.securityBody.IsSecurity = NO;
                OBDSafeAnimationView *safeView = (OBDSafeAnimationView *)wa;
                [safeView setLock:weakSelf.securityBody.IsSecurity];
                
                OBDSafeResultView *safeResult = (OBDSafeResultView *)wr;
                [safeResult setLock:weakSelf.securityBody.IsSecurity];
            }
            
//            [[HUDHelper sharedInstance] tipMessage:[request.response message]];
            
        }];
        ss.IsSecurity = 0;
        [[WebServiceEngine sharedEngine] asyncRequest:ss];
    }
    
    
}



@end
