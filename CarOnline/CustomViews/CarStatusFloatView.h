//
//  CarStatusFloatView.h
//  CarOnline
//
//  Created by James on 14-7-25.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VehicleGPSListItem;

@protocol CarStatusFloatViewDelegate <NSObject>

@optional

- (void)onGetAddress:(VehicleGPSListItem *)gps;

- (void)onGetVehicleGPSList:(NSArray *)list;


@end

@interface CarStatusFloatView : UIView
{
    UILabel *_name;
    UILabel *_status;
    UILabel *_time;
    UILabel *_update;
    NSTimer *_timer;
   
}

@property (nonatomic, strong) VehicleGPSListItem *vehicle;

@property (nonatomic, assign) BOOL isInPlayback;


@property (nonatomic, unsafe_unretained) id<CarStatusFloatViewDelegate> delegate;

- (instancetype)initWithoutUpdate;

- (void)startRequest:(BOOL)wait;

- (void)startRequestOfVehicleNum:(NSString *)vehNum;

- (void)resetAndStartRequest;

- (void)stopRequest;

- (void)setGPSListItem:(VehicleGPSListItem *)gps;

- (void)updateStatusText;


- (void)onlySetVehicleInCarFerence:(VehicleGPSListItem *)vehicle;


@end
