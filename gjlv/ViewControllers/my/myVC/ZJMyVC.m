//
//  ZJMyVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyVC.h"
#import "ZJMyCell.h"
#import "ZJDMyCell1.h"
#import "ZJDMyCell2.h"

#import "ZJMyInfoVC.h"
#import "ZJMyRouteVC.h"
#import "ZJMyCollectionVC.h"
#import "ZJMyFootMarkVC.h"
#import "ZJMyLeaderVC.h"
#import "ZJSettingVC.h"
#import "ZJOpinionVC.h"
@interface ZJMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@end

@implementation ZJMyVC{
    ZJUserInfoModel*_userModel;
    NSString *_DCXCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self unHideZJTbar];
    
    [self getInfo];//获取个人信息
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark networking
-(void)getInfo{
    [[ZJNetWorkingHelper shareNetWork]mGetMyInfo:@{@"userId":ZJ_UserID} SuccessBlock:^(id responseBody) {
        NSError *error;
        _userModel = [MTLJSONAdapter modelOfClass:[ZJUserInfoModel class] fromJSONDictionary:responseBody error:&error];
        [ZJSingleHelper shareNetWork].mUserInfo = _userModel;
        [self getWaitTravelCount];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getWaitTravelCount{
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID};
    [HttpApi getWaitTravelCount:mParaDic SuccessBlock:^(id responseBody) {
        _DCXCount = [NSString stringWithFormat:@"%@",responseBody[@"count"]];
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDatasoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJMyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJMyCell"];
        ZJMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJMyCell"];
        [cell.img_head sd_setImageWithURL:[NSURL URLWithString:[ZJSingleHelper shareNetWork].mUserInfo.mHeadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"] options:EMSDWebImageRefreshCached];

        cell.mlab_Name.text =  [ZJSingleHelper shareNetWork].mUserInfo.mNickName;
        cell.mlab_phoneNum.text =  [ZJSingleHelper shareNetWork].mUserInfo.mMobile;
        [cell oncickLDBlock:^(UIButton *sender) {
          //申请领队
        }];
        [cell oncickHeadImgBlock:^(UIButton *sender) {
            ZJMyInfoVC *mTempVC = [[ZJMyInfoVC alloc]init];
            [self.navigationController pushViewController:mTempVC animated:YES];
        }];
        return cell;
    }
    if (indexPath.row == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJDMyCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDMyCell1"];
        ZJDMyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDMyCell1"];
        [cell loadDCXCount:_DCXCount];
        [cell onclickAllRouteBlock:^(UIButton *sender) {
            ZJMyRouteVC *mTempVC = [[ZJMyRouteVC alloc]init];
            mTempVC.mSelectIndex = 10;
            [self.navigationController pushViewController:mTempVC animated:YES];
        }];
        [cell onclickDDPBBlock:^(UIButton *sender) {
            ZJMyRouteVC *mTempVC = [[ZJMyRouteVC alloc]init];
            mTempVC.mSelectIndex = 11;
            [self.navigationController pushViewController:mTempVC animated:YES];
        }];
        [cell onclickDCXBlock:^(UIButton *sender) {
            ZJMyRouteVC *mTempVC = [[ZJMyRouteVC alloc]init];
            mTempVC.mSelectIndex = 12;
            [self.navigationController pushViewController:mTempVC animated:YES];
        }];
        return cell;
    }
    
    if (indexPath.row == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJDMyCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDMyCell2"];
        ZJDMyCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDMyCell2"];
        [cell onclickSelectIdex:^(NSIndexPath *index) {
            if (index.row == 0) {
                ZJMyCollectionVC *tempVC =[[ZJMyCollectionVC alloc]init];
                [self.navigationController pushViewController:tempVC animated:YES];
            }
            if (index.row == 1) {
                ZJMyFootMarkVC *tempVC =[[ZJMyFootMarkVC alloc]init];
                [self.navigationController pushViewController:tempVC animated:YES];
            }
            if (index.row ==2) {
                ZJMyLeaderVC *tempVC =[[ZJMyLeaderVC alloc]init];
                [self.navigationController pushViewController:tempVC animated:YES];

            }
            if (index.row ==3) {
                ZJSettingVC *tempVC =[[ZJSettingVC alloc]init];
                [self.navigationController pushViewController:tempVC animated:YES];
                
            }
            
        }];
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
  
}

@end
