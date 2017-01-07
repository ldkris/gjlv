//
//  ZJHomeVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJHomeVC.h"
#import "ZJHomeCell.h"
#import "ZJHomeMapCell.h"
#import "ZJLoginVC.h"
#import "ZJSearchVC.h"
#import "SLWebViewController.h"
#import "ZJRAddFirstStepVC.h"
#import "ZJCheckRouteVC.h"
#import "ZJTabBarVC.h"
@interface ZJHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property (weak, nonatomic) IBOutlet UIButton *btn_City;
@property(nonatomic,retain) ImagePlayerView * mImagePlayerView;
@end

@implementation ZJHomeVC{
   NSArray *_mHomeAD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    self.pageSize = 5;
    [self.mNavView setBackgroundColor:BG_Yellow];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self unHideZJTbar];
    
    if(ZJ_UserID == nil){
        ZJLoginVC *mLoginVc = [[ZJLoginVC alloc]init];
        BaseNavigationgVC *mLoginNaviGationVC = [[BaseNavigationgVC alloc]initWithRootViewController:mLoginVc];
        [self.tabBarController presentViewController:mLoginNaviGationVC animated:YES completion:nil];
    }else{
        
        // 下拉刷新
        self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self.mDataSoure removeAllObjects];
            self.pageIndex = 1;
            
            NSDictionary *mParamDic = @{@"userId":ZJ_UserID};
            [HttpApi getAdvert:mParamDic SuccessBlock:^(id responseBody) {
                _mHomeAD = responseBody[@"adverts"];
                [self.mImagePlayerView reloadData];
                [self getRecommendList];
                
            } FailureBlock:^(NSError *error) {
                
            }];
        }];
        // 马上进入刷新状态
        [self.mInfoTableView.mj_header beginRefreshing];
        
        // 上拉刷新
        self.mInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [self getRecommendList];
        }];
        
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [super viewDidAppear:animated];
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJHomeMapCell class]]) {
            ZJHomeMapCell *cell = tempCell;
            [cell unCellSetMapDelagete];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJHomeMapCell class]]) {
            ZJHomeMapCell *cell = tempCell;
            [cell cellSetMapDelagete];
        }
    }
}
-(void)dealloc{
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJHomeMapCell class]]) {
            ZJHomeMapCell *cell = tempCell;
            [cell mapViewDelloc];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
-(ImagePlayerView *)mImagePlayerView{
    if (_mImagePlayerView == nil) {
        _mImagePlayerView =[[ImagePlayerView alloc] init];
        _mImagePlayerView.scrollInterval = 3.0f;
        // adjust pageControl position
        _mImagePlayerView.pageControlPosition = ICPageControlPosition_BottomRight;
        _mImagePlayerView.hidePageControl = NO;
        _mImagePlayerView.endlessScroll = YES;
        
        [_mImagePlayerView.pageControl setCurrentPageIndicatorTintColor:BG_Yellow];
        [_mImagePlayerView.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        [_mImagePlayerView reloadData];
    }
    
    [_mImagePlayerView setImagePlayerViewDelegate:(id)self];
    return _mImagePlayerView;
}
#pragma mark netwokring
-(void)getRecommendList{
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]};
    [HttpApi getRecommendList:mParaDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJRouteModel class] fromJSONArray:responseBody[@"routes"] error:&error];
        if (temp.count == 0 && self.pageIndex>1) {
            [self.mInfoTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        if (!error) {
            [self.mDataSoure addObjectsFromArray:temp];
            if (self.pageIndex == 1) {
                [self.mInfoTableView.mj_header endRefreshing];
            }else{
                [self.mInfoTableView.mj_footer endRefreshing];
            }
            self.pageIndex++;
        }else{
            [self.mInfoTableView.mj_header endRefreshing];
            [self.mInfoTableView.mj_footer endRefreshing];
        }
        
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickSelectCity:(id)sender {
    ZJSearchVC *tempVC = [[ZJSearchVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickMessageBtn:(id)sender {
    ZJTabBarVC *tabVC = (ZJTabBarVC *)self.tabBarController;
    [tabVC selectVCWithIndex:2];
}
- (IBAction)onclickSearchDesBtn:(id)sender {
    ZJSearchVC *tempVC = [[ZJSearchVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJHomeCell"];
        ZJHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJHomeCell"];
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJHomeMapCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJHomeMapCell"];
    ZJHomeMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJHomeMapCell"];
    [cell loadMapline:self.mDataSoure[indexPath.row - 1]];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.mImagePlayerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ZJRAddFirstStepVC *tempVC = [[ZJRAddFirstStepVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
        return;
    }
    
    ZJCheckRouteVC *tempVC = [[ZJCheckRouteVC alloc]init];
    ZJRouteModel *temp = self.mDataSoure[indexPath.row - 1];
    tempVC.title = temp.mrname;
    tempVC.mMyRouteModel1 = temp;
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    if (_mHomeAD.count ==0) {
        return 1;
    }
    return  _mHomeAD.count;
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    if (_mHomeAD.count>0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:_mHomeAD[index][@"photo"]] placeholderImage:[UIImage imageNamed:@"home_banner"]];
        return;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"home_banner"]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
//    NSLog(@"did tap index = %d", (int)index);
    SLWebViewController *mTemp = [[SLWebViewController alloc]init];
    if (_mHomeAD.count>0) {
        mTemp.urlStr = _mHomeAD[index][@"url"];
        mTemp.title = _mHomeAD[index][@"title"];
        if (mTemp.title.length>0) {
            [self.navigationController pushViewController:mTemp animated:YES];
        }
    }else{
        //        mTemp.urlStr = @"https://www.baidu.com";
    }

}
@end
