//
//  ZJRouteVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRouteVC.h"
#import "ZJRouteCell.h"
#import "ZJRAddFirstStepVC.h"
#import "ZJCheckRouteVC.h"
#import "ZJInputInviteCodeVC.h"
#import "shareInviteCodeVC.h"
#import "ZJAppraiseLeaderVC.h"
#import "ZJRComfirInfoView.h"
#import "ZJSelectDateView.h"
#import "ZJRComfireViewCell1.h"
@interface ZJRouteVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property(nonatomic,retain)NSMutableArray *mSearchResult;
@end

@implementation ZJRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"路线";
    
    self.pageSize = 5;
    
    [self.mNavView setBackgroundColor:BG_Yellow];
    
    [self.mTF_input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self.mInfoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    [self unHideZJTbar];
    
    
    // 下拉刷新
    self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self.mDataSoure removeAllObjects];
        self.pageIndex = 1;        
        [self getRouteList];
        
    }];
    // 马上进入刷新状态
    [self.mInfoTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.mInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
          [self getRouteList];
    }];
    

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJRouteCell class]]) {
            ZJRouteCell *cell = tempCell;
            [cell unCellSetMapDelagete];
        }
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJRouteCell class]]) {
            ZJRouteCell *cell = tempCell;
            [cell cellSetMapDelagete];
        }
    }
}
-(void)dealloc{
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJRouteCell class]]) {
            ZJRouteCell *cell = tempCell;
            [cell mapViewDelloc];
        }
    }}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
-(NSMutableArray *)mSearchResult{
    if (_mSearchResult == nil) {
        _mSearchResult = [NSMutableArray array];
    }
    return _mSearchResult;
}
#pragma mark networking
-(void)getRouteList{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]};
    [HttpApi getRouteList:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temps = [MTLJSONAdapter modelsOfClass:[ZJMyRoteModel class] fromJSONArray:responseBody[@"routes"] error:&error];
        if (temps.count == 0 && self.pageIndex>1) {
            [self.mInfoTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        if(!error){
           
            [self.mDataSoure addObjectsFromArray:temps];
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
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{
    
}
- (void)textFieldDidChange:(UITextView *)textField {
    if ([textField.text isEqualToString:@""]) {
        self.mSearchResult = nil;
        [self.mInfoTableView reloadData];
    }
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.mSearchResult removeAllObjects];
    for (ZJMyRoteModel *model in self.mDataSoure) {
        if ([model.mrname containsString:textField.text]) {
            [self.mSearchResult addObject:model];
        }
    }
    [self.mInfoTableView reloadData];
    return YES;
}
- (IBAction)onclickAddBtn:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"自驾游" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"新增路线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJRAddFirstStepVC *tempVC = [[ZJRAddFirstStepVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
        
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"好友邀请路线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJInputInviteCodeVC *tempVC = [[ZJInputInviteCodeVC alloc]init];
        
        [self.navigationController pushViewController:tempVC animated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mSearchResult.count>0) {
        return self.mSearchResult.count;
    }
    
   return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJRouteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRouteCell"];
    ZJRouteCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRouteCell"];
    if (self.mSearchResult.count>0) {
        [cell loadDataSoreWithModel:self.mSearchResult[indexPath.row]];
    }else{
        if (self.mDataSoure && self.mDataSoure.count>0) {
            [cell loadDataSoreWithModel:self.mDataSoure[indexPath.row]];
        }
    }
    __weak ZJRouteCell *weakCell = cell;
    __weak __typeof(self) weakSelf = self;
    
    [cell onclickInviteBtnBlock:^(UIButton *sender) {
        shareInviteCodeVC *tempVC = [[shareInviteCodeVC alloc]init];
        if (self.mSearchResult.count>0) {
            tempVC.mSelectmodel = self.mSearchResult[indexPath.row];
        }else{
            tempVC.mSelectmodel = self.mDataSoure[indexPath.row];
        }
        [weakSelf.navigationController pushViewController:tempVC animated:YES];
    }];
    [cell onclickCheckBtnBlock:^(UIButton *sender) {
        ZJCheckRouteVC *tempVC = [[ZJCheckRouteVC alloc]init];
        tempVC.title = [NSString stringWithFormat:@"%@-%@",weakCell.mlab_title.text,weakCell.mlab_toCity.text];
        if (self.mSearchResult.count>0) {
            tempVC.mMyRouteModel =self.mSearchResult[indexPath.row];
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
        }else{
            if (self.mDataSoure && self.mDataSoure.count>0) {
                tempVC.mMyRouteModel =self.mDataSoure[indexPath.row];
                [weakSelf.navigationController pushViewController:tempVC animated:YES];
            }
        }
   
    }];
    [cell onclickStatusBtnBlock:^(UIButton *sender) {
        switch (sender.tag) {
            case 1:{
                //出行
                ZJRComfirInfoView* _comfirView = [[NSBundle mainBundle]loadNibNamed:@"ZJRComfirInfoView" owner:nil options:nil][0];
                [self.tabBarController.view addSubview:_comfirView];
                __weak typeof(self) weakself = self;
                [_comfirView onclickselectDateBlock:^(UIButton *sender) {
                    ZJSelectDateView *tempView = [[NSBundle mainBundle]loadNibNamed:@"ZJSelectDateView" owner:nil options:nil][0];
                    [_comfirView addSubview:tempView];
                    [_comfirView bringSubviewToFront:tempView];
                    [tempView onclickComfirBlock:^(NSString *sender) {
                        [tempView removeFromSuperview];
                        _comfirView.dateStr = sender;
                        ZJRComfireViewCell1 *cell4 = [_comfirView.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        cell4.mLab_dateTitle.text = sender;
                    }];
                    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.right.bottom.mas_equalTo(0);
                    }];
                    
                }];
                
                [_comfirView onclickComfirBlock:^(UIButton *sender) {
                    NSMutableDictionary *mParam = [NSMutableDictionary dictionary];
                    [mParam setValue:ZJ_UserID forKey:@"userId"];
                    [mParam setValue:_comfirView.adultNum forKey:@"adultcount"];
                    [mParam setValue:_comfirView.childNum forKey:@"childrencount"];
                    [mParam setValue:_comfirView.carNum forKey:@"carcount"];
                    [mParam setValue:_comfirView.dateStr forKey:@"beginDate"];
                    ZJMyRoteModel *model;
                    if (self.mSearchResult.count>0) {
                        model  = weakSelf.mSearchResult[indexPath.row];
                    }else{
                        model  = weakSelf.mDataSoure[indexPath.row];
                    }
                    [mParam setValue:model.mrid forKey:@"urId"];
                    [HttpApi putTravelInfo:mParam SuccessBlock:^(id responseBody) {
                        ZJMyRoteModel *model = weakSelf.mDataSoure[indexPath.row];
                        NSDictionary *paramDic = @{@"userId":ZJ_UserID,@"urId":model.mrid};
                        [HttpApi updateRouteStatusTraveling:paramDic SuccessBlock:^(id responseBody) {
                            [self.mDataSoure removeAllObjects];
                            [self.mInfoTableView.mj_header beginRefreshing];
                        } FailureBlock:^(NSError *error) {
                            
                        }];

                    } FailureBlock:^(NSError *error) {
                        
                    }];
                }];
                [_comfirView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.mas_equalTo(0);
                }];
                
                break;}
            case 2:{
                //结束
                ZJMyRoteModel *model;
                if (self.mSearchResult.count>0) {
                    model  = weakSelf.mSearchResult[indexPath.row];
                }else{
                    model  = weakSelf.mDataSoure[indexPath.row];
                }
                NSString *str = [NSString stringWithFormat:@"%D",cell.dis/1000];
                NSDictionary *paramDic = @{@"userId":ZJ_UserID,@"urId":model.mrid,@"mileage":str};
                [HttpApi updateRouteStatusTraveled:paramDic SuccessBlock:^(id responseBody) {
                    [self.mDataSoure removeAllObjects];
                    //[self getRouteList];
                    [self.mInfoTableView.mj_header beginRefreshing];
                } FailureBlock:^(NSError *error) {
                    
                }];
                
                break;}
            case 3:{
                //评价
                ZJMyRoteModel *model;
                if (self.mSearchResult.count>0) {
                    model  = weakSelf.mSearchResult[indexPath.row];
                }else{
                    model  = weakSelf.mDataSoure[indexPath.row];
                }
                if (model) {
                    ZJAppraiseLeaderVC *tmepVC = [[ZJAppraiseLeaderVC alloc]init];
                    tmepVC.mMyRouteModel = model;
                    [weakSelf.navigationController pushViewController:tmepVC animated:YES];
                }
             
                break;}
            default:
                break;
        }
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    ZJRouteCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    ZJCheckRouteVC *tempVC = [[ZJCheckRouteVC alloc]init];
//    tempVC.title = [NSString stringWithFormat:@"%@-%@",cell.mlab_title.text,cell.mlab_toCity.text];
//    tempVC.mMyRouteModel =self.mDataSoure[indexPath.row];
//    [self.navigationController pushViewController:tempVC animated:YES];
}

@end
