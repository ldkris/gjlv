//
//  ZJSettingVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSettingVC.h"
#import "ZJChangePWDVC.h"
#import "ZJOpinionVC.h"
#import "ZJLoginVC.h"
@interface ZJSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation ZJSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
//    self.mInfoTableView.tableFooterView = [UIView new];
//    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@[@"推送开关",@"修改密码",@"意见反馈",@"邀请/分享",@"清除缓存",@"关于"],@[@"退出登录"]];
    }
    return _mDataSoure;
}
#pragma mark event response
-(void)onclickSwitch:(UISwitch *)sender{

    if (sender.on) {
        [EMClient sharedClient].pushOptions.noDisturbStatus = EMPushNoDisturbStatusClose;
    }else{
        [EMClient sharedClient].pushOptions.noDisturbStatus = EMPushNoDisturbStatusDay;
    }
    
    [[EMClient sharedClient]updatePushNotificationOptionsToServerWithCompletion:^(EMError *aError) {
        if (!aError) {
            if ([EMClient sharedClient].pushOptions.noDisturbStatus == EMPushNoDisturbStatusClose) {
                sender.on = YES;
            }else{
                sender.on = NO;
            }
            
        }
    }];
}
#pragma mark  UITableViewDelegate && UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }
    return 0.011;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfitiy = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfitiy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfitiy];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        UISwitch *mSwitch = [[UISwitch alloc]init];
        if ([EMClient sharedClient].pushOptions.noDisturbStatus == EMPushNoDisturbStatusClose) {
            mSwitch.on = YES;
        }else{
            mSwitch.on = NO;
        }
        [mSwitch setOnTintColor:BG_Yellow];
        [mSwitch addTarget:self action:@selector(onclickSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:mSwitch];
        [mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.centerY.mas_equalTo(0);
        }];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ZJLoginVC *mLoginVc = [[ZJLoginVC alloc]init];
        BaseNavigationgVC *mLoginNaviGationVC = [[BaseNavigationgVC alloc]initWithRootViewController:mLoginVc];
        [MyFounctions removeUserInfo];
        [[EMClient sharedClient]logout:YES completion:^(EMError *aError) {
            if (!aError) {
                [self.tabBarController presentViewController:mLoginNaviGationVC animated:YES completion:nil];
            }
        }];
    }
    
    if (indexPath.row == 1) {
        ZJChangePWDVC *mTempVC = [[ZJChangePWDVC alloc]init];
        [self.navigationController pushViewController:mTempVC animated:YES];
    }
    
    if (indexPath.row == 2) {
        ZJOpinionVC *tempVC =[[ZJOpinionVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
@end
