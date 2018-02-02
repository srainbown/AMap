//
//  MapViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface MapViewController ()

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C1;
    self.navigationItem.title = @"地图";
    
    //初始化地图
    [self creareMapView];
    //自定义小蓝点
    [self customSmallBlueDots];
}

-(void)creareMapView{
    //初始化
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, K_Width, K_Height - 64 - 49)];
    [self.view addSubview:self.mapView];
    
    //如果需要进入地图就显示  定位  小蓝点  ，需要下面两行打码
    self.mapView.showsUserLocation = YES;
    //不追踪用户的location更新
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    /*
     iOS 地图 SDK V5.0.0 版本起支持，自定义定位小蓝点
     初始化MAUserLocationRepresentation即可。
     */
    
    //显示室内地图
    self.mapView.showsIndoorMap = YES;
    //地图的缩放的范围3 ~ 19
    [self.mapView setZoomLevel:17.5 animated:YES];
}

//自定义小蓝点
-(void)customSmallBlueDots{
    //初始化
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc]init];
    //精度圈是否显示，默认为YES
//    r.showsAccuracyRing = NO;
    //是否显示蓝点方向,默认为YES
//    r.showsHeadingIndicator = NO;
    //精度圈填充颜色
//    r.fillColor = [UIColor grayColor];
    //精度圈边线颜色
//    r.strokeColor = [UIColor blueColor];
    //精度圈边线宽度
//    r.lineWidth = 2;
    //精度圈是否显示律动效果
    r.enablePulseAnnimation = NO;
    //调整定位蓝点的背景颜色
//    r.locationDotBgColor = [UIColor greenColor];
    //调整定位蓝点的颜色
//    r.locationDotFillColor = [UIColor redColor];
    //调整定位蓝点的图标
    r.image = [UIImage imageNamed:@"bullet_red"];
    //更新蓝点
    [self.mapView updateUserLocationRepresentation:r];
}

@end
