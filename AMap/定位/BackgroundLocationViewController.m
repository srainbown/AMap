//
//  BackgroundLocationViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "BackgroundLocationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface BackgroundLocationViewController ()<AMapLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BackgroundLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C1;
    
    /*
     需要在target  --  Capabilities    --  Background Modes中打开     --  Location updates
     */
    [self backgroungLocation];
}

#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)bgTableView{
    if (_bgTableView == nil) {
        _bgTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_bgTableView];
        _bgTableView.dataSource = self;
        _bgTableView.delegate = self;
        UIView *footView = [[UIView alloc]init];
        _bgTableView.tableFooterView = footView;
    }
    return _bgTableView;
}

-(void)backgroungLocation{
    //初始化
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    //设置定位最新最小更新距离，单位米
    self.locationManager.distanceFilter = 50;
    //后台定位是否返回逆地理信息，默认为NO
    self.locationManager.locatingWithReGeocode = YES;
    
    //iOS 9.0(不包含9.0)之前设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //iOS 9.0(包含9.0)之后新特性，允许出现这种场景，同一APP多个LocationManager:一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>9) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    //开始持续定位
    [self.locationManager startUpdatingLocation];
    
    //持续定位返回逆地理信息
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

#pragma mark -- AMapLocationManagerDelegate
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    [self.dataArray removeAllObjects];
    [self.bgTableView reloadData];
    
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [self.dataArray addObject:[NSString stringWithFormat:@"纬度:%.2f,经度:%.2f",location.coordinate.latitude,location.coordinate.longitude]];
    if (reGeocode){
        NSArray *nameArray = @[@"地址", @"国家", @"省份", @"城市", @"城区", @"街道", @"门牌号", @"POIName", @"AOIName", @"区号", @"邮编"];
        NSArray *valueArray = @[reGeocode.formattedAddress, reGeocode.country, reGeocode.province, reGeocode.city, reGeocode.district, reGeocode.street, reGeocode.number, reGeocode.POIName, reGeocode.AOIName, reGeocode.citycode, reGeocode.adcode];
        for (int i = 0 ; i < nameArray.count; i++) {
            if (valueArray.count > i) {
                [self.dataArray addObject:[NSString stringWithFormat:@"%@:%@",nameArray[i],valueArray[i]]];
            }
        }
        //刷新列表
        [self.bgTableView reloadData];
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"bgCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.dataArray.count > 0) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
