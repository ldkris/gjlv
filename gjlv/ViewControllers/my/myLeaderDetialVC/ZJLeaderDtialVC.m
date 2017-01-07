//
//  ZJLeaderDtialVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJLeaderDtialVC.h"
#import "ZJLeaderDtialCell.h"
#import "ZJLeaderDtial1Cell.h"

#import "ZJMyLeaderCountVC.h"
#import "ZJAppraiseLeaderVC.h"
@interface ZJLeaderDtialVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_chat;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_phone;
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation ZJLeaderDtialVC{

    ZJLeaderDetailModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    [self.mBtn_chat.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_chat.layer setBorderWidth:0.5];
    
    [self.mBtn_phone.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_phone.layer setBorderWidth:0.5];

    [self getLeaderDetail];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"",@"服务次数:",@"擅长区域:",@"自我介绍:"];
    }
    return _mDataSoure;
}
#pragma mark networking
-(void)getLeaderDetail{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"leaderId":[self.mSelectModel.mleaderId stringValue]};
    [HttpApi getLeaderDetail:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        _model = [MTLJSONAdapter modelOfClass:[ZJLeaderDetailModel class] fromJSONDictionary:responseBody error:&error];
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickShareBtn:(id)sender {
    
    ZJAppraiseLeaderVC *tmepVC = [[ZJAppraiseLeaderVC alloc]init];
    [self.navigationController pushViewController:tmepVC animated:YES];
}
- (IBAction)onclickCallPhoneBtn:(id)sender {
    
    if (_model == nil) {
        return;
    }
    [MyFounctions callPhone:_model.mmobile];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [tableView registerNib:[UINib nibWithNibName:@"ZJLeaderDtialCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJLeaderDtialCell"];
        ZJLeaderDtialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJLeaderDtialCell"];
        [cell loadDataWithModel:_model];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJLeaderDtial1Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJLeaderDtial1Cell"];
    ZJLeaderDtial1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJLeaderDtial1Cell"];
    cell.mLab_Title.text = self.mDataSoure[indexPath.row];
    if (_model) {
        if (indexPath.row == 1) {
            cell.mLab_Sub.text = [[_model.msrvCount stringValue]stringByAppendingString:@"次"];
        }
        if (indexPath.row == 2) {
            cell.mLab_Sub.text = _model.mgoodArea;
        }
        if (indexPath.row == 3) {
            if (_model.mremarks == nil || _model.mremarks.length == 0) {
                _model.mremarks = @"无";
            }
            cell.mLab_Sub.text = _model.mremarks;
        }
    }
    return cell;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1) {
    ZJMyLeaderCountVC *tempVC = [[ZJMyLeaderCountVC alloc]init];
    tempVC.mSelectModel = _model;
    [self.navigationController pushViewController:tempVC animated:YES];
//    }
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
