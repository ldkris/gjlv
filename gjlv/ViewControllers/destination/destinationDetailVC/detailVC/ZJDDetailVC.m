//
//  ZJDDetailVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDetailVC.h"
#import "ZJDDContentCell.h"
#import "ZJDDCommentCell.h"
#import "ZJDDHeaderCell.h"
#import "ZJDDPLTopCell.h"
#import "ZJDDPLCell.h"
@interface ZJDDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *mBtn_PL;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_ZYG;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UIView *mCommView;
@property (weak, nonatomic) IBOutlet UITextField *mtf_comm;
@property (weak, nonatomic) IBOutlet UIButton *mbtn_submit;
@end

@implementation ZJDDetailVC{
    ZJSceneDetailModel *_mSceneDetailModel;
    NSMutableArray *_mSecneComms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mSecneComms = [NSMutableArray array];
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
//    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    self.mBtn_PL.layer.borderColor = SL_GRAY.CGColor;
    self.mBtn_PL.layer.borderWidth = 0.5f;
    self.mBtn_ZYG.layer.borderColor = SL_GRAY.CGColor;
    self.mBtn_ZYG.layer.borderWidth = 0.5f;
    
    self.mCommView.hidden = YES;
    
    // 下拉刷新
    self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_mSecneComms removeAllObjects];
        self.pageIndex = 1;
        [self getSceneCommentList];
        
    }];
    // 马上进入刷新状态
    [self.mInfoTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.mInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
       [self getSceneCommentList];
    }];
    
    [self getSceneDetail];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self unHideZJTbar];
    
    [self.mCommView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark networking
-(void)getSceneDetail{
    [_mSecneComms removeAllObjects];
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"sceneId":self.mSelectModel.msceneId};
    [[ZJNetWorkingHelper shareNetWork]getSceneDetail:mParaDic SuccessBlock:^(id responseBody) {
        NSError *error;
        ZJSceneDetailModel *tempModel = [MTLJSONAdapter modelOfClass:[ZJSceneDetailModel class] fromJSONDictionary:responseBody error:&error];
        _mSceneDetailModel = tempModel;
        
        // NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
        //[self.mInfoTableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
        //        [self.mInfoTableView reloadData];
        
        [_mSecneComms removeAllObjects];
        self.pageIndex = 1;
        [self getSceneCommentList];
        
        if([_mSceneDetailModel.misLike boolValue]){
            [self.mBtn_ZYG setTitle:@"取消点赞" forState:UIControlStateNormal];
        }else{
            [self.mBtn_ZYG setTitle:@"赞一个" forState:UIControlStateNormal];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

//点赞
-(void)likeScene{
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"sceneId":self.mSelectModel.msceneId};
    [[ZJNetWorkingHelper shareNetWork]likeScene:mParaDic SuccessBlock:^(id responseBody) {
        [self getSceneDetail];
    } FailureBlock:^(NSError *error) {
        
    }];
}
//评论
-(void)putSceneComment{
    if (self.mtf_comm.text == nil || self.mtf_comm.text.length ==0) {
        ShowMSG(@"请输入评论类容");
        return;
    }
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"sceneId":self.mSelectModel.msceneId,@"content":self.mtf_comm.text};
    [[ZJNetWorkingHelper shareNetWork]putSceneComment:mParaDic SuccessBlock:^(id responseBody) {
        [self.mtf_comm resignFirstResponder];
        [self getSceneDetail];
    } FailureBlock:^(NSError *error) {
        
    }];
}
//获取评论列表
-(void)getSceneCommentList{
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"sceneId":self.mSelectModel.msceneId,@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]};
    [[ZJNetWorkingHelper shareNetWork]getSceneCommentList:mParaDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tepmArry = [MTLJSONAdapter modelsOfClass:[ZJSceneCommModel class] fromJSONArray:responseBody[@"comments"] error:&error];
        if (tepmArry.count == 0 && self.pageIndex>1) {
            [self.mInfoTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        if (!error) {
            [_mSecneComms addObjectsFromArray:tepmArry];
            if (self.pageIndex == 1) {
                [self.mInfoTableView.mj_header endRefreshing];
            }else{
                [self.mInfoTableView.mj_footer endRefreshing];
            }
            self.pageIndex++;
          //  NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:1];
            [self.mInfoTableView reloadData];
        }else{
            [self.mInfoTableView.mj_header endRefreshing];
            [self.mInfoTableView.mj_footer endRefreshing];
        }
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark NSNotification
-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    self.mCommView.hidden = YES;
    self.mtf_comm.text = @"";
    [self.mCommView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}
-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    int keyBoardHeight = keyboardRect.size.height;
    [self.mCommView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyBoardHeight);
    }];
}
#pragma mark even response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickShareBtn:(id)sender {

}
- (IBAction)onclickCollectBrn:(id)sender {
    
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"destId":[self.mSelectDesModel.mdestId stringValue]};
    [[ZJNetWorkingHelper shareNetWork]putDest:mParamDic SuccessBlock:^(id responseBody) {
        [SVProgressHUD showSuccessWithStatus:responseBody[@"respMsg"]];
    } FailureBlock:^(NSError *error) {
        
    }];
}
- (IBAction)onclickPLBtn:(id)sender {
    self.mCommView.hidden = !self.mCommView.hidden;
}
- (IBAction)onclickSubmitBtn:(id)sender {
    [self putSceneComment];
}
- (IBAction)onclickZYGBtn:(id)sender {
    
    [self likeScene];
}
#pragma mark  tableViewDelegate && tableViewDatasoure
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        int mSection = 3;
        if (_mSceneDetailModel && _mSceneDetailModel.mgusers.count == 0) {
            mSection = 2;
        }
        return mSection;
    }
    return _mSecneComms.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if(indexPath.row == 1){
            [tableView registerNib:[UINib nibWithNibName:@"ZJDDContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDDContentCell"];
            ZJDDContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDDContentCell"];
            [cell loadCellDataWithModel:_mSceneDetailModel];
            return cell;
        }
        if (indexPath.row == 2) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJDDCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDDCommentCell"];
            ZJDDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDDCommentCell"];
            [cell loadCellDataWithModel:_mSceneDetailModel];
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"ZJDDHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDDHeaderCell"];
        ZJDDHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDDHeaderCell"];
        [cell loadCellDataWithModel:_mSceneDetailModel];
        return cell;
    }
    if (indexPath.row>0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJDDPLCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDDPLCell"];
        ZJDDPLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDDPLCell"];
        [cell loadCellDataWithModel:_mSecneComms[indexPath.row - 1]];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJDDPLTopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDDPLTopCell"];
    ZJDDPLTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDDPLTopCell"];
    [cell loadCellDataWithModel:_mSceneDetailModel];
    return cell;
   
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = BG_Yellow;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((64 - offsetY) / 64);
        self.mNavView.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        self.mNavView.backgroundColor = [color colorWithAlphaComponent:0];
    }
}
@end
