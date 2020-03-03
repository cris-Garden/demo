//
//  JVIBeacon.h
//  iBeacon
//
//  Created by ZW on 2019/12/25.
//  Copyright © 2019 Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JVIBeacon : NSObject
/**开始广播信标信号*/
- (void)startAdvertiseWithMajor:(NSNumber *)major minor:(NSNumber *)minor;
@end

NS_ASSUME_NONNULL_END
