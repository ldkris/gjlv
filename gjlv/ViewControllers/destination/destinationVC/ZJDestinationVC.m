//
//  ZJDestinationVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDestinationVC.h"
#import "ZJDMenuCell.h"
#import "ZJDHotCell.h"
#import "ZJDHeaderView.h"
#import "ZJDTableviewCell.h"
#import "ZJSearchVC.h"
#import "ZJDestinationDetailVC.h"
@interface ZJDestinationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UITableView *mMenuTableView;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(retain,nonatomic)NSMutableArray *mMeunDataSoure;
@property(retain,nonatomic)NSMutableArray *mInfoDataSoure;
@end

@implementation ZJDestinationVC{
    NSIndexPath * mMeunSelectIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNavView.layer setBorderColor:[SL_GRAY CGColor]];
    [self.mNavView.layer setBorderWidth:1.0f];
    
    self.mMenuTableView.rowHeight = UITableViewAutomaticDimension;
    self.mMenuTableView.estimatedRowHeight = 100;
    self.mMenuTableView.tableFooterView = nil;
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = nil;
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    
    self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mInfoDataSoure removeAllObjects];
        [self getMenuList];
    }];
    // 马上进入刷新状态
    [self.mInfoTableView.mj_header beginRefreshing];
    
    
    //[self getMenuList];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self unHideZJTbar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  getter
-(NSMutableArray *)mMeunDataSoure{
    if (_mMeunDataSoure == nil) {
        _mMeunDataSoure = [NSMutableArray arrayWithArray:@[]];
    }
    return _mMeunDataSoure;
}
-(NSMutableArray *)mInfoDataSoure{
    if (_mInfoDataSoure == nil) {
        _mInfoDataSoure = [NSMutableArray arrayWithArray:@[]];
    }
    return _mInfoDataSoure;
}
#pragma mark networking
-(void)getMenuList{
    NSDictionary *mParaDic =@{@"userId":ZJ_UserID};
    [[ZJNetWorkingHelper shareNetWork]getMenuList:mParaDic SuccessBlock:^(id responseBody) {
        self.mMeunDataSoure = responseBody[@"menus"];
        [self.mMenuTableView reloadData];
        if (self.mMeunDataSoure.count>0) {
            NSDictionary *mDesParaDic = @{@"userId":ZJ_UserID,@"levelCode":self.mMeunDataSoure[2][@"levelCode"],@"pageIndex":@"1",@"pageSize":@"10"};
            [self getDestList:mDesParaDic];
        }
     
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getDestList:(NSDictionary *)desParam{
    [[ZJNetWorkingHelper shareNetWork]getDestList:desParam SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJDestModel class] fromJSONArray:responseBody[@"dests"] error:&error];
        [self.mInfoDataSoure addObjectsFromArray:temp];
        [self.mInfoTableView.mj_header endRefreshing];
        [self.mInfoTableView reloadData];
      
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickSelectCity:(id)sender {
    ZJSearchVC *tempVC = [[ZJSearchVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (tableView == self.mMenuTableView) {
        return 1;
//    }
//    return self.mInfoDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mMenuTableView) {
        return self.mMeunDataSoure.count;
    }
    return [self.mInfoDataSoure count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.mMenuTableView) {
        return 0.001f;
    }
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mMenuTableView) {
        return 50.0f;
    }
    if (indexPath.section == 0) {
        return 120.0f;
    }
    
    return 100.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mMenuTableView) {
        NSString *cellIndentifier = [NSString stringWithFormat:@"ZJDMenuCell%ld%ld",indexPath.section,indexPath.row];
        [tableView registerNib:[UINib nibWithNibName:@"ZJDMenuCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
        ZJDMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        }
        
        if (mMeunSelectIndex == nil) {
            if (indexPath.row == 0) {
                cell.mImg_select.image = [UIImage imageNamed:@"d_menu_hot"];
                [cell.mlab_name setTextColor:[UIColor whiteColor]];
            }else{
                cell.mImg_select.image = [UIImage imageNamed:@""];
                [cell.mlab_name setTextColor:[UIColor blackColor]];
            }
        }else{
            if (indexPath.row == mMeunSelectIndex.row) {
                cell.mImg_select.image = [UIImage imageNamed:@"d_menu_hot"];
                [cell.mlab_name setTextColor:[UIColor whiteColor]];
            }else{
                cell.mImg_select.image = [UIImage imageNamed:@""];
                [cell.mlab_name setTextColor:[UIColor blackColor]];
            }
        }
        
        if (indexPath.row == self.mMeunDataSoure.count - 1) {
            cell.mImg_mark.hidden = YES;
        }
        cell.mlab_name.text = self.mMeunDataSoure[indexPath.row][@"name"];
        return cell;
    }
    
//    if (indexPath.section == 0) {
    [tableView registerNib:[UINib nibWithNibName:@"ZJDHotCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDHotCell"];
    ZJDHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDHotCell"];
    [cell loadDataWithModel:self.mInfoDataSoure[indexPath.row]];
    return cell;
//    }
    
//    [tableView registerNib:[UINib nibWithNibName:@"ZJDTableviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDTableviewCell"];
//    ZJDTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDTableviewCell"];
//    [cell selecIndex:^(NSIndexPath *index) {
//        ZJDestinationDetailVC *tempVC = [[ZJDestinationDetailVC alloc]init];
//        [self.navigationController pushViewController:tempVC animated:YES];
//        
//    }];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.mMenuTableView) {
        mMeunSelectIndex = indexPath;
        [self.mMenuTableView reloadData];
        NSDictionary *mDesParaDic = @{@"userId":ZJ_UserID,@"levelCode":self.mMeunDataSoure[indexPath.row][@"levelCode"],@"pageIndex":@"1",@"pageSize":@"10"};
        [self.mInfoDataSoure removeAllObjects];
        [self getDestList:mDesParaDic];
        return;
    }
    if(indexPath.section == 0){
        ZJDestinationDetailVC *tempVC = [[ZJDestinationDetailVC alloc]init];
        tempVC.mSelectModel = self.mInfoDataSoure[indexPath.row];
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
@end
