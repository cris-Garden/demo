#  iBeacon 开发（二） （iOS）

#### 在文章开始先来了解什么是Beacon ？ Beacon的标准是什么？Beacon都有哪些使用场景？

+ 什么是Beacon ？
 > Beacon是使用蓝牙4.0（BLE）技术发射信号的小设备 
有效范围从几十厘米到几米，电池可用3年 
信号为单向发射，只能发送小数据量，例如一个128bit的ID 智能手机通常作为接收方；

+ Beacon的标准
> Beacon的标准包括信号数据的格式等，苹果和谷歌各有一套标准，苹果标准更早，谷歌的标准更加强大。 
Apple：iBeacon    2013年6月发布
Google：Eddystone    2015年7月发布
开源标准：AltBeacon.org    2014 （未出生，身已死）;
![iBeacon 和 EddyStone 比较](https://tva1.sinaimg.cn/large/006tNbRwgy1ga7wdry93sj30hs095dh1.jpg)

+ Beacon的使用场景
> 商品的近距离推广：超市，餐厅
信息查询：机场，铁路，风景点
货品跟踪：包裹跟踪，新秀丽旅行包
室内导航：商场，体育馆
近距离互动：建群，分享
【Physical Web】是谷歌2014年提出来的，它认为每个物理设备都应该有一个URI，通过软件可以将这些线上线下设备打通。

在上一篇文章中介绍了如何将iOS设备变成iBeacon设备发射信号，下面我将介绍iBeacon在iOS中的运用，就是如何利用APP结合iBeacon设备进行场景使用；

1、iBeacon在应用中的实例对象
> iBeacon 在 CoreLocation 框架中抽象为CLBeacon类, 该类有6个属性，分别是:
+ proximityUUID，是一个 NSUUID，用来标识公司。每个公司、组织使用的 iBeacon 应该拥有同样的 proximityUUID;
+ major，主要值，用来识别一组相关联的 beacon，例如在连锁超市的场景中，每个分店的 beacon 应该拥有同样的 major；
+ minor，次要值，则用来区分某个特定的 beacon；
+ proximity，远近范围的，一个枚举值。
>typedef NS_ENUM(NSInteger, CLProximity) {
    CLProximityUnknown, // 无效
    CLProximityImmediate,   //在几厘米内
    CLProximityNear,    //在几米内
    CLProximityFar  //超过 10 米以外，不过在测试中超不过10米就是far
}
+ accuracy，与iBeacon的距离。
+ rssi，信号轻度为负值，越接近0信号越强，等于0时无法获取信号强度

其中proximityUUID，major，minor 这三个属性组成 iBeacon 的唯一标识符。

2、iBeacon在iOS中的运用
##### 位置权限的申请
在info.plist中添加如下配置：
+ NSLocationAlwaysAndWhenInUseUsageDescription;  （应用使用期间）
+ NSLocationWhenInUseUsageDescription; （始终允许，iOS11新增）
+ NSLocationAlwaysUsageDescription;  (iOS11之前的始终允许，iOS11之后为使用期间)

##### 开启后台模式 Background Modes
![Background Modes](https://tva1.sinaimg.cn/large/006tNbRwgy1ga8qn01k4fj30pa06caan.jpg)

##### 代码实现

+ 初始化locationManager 
```
self.locationManager = ({
    CLLocationManager *manager = [[CLLocationManager alloc]init];
    manager.delegate = self;
    manager;
});

```
+ 初始化beaconRegion
> CLBeaconRegion类，提供了3个初始化方法:
```
/**初始化并返回以指定UUID为目标的信标为目标的区域对象。
iOS 13 系统下使用
*/
- (instancetype)initWithUUID:(NSUUID *)uuid identifier:(NSString *)identifier;
/**在iOS13已废除该方法*/
- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID identifier:(NSString *)identifier;

/**初始化并返回以指定UUID和主值为目标的信标为目标的区域对象。
iOS 13 系统下使用
*/
- (instancetype)initWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major identifier:(NSString *)identifier;
/**在iOS13已废除该方法*/
- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID major:(CLBeaconMajorValue)major identifier:(NSString *)identifier;

/**初始化并返回以指定的UUID，主要和次要值为目标的信标的区域对象。
iOS 13 系统下使用
*/
- (instancetype)initWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier;
- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier;
```
比如下面初始化只指定UUID为目标的信标的区域对象
```
self.beaconRegion = ({
    CLBeaconRegion *beaconRegion;
    if (@available(iOS 13.0, *)) {
        beaconRegion = [[CLBeaconRegion alloc]initWithUUID:[[NSUUID alloc]initWithUUIDString:uuid] identifier:BeaconIdentifier];
    } else {
        beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc]initWithUUIDString:uuid] identifier:BeaconIdentifier];
    }
    /*当设备的显示器打开时是否发送信标通知。*/
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion;
});
```
+ 初始化beaconConstraint
> CLBeaconIdentityConstraint类，该类以约束命名，是一个约束指定iBeacon身份特征,在iOS13后新提供的抽象类，提供了同样的三种方式初始化方法；
```
//创建仅包含UUID特征的信标身份约束，并为主要特征和次要特征使用通配符值。
- (instancetype)initWithUUID:(NSUUID *)uuid;
//创建一个包含UUID和主要特征的信标身份约束，并为次要特征使用通配符。
- (instancetype)initWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major;
//创建一个包含UUID，主要和次要特征的信标身份约束。
- (instancetype)initWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor;
```
比如在iOS13系统下初始化仅包含UUID特征的信标身份约束
```
if (@available(iOS 13.0, *)) {
    self.beaconConstraint = ({
        CLBeaconIdentityConstraint *beacon = [[CLBeaconIdentityConstraint alloc]initWithUUID:[[NSUUID alloc]initWithUUIDString:uuid]];
        beacon;
    });
}

```
+ 开始监听周边的信标信号
> 监听之前先要询问手机是否开启访问位置权限
```
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
```
> 发起监听
```
- (IBAction)scan:(id)sender {
    
    /**判断位置权限是否开启*/
    if (![self isMonitoringAvailable]) return;
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
}

```

> 有两种检测区域的方式startMonitoringForRegion 和 startRangingBeaconsInRegion
startMonitoringForRegion：可以用来在设备进入或退出某个地理区域时获得通知, 使用这种方法可以在应用程序的后台运行时检测 iBeacon，一个应用程序一次最多可以检测20个区域；对应的代理回调方法如下：
```
// Monitoring成功对应回调函数
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);
}

// 设备进入该区域时的回调
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);
}

// 设备退出该区域时的回调
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);
}

// Monitoring有错误产生时的回调
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(NSError *)error {
    NSLog(@"%s",__func__);
}

// 当程序被杀掉之后，进入ibeacon区域，或者在程序运行时锁屏／解锁 会回调此函数
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);
}
```
startRangingBeaconsInRegion：可以用来检测某区域内的所有 iBeacon 设备；对应的代理回调方法如下：
```
// Ranging成功对应回调函数
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"%s",__func__);
}
// Ranging有错误产生时的回调
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"%s",__func__);
}

```























