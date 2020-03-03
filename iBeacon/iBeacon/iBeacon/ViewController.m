//
//  ViewController.m
//  iBeacon
//
//  Created by ZW on 2019/12/25.
//  Copyright © 2019 Jarvis. All rights reserved.
//

#import "ViewController.h"
#import "JVIBeacon.h"

@interface ViewController ()
//@property (nonatomic, strong) NSMutableArray <JVIBeacon*> *iBeacons;
@property (nonatomic, strong) JVIBeacon *iBeacon;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.iBeacons = [NSMutableArray new];
    
    self.iBeacon = [[JVIBeacon alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    for (int i = 0; i < 3; i++) {
        JVIBeacon *iBeacon = [[JVIBeacon alloc]init];
        [self.iBeacons addObject:iBeacon];
    }
     */
}

- (IBAction)advertise:(id)sender {
    
    /*
    for (int i = 0; i< self.iBeacons.count; i++) {
        JVIBeacon *iBeacon = self.iBeacons[i];
        [iBeacon startAdvertiseWithMajor:@(1) minor:@(10000+i)];
    }
     */
 
    [self.iBeacon startAdvertiseWithMajor:@(1) minor:@(10003)];
}

@end
