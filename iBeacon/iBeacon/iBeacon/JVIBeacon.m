//
//  JVIBeacon.m
//  iBeacon
//
//  Created by ZW on 2019/12/25.
//  Copyright © 2019 Jarvis. All rights reserved.
//

#import "JVIBeacon.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface JVIBeacon ()<CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, strong) NSNumber *minor;
@property (nonatomic, strong) String *uuid;
@end

@implementation JVIBeacon

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**实例化蓝牙外围设备*/
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
    }
    return self;
}


- (void)startAdvertiseWithMajor:(NSNumber *)major minor:(NSNumber *)minor {
    
    if(self.peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        /**设备蓝牙未开启*/
        NSLog(@"To configure your device as a beacon,");
        return;
    }
    self.major = major;
    self.minor = minor;
    
    [self.peripheralManager stopAdvertising];
    /**开始广播信号*/
    [self advertiseDevice:[self createBeaconRegion]];
}

#pragma mark ----------- 开始通过蓝牙广播信标信号 -------------
- (void)advertiseDevice:(CLBeaconRegion *)region {
    /**创建需要广播的信标数据*/
    NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:@(97)];
    
    if(peripheralData)
    {
        /**开始广播*/
        [self.peripheralManager startAdvertising:peripheralData];
    }
}
#pragma mark ----------- 创建信标区域 -------------
- (CLBeaconRegion *)createBeaconRegion {
    /**uuid 用来标识公司*/
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:self.uuid];
    /**主要值，用来识别一组相关联的 beacon，例如在连锁超市的场景中，每个分店的 beacon 应该拥有同样的 major。*/
//    NSNumber *major = @(1);
    /**次要值，则用来区分某个特定的 beacon*/
//    NSNumber *minor = @(10001);
    /**实例化信标区域*/
    CLBeaconRegion *region;
    if (@available(iOS 13.0, *)) {
        region = [[CLBeaconRegion alloc]initWithUUID:uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:@"com.Technology.IBeacon"];
        
    } else {
        region = [[CLBeaconRegion alloc]initWithProximityUUID:uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:@"com.Technology.IBeacon"];
    }
    return region;
}
#pragma mark ----------- CBPeripheralManagerDelegate -------------
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error {
    NSLog(@"%@",error);
    if (!error) {
        NSLog(@"开始广播信标信号");
    }
}
@end
