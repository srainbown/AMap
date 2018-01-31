//
//  ASingleLocationViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "ASingleLocationViewController.h"
#import "ASingleMapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ASingleLocationViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    
    [self getLocationData];
    [self showUI];
}
#pragma mark -- 懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    
    //带逆地理（坐标和地址信息），将YES改为NO，则不会返回地址信息
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
//        NSLog(@"location:%@", location);
        
        if (regeocode){
//            NSLog(@"reGeocode:%@", regeocode);
            
            [self.dataArray addObject:[NSString stringWithFormat:@"地址:%@",regeocode.formattedAddress]];
            [self.dataArray addObject:[NSString stringWithFormat:@"国家:%@",regeocode.country]];
            [self.dataArray addObject:[NSString stringWithFormat:@"省份:%@",regeocode.province]];
            [self.dataArray addObject:[NSString stringWithFormat:@"城市:%@",regeocode.city]];
            [self.dataArray addObject:[NSString stringWithFormat:@"城区:%@",regeocode.district]];
            [self.dataArray addObject:[NSString stringWithFormat:@"街道:%@",regeocode.street]];
            [self.dataArray addObject:[NSString stringWithFormat:@"门牌号:%@",regeocode.number]];
            [self.dataArray addObject:[NSString stringWithFormat:@"POIName:%@",regeocode.POIName]];
            [self.dataArray addObject:[NSString stringWithFormat:@"AOIName:%@",regeocode.AOIName]];
            [self.dataArray addObject:[NSString stringWithFormat:@"区号:%@",regeocode.citycode]];
            [self.dataArray addObject:[NSString stringWithFormat:@"邮编:%@",regeocode.adcode]];
            //刷新列表
            [self.tableView reloadData];
        }
    }];
}

-(void)showUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_Width, K_Height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *footView = [[UIView alloc]init];
    self.tableView.tableFooterView = footView;
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

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASingleMapViewController *vc = [[ASingleMapViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
