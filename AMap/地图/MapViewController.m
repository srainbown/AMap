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
    
    //初始化
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    //    如果您需要进入地图就显示  定位  小蓝点
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


@end
