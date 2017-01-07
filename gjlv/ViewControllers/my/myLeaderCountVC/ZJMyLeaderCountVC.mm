//
//  ZJMyLeaderCountVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyLeaderCountVC.h"
#import "ZJLeaderCountCell.h"
#import "ZJRouteCell.h"
@interface ZJMyLeaderCountVC ()
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation ZJMyLeaderCountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"服务列表";
    
    [self getLeaderSrvList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark networking
-(void)getLeaderSrvList{
    NSDictionary *mparamDic = @{@"userId":ZJ_UserID,@"leaderId":[self.mSelectModel.mleaderId stringValue],@"pageIndex":@"1",@"pageSize":@"10"};
    [HttpApi getLeaderSrvList:mparamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJRouteModel class] fromJSONArray:responseBody[@"routes"] error:&error];
        
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [tableView registerNib:[UINib nibWithNibName:@"ZJLeaderCountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJLeaderCountCell"];
        ZJLeaderCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJLeaderCountCell"];
        [cell loadDataWithModel:self.mSelectModel];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJRouteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRouteCell"];
    ZJRouteCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRouteCell"];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
