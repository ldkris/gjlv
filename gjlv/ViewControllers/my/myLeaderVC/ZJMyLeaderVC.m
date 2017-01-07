//
//  ZJMyLeaderVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyLeaderVC.h"
#import "ZJMyleaderCell.h"
#import "ZJLeaderDtialVC.h"
@interface ZJMyLeaderVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJMyLeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"我的领队";
    
    // 下拉刷新
    self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.mDataSoure removeAllObjects];
        self.pageIndex = 1;
        [self getLeaderList];
        
    }];
    // 马上进入刷新状态
    [self.mInfoTableView.mj_header beginRefreshing];
    
//    // 上拉刷新
//    self.mInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self getLeaderList];
//    }];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray arrayWithArray:@[]];
    }
    return _mDataSoure;
}
#pragma mark netWorking
-(void)getLeaderList{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]};
    [HttpApi getLeaderList:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJLenderListModel class] fromJSONArray:responseBody[@"leaders"]  error:&error];
        if (temp.count == 0 && self.pageIndex>1) {
            [self.mInfoTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        if(!error){
            [self.mDataSoure addObjectsFromArray:temp];
            if (self.pageIndex == 1) {
                [self.mInfoTableView.mj_header endRefreshing];
            }else{
                [self.mInfoTableView.mj_footer endRefreshing];
            }
            self.pageIndex++;
            [self.mInfoTableView reloadData];
        }else{
            [self.mInfoTableView.mj_header endRefreshing];
            [self.mInfoTableView.mj_footer endRefreshing];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJMyleaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJMyleaderCell"];
    ZJMyleaderCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJMyleaderCell"];
    [cell loadDataWihtModel:self.mDataSoure[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJLeaderDtialVC *mTempVC = [[ZJLeaderDtialVC alloc]init];
    mTempVC.mSelectModel = self.mDataSoure[indexPath.row]; 
    [self.navigationController pushViewController:mTempVC animated:YES];
}

@end
