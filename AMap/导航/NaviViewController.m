//
//  NaviViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "NaviViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface NaviViewController ()

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C1;
    self.navigationItem.title = @"导航";
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, K_Width, K_Height - 64 - 49)];
    [self.view addSubview:self.mapView];
    //显示定位小蓝点
    self.mapView.showsUserLocation = YES;
    //追踪用户的location与heading更新
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //显示室内地图
    self.mapView.showsIndoorMap = YES;
    //缩放比例，3 ~ 19
    [self.mapView setZoomLevel: 19 animated:YES];
    
}


@end
