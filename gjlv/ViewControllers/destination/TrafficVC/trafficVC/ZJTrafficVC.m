//
//  ZJTrafficVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJTrafficVC.h"

#import "ZJTrafficCell.h"
#import "ZJUpTrafficView.h"

#import "ZJSelectMapVC.h"
@interface ZJTrafficVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property(nonatomic,retain)ZJUpTrafficView *tempView;
@end

@implementation ZJTrafficVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"实时路况";
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
    
    UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
    [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
    [mRightBtn addTarget:self action:@selector(onclickRight:) forControlEvents:UIControlEventTouchUpInside];
    [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mRightBtn setTitle:@"上报路况" forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:mRightBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tempView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     _tempView.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onclickRight:(UIButton *)sender{
    [ZJMenuAlertview showWithTitleS:@[@"封路",@"施工",@"积水",@"故障",@"拥堵",@"车祸"] andImages:@[@"t_fl",@"t_sg",@"t_js",@"t_gz",@"t_yd",@"t_ch"]  Block:^(NSIndexPath *index) {
        LDLOG(@"选择 ====== %ld",index.row);
        [ZJMenuAlertview dismiss];
        
        if (_tempView == nil) {
            _tempView = [[NSBundle mainBundle]loadNibNamed:@"ZJUpTrafficView" owner:nil options:nil][0];
        }
        [self.navigationController.view addSubview:_tempView];
        [_tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        [_tempView onclickSelectMapBtn:^(UIButton *sender) {
            ZJSelectMapVC *mSelectVc = [[ZJSelectMapVC alloc]init];
            [self.navigationController pushViewController:mSelectVc animated:YES];
        }];
        
    }];
}
- (IBAction)onclickUpBtn:(UIButton *)sender {
     [sender setImage:[UIImage imageNamed:@"t_down"] forState:UIControlStateSelected];
     [sender setImage:[UIImage imageNamed:@"t_up"] forState:UIControlStateNormal];
    sender.selected =!sender.selected;
    if ( sender.selected) {
        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(40);
        }];
    }else{
        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(MainScreenFrame_Height- 250);
        }];

    }
}
#pragma mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mButton setImage:[UIImage imageNamed:@"t_up"] forState:UIControlStateNormal];
//    return mButton;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJTrafficCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJTrafficCell"];
    
    ZJTrafficCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJTrafficCell"];
    return cell;
}
@end
