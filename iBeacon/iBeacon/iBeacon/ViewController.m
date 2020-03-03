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
@property (weak, nonatomic) IBOutlet UITextField *uuid;

@property (weak, nonatomic) IBOutlet UITextField *major;

@property (weak, nonatomic) IBOutlet UITextField *minor;

@property (weak, nonatomic) IBOutlet UITextField *idInput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uuid.text = @"FAAC0866-0CD8-4F5B-A4D4-BE52F88BE149";
    self.major.text = @"1";
    self.minor.text = @"10003";
    self.idInput.text = @"com.Technology.IBeacon";
    
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
 
    NSNumber *major = [NSNumber numberWithInt:self.major.text.intValue];
    NSNumber *minor = [NSNumber numberWithInt:self.minor.text.intValue];
    self.iBeacon.uuid = self.uuid.text;
    self.iBeacon.idText = self.idInput.text;
    [self.iBeacon startAdvertiseWithMajor:major minor:minor];
}

@end
