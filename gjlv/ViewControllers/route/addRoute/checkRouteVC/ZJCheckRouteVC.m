//
//  ZJCheckRouteVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCheckRouteVC.h"
#import "ZJAMenuBtn.h"
#import "ZJRSecCell.h"
#import "ZJRHeadCell.h"
#import "ZJRBottmCell.h"
#import "ZJRAddSecVC.h"
#import "ZJDepartVC.h"
@interface ZJCheckRouteVC ()
@property (weak, nonatomic) IBOutlet UIView *mBtnsView;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfir;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_select;
@end

@implementation ZJCheckRouteVC{
    NSArray * _BtnsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.mBtn_comfir.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_comfir.layer setBorderWidth:0.5];
    
    [self.mBtn_select.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_select.layer setBorderWidth:0.5];
    
    
    [self.mBtn_select setTitle:@"地图模式" forState:UIControlStateNormal];
    if(self.mMyRouteModel1){
        UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
        [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
        [mRightBtn addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
        [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
        [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mRightBtn setTitle:@"加入线路" forState:UIControlStateNormal];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:mRightBtn];
        [self.navigationItem setRightBarButtonItem:rightBtn];
    }
    
    [self loadMenuBtns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        if (self.mMyRouteModel) {
            _mDataSoure = [NSMutableArray arrayWithArray:self.mMyRouteModel.mafters];
        }else if (self.mMyRouteModel1){
            _mDataSoure = [NSMutableArray arrayWithArray:self.mMyRouteModel1.mafters];
        }else{
            _mDataSoure = [NSMutableArray array];
        }
    }
    
    return _mDataSoure;
}
#pragma makr event response
-(void)addContacts:(UIButton *)sender{
    ZJRAddSecVC *mTempVc = [[ZJRAddSecVC alloc]init];
    mTempVc.mSysemRouteLines = @[self.mMyRouteModel1];
    mTempVc.title = self.title;
    [self.navigationController pushViewController:mTempVc animated:YES];
}
-(void)onclickMenuBtn:(UIButton *)sender{
    
    for (ZJAMenuBtn *btn in _BtnsArray) {
        if (sender == btn) {
            [btn setBackgroundColor:[UIColor clearColor]];
        }else{
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
}
- (IBAction)onclickSelectBtn:(id)sender {
    ZJDepartVC *tempVC = [[ZJDepartVC alloc]init];
    if (self.mMyRouteModel) {
        tempVC.mMyRouteModel = self.mMyRouteModel;
    }
    if (self.mMyRouteModel1) {
        tempVC.mMyRouteModel1 = self.mMyRouteModel1;
    }
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickComfirBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark private
-(void)loadMenuBtns{
    ZJAMenuBtn *mTJbtn = [[NSBundle mainBundle]loadNibNamed:@"ZJAMenuBtn" owner:nil options:nil][0];
    [mTJbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mTJbtn setTag:0];
    [mTJbtn setBackgroundColor:[UIColor whiteColor]];
    [self.mBtnsView addSubview:mTJbtn];
    [mTJbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(MainScreenFrame_Width);
    }];
    
//    ZJAMenuBtn *mYTJbtn = [[NSBundle mainBundle]loadNibNamed:@"ZJAMenuBtn" owner:nil options:nil][0];
//    [mYTJbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [mYTJbtn setTag:1];
//    [mYTJbtn setBackgroundColor:[UIColor whiteColor]];
//    [self.mBtnsView addSubview:mYTJbtn];
//    [mYTJbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_offset(0);
//        make.left.equalTo(mTJbtn.mas_right).with.offset(1);
//        make.width.mas_offset(MainScreenFrame_Width/2);
//    }];
//    
//    if (_BtnsArray ==nil) {
//        _BtnsArray = @[mTJbtn,mYTJbtn];
//    }
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ZJRHeadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRHeadCell"];
        ZJRHeadCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRHeadCell"];
        NSError *error;
        ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:self.mDataSoure[indexPath.row] error:&error];
        if (!error) {
             [cell loadDataSoure:model];
        }
        
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if (indexPath.row == self.mDataSoure.count - 1) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ZJRBottmCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRBottmCell"];
        ZJRBottmCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRBottmCell"];
        NSError *error;
        ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:self.mDataSoure[indexPath.row] error:&error];
        if (!error) {
            [cell loadDataSoure:model];
        }
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJRSecCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRSecCell"];
    ZJRSecCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRSecCell"];
    NSError *error;
    ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:self.mDataSoure[indexPath.row] error:&error];
    if (!error) {
        [cell loadDataSoure:model];
    }
    cell.userInteractionEnabled = NO;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
