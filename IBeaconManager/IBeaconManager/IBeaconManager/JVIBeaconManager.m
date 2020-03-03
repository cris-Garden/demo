//
//  JVIBeaconManager.m
//  IBeaconManager
//
//  Created by ZW on 2019/12/25.
//  Copyright © 2019 Jarvis. All rights reserved.
//

#import "JVIBeaconManager.h"

//NSString *BeaconIdentifier = @"com.Technology.IBeacon";
//static NSString * const uuid  = @"FAAC0866-0CD8-4F5B-A4D4-BE52F88BE149";

@interface JVIBeaconManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CLBeaconIdentityConstraint *beaconConstraint;
@end

@implementation JVIBeaconManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

#pragma mark ----------- 初始化信标区域 -------------
- (void)config {
    self.locationManager = ({
        CLLocationManager *manager = [[CLLocationManager alloc]init];
        manager.delegate = self;
        manager;
    });
}

/**查询权限*/
- (BOOL)isMonitoringAvailable {
    BOOL availableMonitor = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    if (availableMonitor) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestAlwaysAuthorization];
                
            break;
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                NSLog(@"受限制或者拒绝");
            break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:{
                return YES;
            }
            break;
        }
    } else {
        NSLog(@"该设备不支持 CLBeaconRegion 区域检测");
    }
    
    return NO;
}

- (void)startScanBeacon {
    
    /**判断位置权限是否开启*/
    if (![self isMonitoringAvailable]) return;
    
    self.beaconRegion = ({
        CLBeaconRegion *beaconRegion;
        if (@available(iOS 13.0, *)) {
            beaconRegion = [[CLBeaconRegion alloc]initWithUUID:[[NSUUID alloc]initWithUUIDString:self.uuid] identifier:self.beaconIdentifier];
        } else {
            // Fallback on earlier versions
            beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc]initWithUUIDString:self.uuid] identifier:self.beaconIdentifier];
        }
        
        beaconRegion.notifyEntryStateOnDisplay = YES;
        beaconRegion;
    });
    
    if (@available(iOS 13.0, *)) {
        self.beaconConstraint = ({
            CLBeaconIdentityConstraint *beacon = [[CLBeaconIdentityConstraint alloc]initWithUUID:[[NSUUID alloc]initWithUUIDString:self.uuid]];
            beacon;
        });
    }

    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

// Monitoring成功对应回调函数
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

// 设备进入该区域时的回调
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"%s 通知进入region 区域",__func__);
    if (self.monitoringBlock) {
        self.monitoringBlock(region, YES);
    }
    /**开始监听周边的所有iBeacon设备*/
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

// 设备退出该区域时的回调
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"%s 通知离开region 区域",__func__);
    if (self.monitoringBlock) {
        self.monitoringBlock(region, NO);
    }
    /**结束监听周边的所有iBeacon设备*/
//    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

// Monitoring有错误产生时的回调
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(NSError *)error {
    NSLog(@"%s",__func__);
}


// 当程序被杀掉之后，进入ibeacon区域，或者在程序运行时锁屏／解锁 会回调此函数
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);
}


// Ranging成功对应回调函数 ios 13
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons satisfyingConstraint:(CLBeaconIdentityConstraint *)beaconConstraint  API_AVAILABLE(ios(13.0)){
    NSLog(@"%s region 发现的beacons:%@",__func__,beacons);
    if (self.rangeBeaconsBlock) {
        self.rangeBeaconsBlock(beacons);
    }
}

// Ranging成功对应回调函数
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"%s region 发现的beacons:%@",__func__,beacons);
    if (self.rangeBeaconsBlock) {
        self.rangeBeaconsBlock(beacons);
    }

}
// Ranging有错误产生时的回调
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"%s",__func__);
}
@end
