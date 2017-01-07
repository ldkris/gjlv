//
//  ZJRAddFirstStepVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRAddFirstStepVC.h"
#import "ZJRAFirstStepCell.h"
#import "ZJRAFHeaderwCell.h"
#import "ZJSearchPointVC.h"
#import "ZJRAddSecVC.h"
@interface ZJRAddFirstStepVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property (weak, nonatomic) IBOutlet UIView *mMark_formCity;
@property (weak, nonatomic) IBOutlet UIView *mMark_toCity;

@property (weak, nonatomic) IBOutlet UIButton *mBtn_formCity;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_toCity;

@end

@implementation ZJRAddFirstStepVC{
    BMKPoiInfo *_formCity;
    BMKPoiInfo *_toCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"线路规划";
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
    [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
    [mRightBtn addTarget:self action:@selector(onclickRight:) forControlEvents:UIControlEventTouchUpInside];
    [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mRightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:mRightBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
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
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{

    if (_formCity && _toCity) {
        ZJRAddSecVC *mTempVc = [[ZJRAddSecVC alloc]init];
        
        if (self.mDataSoure && self.mDataSoure.count>0) {
              mTempVc.mSysemRouteLines = self.mDataSoure;
        }else{
            mTempVc.mADDRoutesPoint = [NSMutableArray arrayWithObjects:_formCity,_toCity, nil];
        }
        mTempVc.title = [NSString stringWithFormat:@"%@-%@",_formCity.city,_toCity.city];
        [self.navigationController pushViewController:mTempVc animated:YES];
    }else{
        ShowMSG(@"请输入目的地或者出发城市");
    }

}
- (IBAction)onclickFromCityBtn:(UIButton *)sender {
    
    ZJSearchPointVC *tempVC = [[ZJSearchPointVC alloc]init];
    [tempVC backInfoBlock:^(BMKPoiInfo *info) {
        [sender setTitle:info.name forState:UIControlStateNormal];
        _formCity =info;
        if (_formCity && _toCity) {
            NSDictionary *mInfoDic = @{@"userId":ZJ_UserID,@"org":_formCity.city,@"dst":_toCity.city};
            [HttpApi searchRouteList:mInfoDic SuccessBlock:^(id responseBody) {
                NSError *error;
                NSArray *temps = [MTLJSONAdapter modelsOfClass:[ZJMyRoteModel class] fromJSONArray:responseBody[@"routes"] error:&error];
                //        LDLOG(@"%@",temps);
                if(!error){
                    [self.mDataSoure removeAllObjects];
                    [self.mDataSoure addObjectsFromArray:temps];
                    [self.mInfoTableView reloadData];
                }
            } FailureBlock:^(NSError *error) {
                
            }];
        }
    }];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickToCity:(UIButton *)sender {
    
    ZJSearchPointVC *tempVC = [[ZJSearchPointVC alloc]init];
    [tempVC backInfoBlock:^(BMKPoiInfo *info) {
        [sender setTitle:info.name forState:UIControlStateNormal];
         _toCity =info;
        if (_formCity && _toCity) {
            NSDictionary *mInfoDic = @{@"userId":ZJ_UserID,@"org":_formCity.city,@"dst":_toCity.city};
            [HttpApi searchRouteList:mInfoDic SuccessBlock:^(id responseBody) {
                NSError *error;
                NSArray *temps = [MTLJSONAdapter modelsOfClass:[ZJMyRoteModel class] fromJSONArray:responseBody[@"routes"] error:&error];
                if(!error){
                    [self.mDataSoure removeAllObjects];
                    [self.mDataSoure addObjectsFromArray:temps];
                    [self.mInfoTableView reloadData];
                }
            } FailureBlock:^(NSError *error) {
                
            }];
        }
    }];
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [tableView registerNib:[UINib nibWithNibName:@"ZJRAFHeaderwCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRAFHeaderwCell"];
        ZJRAFirstStepCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRAFHeaderwCell"];
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJRAFirstStepCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRAFirstStepCell"];
    ZJRAFirstStepCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRAFirstStepCell"];
    [cell loadCellDataSoure:self.mDataSoure[indexPath.row - 1]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    if (_formCity && _toCity) {
        ZJRAddSecVC *mTempVc = [[ZJRAddSecVC alloc]init];
        ZJMyRoteModel *model = self.mDataSoure[indexPath.row - 1];
        mTempVc.mSysemRouteLines = @[model];
        mTempVc.title = [NSString stringWithFormat:@"%@-%@",_formCity.city,_toCity.city];
        [self.navigationController pushViewController:mTempVc animated:YES];
    }
  
}
@end
