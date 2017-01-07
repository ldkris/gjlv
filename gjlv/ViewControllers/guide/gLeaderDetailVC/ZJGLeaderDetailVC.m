//
//  ZJGLeaderDetailVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGLeaderDetailVC.h"
#import "ZJLeaderDtialCell.h"
#import "ZJLeaderDtial1Cell.h"
#import "ZJChatVC.h"
@interface ZJGLeaderDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_select;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_phone;
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation ZJGLeaderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"",@"服务次数:",@"擅长区域:",@"自我介绍:"];
    }
    return _mDataSoure;
}
#pragma mark event response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickShareBtn:(id)sender {
  
}
- (IBAction)onlcickSelectBtn:(id)sender {
    [[ZJAlertView shareSheet]showTitle:@"确认选择该领队？" cancelTitle:@"取消" comfirTitle:@"确定" cancelBlock:^(UIButton *sender) {
       
    
    } comfirBlock:^(UIButton *sender) {
        if (self.mSeleModel.mmobile) {
            NSString *chatter = [@"leader_"stringByAppendingString:self.mSeleModel.mmobile];
            if (chatter) {
                ZJChatVC *viewController = [[ZJChatVC alloc] initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
                viewController.title = self.mSeleModel.mnickname;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
        
    }];
}
- (IBAction)onclickPhoneBtn:(id)sender {
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [tableView registerNib:[UINib nibWithNibName:@"ZJLeaderDtialCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJLeaderDtialCell"];
        ZJLeaderDtialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJLeaderDtialCell"];
        [cell loadDataWithModel:self.mSeleModel];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJLeaderDtial1Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJLeaderDtial1Cell"];
    ZJLeaderDtial1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJLeaderDtial1Cell"];
    cell.mLab_Title.text = self.mDataSoure[indexPath.row];
    if (self.mSeleModel) {
        if (indexPath.row == 1) {
            cell.mLab_Sub.text = [[self.mSeleModel.msrvCount stringValue]stringByAppendingString:@"次"];
        }
        if (indexPath.row == 2) {
            cell.mLab_Sub.text = self.mSeleModel.mgoodArea;
        }
        if (indexPath.row == 3) {
            if (self.mSeleModel.mremarks == nil || self.mSeleModel.mremarks.length == 0) {
                self.mSeleModel.mremarks = @"无";
            }
            cell.mLab_Sub.text = self.mSeleModel.mremarks;
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
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
