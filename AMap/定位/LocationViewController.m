//
//  LocationViewController.m
//  AMap
//
//  Created by CC on 2018/1/31.
//  Copyright © 2018年 mangxing. All rights reserved.
//

#import "LocationViewController.h"
#import "ASingleLocationViewController.h"
#import "BackgroundLocationViewController.h"
#import "ContinuousLocationViewController.h"

@interface LocationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *LocationTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = C1;
    
    [self.view addSubview:self.LocationTableView];
    NSArray *array = [NSArray arrayWithObjects:@"单次定位",@"后台定位",@"持续定位", nil];
    [self.dataArray addObjectsFromArray:array];
}

#pragma mark -- 懒加载
-(UITableView *)LocationTableView{
    if (_LocationTableView == nil) {
        _LocationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, K_Width, K_Height - 49 - 100) style:UITableViewStylePlain];
        _LocationTableView.delegate = self;
        _LocationTableView.dataSource = self;
        _LocationTableView.backgroundColor = C1;
        UIView *footView = [[UIView alloc]init];
        _LocationTableView.tableFooterView = footView;
    }
    return _LocationTableView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = C2;
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ASingleLocationViewController *vc = [[ASingleLocationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        BackgroundLocationViewController *vc = [[BackgroundLocationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        ContinuousLocationViewController *vc = [[ContinuousLocationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
