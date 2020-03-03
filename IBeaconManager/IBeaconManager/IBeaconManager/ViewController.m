//
//  ViewController.m
//  IBeaconManager
//
//  Created by ZW on 2019/12/24.
//  Copyright © 2019 Jarvis. All rights reserved.
//

#import "ViewController.h"
#import "JVIBeaconManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *uuid;
@property (weak, nonatomic) IBOutlet UITextField *idInput;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *beacons;
@property (nonatomic, strong) JVIBeaconManager *beaconManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uuid.text = @"FAAC0866-0CD8-4F5B-A4D4-BE52F88BE149";
    self.idInput.text = @"com.Technology.IBeacon";
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.beaconManager = ({
        JVIBeaconManager *manager = [[JVIBeaconManager alloc]init];
        manager;
    });
    
    [self.beaconManager setMonitoringBlock:^(CLRegion * _Nonnull region, BOOL isIn) {
        if (isIn) {
            NSLog(@"%s 通知进入region 区域:%@",__func__,region);
        } else {
            NSLog(@"%s 通知离开region 区域:%@",__func__,region);
        }
    }];
    typeof(self) __weak weakSelf = self;
    [self.beaconManager setRangeBeaconsBlock:^(NSArray * _Nonnull beacons) {
        weakSelf.beacons = beacons;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
           tableView.rowHeight = UITableViewAutomaticDimension;
          
           if (@available(iOS 11.0, *)) { //iOS 9的系统会报错
               tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
               tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
           }
           
           tableView.delegate = self;
           tableView.dataSource = self;
           
           [self.view addSubview:tableView];
           
           tableView;
    });
    
}
- (IBAction)scan:(id)sender {
    
    self.beaconManager.uuid = self.uuid.text;
    self.beaconManager.beaconIdentifier = self.idInput.text;
    [self.beaconManager startScanBeacon];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *identifier = @"beaconConstraint";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    CLBeacon *beacon = self.beacons[indexPath.row];
    if (@available(iOS 13.0, *)) {
        cell.textLabel.text = beacon.UUID.UUIDString;
    } else {
        cell.textLabel.text = beacon.proximityUUID.UUIDString;
    }
    return cell;
    
};

@end
