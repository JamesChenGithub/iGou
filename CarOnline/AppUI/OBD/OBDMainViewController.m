//
//  OBDMainViewController.m
//  CarOnline
//
//  Created by James on 14-7-22.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import "OBDMainViewController.h"

@interface OBDMainViewController ()

@property (nonatomic, strong) NSTimer *obdTimer;

@end

@implementation OBDMainViewController

- (void)addMenu:(NSString *)title icon:(UIImage *)image class:(Class)aviewClass
{
    __weak typeof(self) weakSelf = self;
    __block Class viewClass = aviewClass;
    MenuItem *amenu = [[MenuItem alloc] initWithTitle:title icon:image action:^(id<MenuAbleItem> menu) {
        // 点击各个模块的回调
        UIViewController *view = [[viewClass alloc] init];
        view.title = [menu title];
        
        if ([view respondsToSelector:@selector(setVehicle:)])
        {
            [view performSelector:@selector(setVehicle:) withObject:weakSelf.vehicle];
        }
        
        if ([view isKindOfClass:[OBDDiagnosisViewController class]])
        {
            OBDDiagnosisViewController *car = (OBDDiagnosisViewController *)view;
            car.obdKeyValue = weakSelf.obdKeyValue;

        }
        
        [[AppDelegate sharedAppDelegate] pushViewController:view];
    }];
    
    [_OBDItems addObject:amenu];
}

- (BOOL)hasBackgroundView
{
    return YES;
}

- (void)configBackground
{
    if ([IOSDeviceConfig sharedConfig].isIPhone4)
    {
        _backgroundView.image = [UIImage imageNamed:@"obd_bg_4.jpg"];
    }
    else
    {
        _backgroundView.image = [UIImage imageNamed:@"obd_bg_5.jpg"];
    }
}

- (void)startOBDTimer
{
    [self stopOBDTimer];
    
    _obdTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(requestOBDS) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_obdTimer forMode:NSRunLoopCommonModes];
}

- (void)stopOBDTimer
{
    [_obdTimer invalidate];
    _obdTimer = nil;
}

- (void)onGetOBDEmission:(GetOBDEmissionResponseBody *)body
{
    // 排放
    OBDButton *emission = _OBDButtons[0];
    emission.selected = ![body isEmissionNormal];
}

- (void)onGetSafety:(GetSafetyResponseBody *)body
{
    // 安全
    // 排放
    OBDButton *safe = _OBDButtons[1];
    
    NSInteger type = [body.Type integerValue];
    BOOL isNormal = type <= 1;//[NSString isEmpty:body.Info] && [NSString isEmpty:body.Type];
    
    safe.selected = !isNormal;
}

- (void)onGetOBDFault:(GetOBDFaultResponseBody *)body
{
    // 车诊断
    OBDButton *fault = _OBDButtons[2];
    //    BOOL isNormal = [NSString isEmpty:body.Value];
    NSString *value = nil;
    if (![NSString isEmpty:body.Value])
    {
        value = [self.obdKeyValue valueForKeyPath:body.Value];
    }
    
    
    fault.selected = ![NSString isEmpty:value];
}

- (void)onGetMaintenance:(GetMaintenanceResponseBody *)body
{
    // 保养
    OBDButton *maintenance = _OBDButtons[4];
    BOOL isNormal = body.MaintanceDay <= body.TotalDay && body.MaintainMileage <= body.TotalMileage;
    maintenance.selected = !isNormal;
}

- (void)onGetTire:(GetTireResponseBody *)body
{
    
    BOOL isNormal = (body.Temp1 <= 85 && (body.Tpms1 >= 200 && body.Tpms1 <= 300)) && (body.Temp2 <= 85 && (body.Tpms2 >= 200 && body.Tpms2 <= 300)) && (body.Temp3 <= 85 && (body.Tpms3 >= 200 && body.Tpms3 <= 300)) && (body.Temp4 <= 85 && (body.Tpms4 >= 200 && body.Tpms4 <= 300));
    OBDButton *tire = _OBDButtons[6];
    tire.selected = !isNormal;
}



- (void)requestOBDS
{
    // 请求状态信息
    __weak typeof(self) weakself = self;
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    GetOBDEmission *goe = [[GetOBDEmission alloc] initWithHandler:^(BaseRequest *request) {
        GetOBDEmissionResponseBody *body = (GetOBDEmissionResponseBody *)request.response.Body;
        [weakself onGetOBDEmission:body];
    }];
    [we asyncRequest:goe wait:NO];
    
    GetSafety *gs = [[GetSafety alloc] initWithHandler:^(BaseRequest *request) {
        GetSafetyResponseBody *body = (GetSafetyResponseBody *)request.response.Body;
        [weakself onGetSafety:body];
    }];
    [we asyncRequest:gs wait:NO];
    
    
    GetOBDFault *gof = [[GetOBDFault alloc] initWithHandler:^(BaseRequest *request) {
        GetOBDFaultResponseBody *body = (GetOBDFaultResponseBody *)request.response.Body;
        [weakself onGetOBDFault:body];
    }];
    [we asyncRequest:gof wait:NO];
    
    GetMaintenance *gm = [[GetMaintenance alloc] initWithHandler:^(BaseRequest *request) {
        GetMaintenanceResponseBody *body = (GetMaintenanceResponseBody *)request.response.Body;
        [weakself onGetMaintenance:body];
    }];
    
    [we asyncRequest:gm wait:NO];
    
    //    GetTire *gt = [[GetTire alloc] initWithHandler:^(BaseRequest *request) {
    //        GetTireResponseBody *body = (GetTireResponseBody *)request.response.Body;
    //        [weakself onGetTire:body];
    //    }];
    //    [we asyncRequest:gt];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    WebServiceEngine *we = [WebServiceEngine sharedEngine];
    if (![self.vehicle.DeviceName isEqualToString:we.vehicle.DeviceName])
    {
        self.vehicle = [WebServiceEngine sharedEngine].vehicle;
        [_floatView setGPSListItem:self.vehicle];
        
        [_floatView resetAndStartRequest];
    }
    else
    {
        [_floatView startRequest:NO];
    }
    
    [_floatPanel startRequest];
    
    [self requestOBDS];
    [self startOBDTimer];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_floatView stopRequest];
    [_floatPanel stopRequest];
    
    [self stopOBDTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClearCarWarning) name:@"ClearCarWarningNotify" object:nil];
    
    [_floatView setGPSListItem:self.vehicle];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.obdKeyValue = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OBDKeyValue_en" ofType:@"plist"]];
    });
}

- (void)onClearCarWarning
{
    OBDButton *safe = _OBDButtons[1];
    safe.selected = NO;
}


- (void)onGetAddress:(VehicleGPSListItem *)gps;
{
    [self getVehicleAddress:[gps coordinate]];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}


- (void)addOwnViews
{
    
    _titleBg = [[UIView alloc] init];
    _titleBg.backgroundColor = kClearColor;
    [self.view addSubview:_titleBg];
    
    _titleView = [[UILabel alloc] init];
    _titleView.backgroundColor = kClearColor;
    _titleView.textColor = kWhiteColor;
    _titleView.font = [UIFont systemFontOfSize:16];
    _titleView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleView];
    
    // TODO: add Map View
    _floatView = [[CarStatusFloatView alloc] init];
    [self.view addSubview:_floatView];
    
    _OBDItems = [NSMutableArray array];
    
    
    // 添加相关的处理
    [self addMenu:kOBD_Emission_Str icon:[UIImage imageNamed:@"VRM_i09_003_CarEmission.png"] class:[OBDEmisstionViewController class]];
    
    [self addMenu:kOBD_Safety_Str icon:[UIImage imageNamed:@"VRM_i09_004_CarSafety.png"] class:[OBDSafeViewController class]];
    
    [self addMenu:kOBD_Diagnosis_Str icon:[UIImage imageNamed:@"VRM_i09_005_CarDiagnosis.png"] class:[OBDDiagnosisViewController class]];
    
    [self addMenu:kOBD_Data_Str icon:[UIImage imageNamed:@"VRM_i09_006_CarOBDData.png"] class:[OBDDataViewController class]];
    
    [self addMenu:kOBD_Maintenance_Str icon:[UIImage imageNamed:@"VRM_i09_007_CarMaintenance.png"] class:[OBDMaintenanceViewController class]];
    
    [self addMenu:kOBD_Alert_Str icon:[UIImage imageNamed:@"VRM_i09_008_CarAlarmSetting.png"] class:[CarAlertSettingViewController class]];
    
    [self addMenu:kOBD_TirePressure_Str icon:[UIImage imageNamed:@"VRM_i09_009_CarTPMS.png"] class:[OBDTireViewController class]];
    
    [self addMenu:kOBD_Setting_Str icon:[UIImage imageNamed:@"VRM_i09_010_CarSetting.png"] class:[CarDeviceInfoViewController class]];
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
    _OBDButtons = [NSMutableArray array];
    for (MenuItem *item in _OBDItems)
    {
        OBDButton *btn = [[OBDButton alloc] initWithMenu:item];
        [_OBDButtons addObject:btn];
        [_scrollView addSubview:btn];
        
    }
    
    _floatPanel = [[OBDFloatPanel alloc] init];
    [self.view addSubview:_floatPanel];
}

#define kScrollAlighTopMargin 31

#define kRightMargin 15
#define kVerPadding 15

- (void)layoutSubviewsFrame
{
    [super layoutSubviewsFrame];
    
    
    CGRect rect = self.view.bounds;
    
    
    CGFloat yoff = [IOSDeviceConfig sharedConfig].isIOS6 ? 0 : 20;
    _backgroundView.frame = CGRectMake(0, yoff, rect.size.width, rect.size.height - yoff);
    
    
    
    if ([IOSDeviceConfig sharedConfig].isIOS6Later)
    {
        [_titleBg sizeWith:CGSizeMake(rect.size.width, 64)];
    }
    else
    {
        [_titleBg sizeWith:CGSizeMake(rect.size.width, 44)];
    }
    
    [_titleView sizeWith:CGSizeMake(rect.size.width, 44)];
    [_titleView alignBottom:_titleBg];
    
    
    [_floatView sizeWith:CGSizeMake(rect.size.width, kCarStatusFloatViewHeight)];
    [_floatView layoutBelow:_titleBg];
    [_floatView relayoutFrameOfSubViews];
    
    rect.origin.y += _titleBg.frame.size.height;
    rect.size.height -= _titleBg.frame.size.height;
    rect = CGRectInset(rect, 0, kScrollAlighTopMargin);
    CGFloat yoffset = [IOSDeviceConfig sharedConfig].isIOS6 ? 20 : 0;
    rect.size.height += yoffset;
    
    rect.size.width = 253;
    _scrollView.frame = rect;
    
    rect = _scrollView.bounds;
    rect = CGRectInset(rect, 15, 0);
    
    [_scrollView gridViews:_scrollView.subviews inColumn:2 size:CGSizeMake(109, 109) margin:CGSizeMake(4, 4) inRect:rect];
    
    UIView *last = _OBDButtons.lastObject;
    
    CGFloat lastHeight = last.frame.origin.y + last.frame.size.height;
    if (lastHeight > _scrollView.bounds.size.height)
    {
        _scrollView.contentSize = CGSizeMake(0, lastHeight);
    }
    else
    {
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    
    [_floatPanel sizeWith:CGSizeMake(40 + 2*kRightMargin, 37 * 5 + kVerPadding*3 + 1)];
    [_floatPanel layoutBelow:_titleBg margin:31];
    [_floatPanel alignParentRightWithMargin:0];
    [_floatPanel relayoutFrameOfSubViews];
    
    
    
}



@end
