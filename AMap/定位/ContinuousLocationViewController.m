//
//  ContinuousLocationViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "ContinuousLocationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ContinuousLocationViewController ()<AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UITableView *continuousTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ContinuousLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C1;
    
    [self continuousLocation];
}

#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)continuousTableView{
    if (_continuousTableView == nil) {
        _continuousTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_continuousTableView];
        _continuousTableView.delegate = self;
        _continuousTableView.dataSource = self;
        UIView *view = [[UIView alloc]init];
        _continuousTableView.tableFooterView = view;
    }
    return _continuousTableView;
}

//初始化
-(void)continuousLocation{
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    //设置定位最小更新距离
    self.locationManager.distanceFilter = 50;
    //是否返回逆地理信息
    self.locationManager.locatingWithReGeocode = YES;
    //开始持续定位
    [self.locationManager startUpdatingLocation];
    //如果需要持续返回逆地理信息
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark -- AMapLocationManagerDelegate
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    [self.dataArray removeAllObjects];
    [self.continuousTableView reloadData];
    
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
        [self.continuousTableView reloadData];
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"continuousCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.dataArray.count > 0) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark --UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
