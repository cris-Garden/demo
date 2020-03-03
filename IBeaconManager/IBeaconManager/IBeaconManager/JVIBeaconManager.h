//
//  JVIBeaconManager.h
//  IBeaconManager
//
//  Created by ZW on 2019/12/25.
//  Copyright © 2019 Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^MonitoringSuccessBlock)(CLRegion *region, BOOL isIn);
typedef void(^RangeBeaconsSuccessBlock)(NSArray *beacons);
@interface JVIBeaconManager : NSObject
@property (nonatomic, copy) NSString *beaconIdentifier;
@property (nonatomic, copy) NSString *uuid;
/**进入/退出该区域*/
@property (nonatomic, copy) MonitoringSuccessBlock monitoringBlock;
/**发现该区域的所有iBeacon设备*/
@property (nonatomic, copy) RangeBeaconsSuccessBlock rangeBeaconsBlock;
/**开始扫描周边的固定UUID信标*/
- (void)startScanBeacon;
@end

NS_ASSUME_NONNULL_END
