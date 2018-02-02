//
//  ASingleLocationViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "ASingleLocationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ASingleLocationViewController ()<UITableViewDataSource>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ASingleLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C1;
    self.navigationItem.title = @"单次定位";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshBtnClick)];

    [self getLocationData];
    [self refreshBtnClick];
}

#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, K_Width, K_Height) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        UIView *footView = [[UIView alloc]init];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

-(void)getLocationData{
    //初始化
    self.locationManager = [[AMapLocationManager alloc]init];
    //带逆地理信息的一次定位（返回坐标和地址信息）kCLLocationAccuracyHundredMeters偏差在百米左右，kCLLocationAccuracyBest可以获取精度很高的一次定位，偏差在十米左右，超时时间需要设置到10s，如果超时还没有获取到，会毁掉当前精度最高的结果。
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //定位超时时间，最低为2s
    self.locationManager.locationTimeout = 2;
    //逆地理请求超时时间，最低2s
    self.locationManager.reGeocodeTimeout = 2;
}

-(void)refreshBtnClick{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    //带逆地理（坐标和地址信息），将YES改为NO，则不会返回地址信息
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        [self.dataArray addObject:[NSString stringWithFormat:@"纬度:%.2f,经度:%.2f",location.coordinate.latitude,location.coordinate.longitude]];
        if (regeocode){
            NSArray *nameArray = @[@"地址", @"国家", @"省份", @"城市", @"城区", @"街道", @"门牌号", @"POIName", @"AOIName", @"区号", @"邮编"]; 
            NSArray *valueArray = @[regeocode.formattedAddress, regeocode.country, regeocode.province, regeocode.city, regeocode.district, regeocode.street, regeocode.number, regeocode.POIName, regeocode.AOIName, regeocode.citycode, regeocode.adcode];
            for (int i = 0 ; i < nameArray.count; i++) {
                if (valueArray.count > i) {
                    [self.dataArray addObject:[NSString stringWithFormat:@"%@:%@",nameArray[i],valueArray[i]]];
                }
            }
            //刷新列表
            [self.tableView reloadData];
        }
    }];
    
}

#pragma mark -- UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.dataArray.count > 0) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


@end
