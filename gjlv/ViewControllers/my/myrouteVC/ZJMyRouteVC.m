//
//  ZJMyRouteView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyRouteVC.h"
#import "ZJRouteCell.h"
#import "ZJRAddFirstStepVC.h"
#import "ZJCheckRouteVC.h"
#import "ZJInputInviteCodeVC.h"
#import "shareInviteCodeVC.h"
#import "ZJAppraiseLeaderVC.h"
#import "ZJRComfirInfoView.h"
#import "ZJSelectDateView.h"
#import "ZJRComfireViewCell1.h"
@interface ZJMyRouteVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property(nonatomic,strong)NSString *mType;
@property (weak, nonatomic) IBOutlet UIView *mBtnView;
@end

@implementation ZJMyRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = nil;
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    self.pageSize = 5;
    
    self.title = @"路线";
    NSArray *mArray = @[@"全部路线",@"待出行",@"待评价"];
    UIButton *mOldBtn;
    for (int i = 0; i<mArray.count; i++) {
        NSString *str = mArray[i];
        UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mTempBtn setTitle:str forState:UIControlStateNormal];
        [mTempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mTempBtn addTarget:self action:@selector(onclickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mTempBtn.titleLabel setFont:DEFAULT_FONT(13)];
        mTempBtn.tag = i +10;
        if(mTempBtn.tag == self.mSelectIndex){
            [mTempBtn setTitleColor:BG_Yellow forState:UIControlStateNormal];
        }else{
            [mTempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [mTempBtn setBackgroundColor:SL_GRAY];
        [self.mBtnView addSubview:mTempBtn];
        [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldBtn == nil) {
                make.left.mas_equalTo(0);
            }else{
             make.left.equalTo(mOldBtn.mas_right).with.offset(0);
            }
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(MainScreenFrame_Width/3);
        }];
        
        UIView *mMarkView = [[UIView alloc]init];
        [mMarkView setBackgroundColor:SL_GRAY_Hard];
        [self.mBtnView addSubview:mMarkView];
        [mMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldBtn == nil) {
                make.left.mas_equalTo(MainScreenFrame_Width/3);
            }else{
                make.left.equalTo(mOldBtn.mas_right).with.offset(0);
            }
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(1);
        }];

        mOldBtn = mTempBtn;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    [self.mInfoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    
    // 下拉刷新
    self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mDataSoure removeAllObjects];
        self.pageIndex = 1;
        if (self.mSelectIndex>10) {
            self.mType = [NSString stringWithFormat:@"%ld",self.mSelectIndex - 10];
            [self getRouteList:self.mType];
            return;
        }
        
        [self getRouteList:self.mType];
    }];
    // 马上进入刷新状态
    [self.mInfoTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.mInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getRouteList:self.mType];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
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
-(NSString *)mType{
    if (_mType == nil) {
        _mType = @"";
    }
    return _mType;
}
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark networking
-(void)getRouteList:(NSString *)type{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize],@"status":type};
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
        
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{
    
}
-(void)onclickTypeBtn:(UIButton *)sender{
    
    for (int i = 10; i<13; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        if (sender.tag == i) {
            [btn setTitleColor:BG_Yellow forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    switch (sender.tag) {
        case 10:
        //全部路线
        self.mType = @"";
       // [self getRouteList:@""];
        [self.mInfoTableView.mj_header beginRefreshing];
        break;
        case 11:
        //待出行
        self.mType = @"1";
        //[self getRouteList: self.mType];
         [self.mInfoTableView.mj_header beginRefreshing];
        break;
        case 12:
        //待评价
        self.mType = @"3";
       // [self getRouteList:self.mType];
         [self.mInfoTableView.mj_header beginRefreshing];
        break;
        
        default:
        break;
    }
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJRouteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRouteCell"];
    ZJRouteCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRouteCell"];
    if (self.mDataSoure && self.mDataSoure.count>0) {
        [cell loadDataSoreWithModel:self.mDataSoure[indexPath.row]];
    }
    __weak ZJRouteCell *weakCell = cell;
    __weak __typeof(self) weakSelf = self;
    
    [cell onclickInviteBtnBlock:^(UIButton *sender) {
        shareInviteCodeVC *tempVC = [[shareInviteCodeVC alloc]init];
        tempVC.mSelectmodel = self.mDataSoure[indexPath.row];
        [weakSelf.navigationController pushViewController:tempVC animated:YES];
    }];
    [cell onclickCheckBtnBlock:^(UIButton *sender) {
        ZJCheckRouteVC *tempVC = [[ZJCheckRouteVC alloc]init];
        tempVC.title = [NSString stringWithFormat:@"%@-%@",weakCell.mlab_title.text,weakCell.mlab_toCity.text];
        if (self.mDataSoure && self.mDataSoure.count>0) {
            tempVC.mMyRouteModel =self.mDataSoure[indexPath.row];
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
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
                    ZJMyRoteModel *model = weakSelf.mDataSoure[indexPath.row];
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
                ZJMyRoteModel *model = weakSelf.mDataSoure[indexPath.row];
                NSString *str = [NSString stringWithFormat:@"%D",cell.dis/1000];
                NSDictionary *paramDic = @{@"userId":ZJ_UserID,@"urId":model.mrid,@"mileage":str};
                [HttpApi updateRouteStatusTraveled:paramDic SuccessBlock:^(id responseBody) {
                    [self.mDataSoure removeAllObjects];
                    [self.mInfoTableView.mj_header beginRefreshing];
                } FailureBlock:^(NSError *error) {
                    
                }];
                
                break;}
            case 3:{
                //评价
                ZJMyRoteModel *model = weakSelf.mDataSoure[indexPath.row];
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
    
    ZJRouteCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ZJCheckRouteVC *tempVC = [[ZJCheckRouteVC alloc]init];
    tempVC.title = [NSString stringWithFormat:@"%@-%@",cell.mlab_title.text,cell.mlab_toCity.text];
    tempVC.mMyRouteModel =self.mDataSoure[indexPath.row];
    [self.navigationController pushViewController:tempVC animated:YES];
}

@end
