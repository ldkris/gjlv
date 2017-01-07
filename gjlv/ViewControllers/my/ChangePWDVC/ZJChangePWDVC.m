//
//  ZJChangePWDVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJChangePWDVC.h"
#import "ZJTFView.h"

#import "ZJLoginVC.h"
@interface ZJChangePWDVC ()
@property(nonatomic,retain)ZJTFView *mOldPwdView;
@property(nonatomic,retain)ZJTFView *mNewPwdView;
@property(nonatomic,retain)ZJTFView *mComNewPwdView;

@property(nonatomic,retain)UIButton *mComfirBtn;
@end

@implementation ZJChangePWDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    
    [self.view addSubview:self.mOldPwdView];
    self.mOldPwdView.mInputPwd.placeholder = @"请输入旧密码";
    [self.mOldPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.mNewPwdView];
    [self.mNewPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mOldPwdView.mas_bottom).with.offset(13);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.mComNewPwdView];
    [self.mComNewPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mNewPwdView.mas_bottom).with.offset(13);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.mComfirBtn];
    [self.mComfirBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mComNewPwdView.mas_bottom).with.offset(30);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(ZJTFView *)mOldPwdView{
    if (_mOldPwdView == nil) {
        _mOldPwdView = [[NSBundle mainBundle]loadNibNamed:@"ZJTFView" owner:nil options:nil][0];
    }
    [_mOldPwdView.mIMG setImage:[UIImage imageNamed:@"c_cPwd"]];
    return _mOldPwdView;
}
-(ZJTFView *)mNewPwdView{
    if (_mNewPwdView == nil) {
        _mNewPwdView = [[NSBundle mainBundle]loadNibNamed:@"ZJTFView" owner:nil options:nil][0];
    }
    return _mNewPwdView;
}
-(ZJTFView *)mComNewPwdView{
    if (_mComNewPwdView == nil) {
        _mComNewPwdView = [[NSBundle mainBundle]loadNibNamed:@"ZJTFView" owner:nil options:nil][0];
    }
    return _mComNewPwdView;
}
-(UIButton *)mComfirBtn{
    if (_mComfirBtn == nil) {
        _mComfirBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mComfirBtn setBackgroundColor:BG_Yellow];
        [_mComfirBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mComfirBtn.titleLabel setFont:DEFAULT_FONT(15)];
        [_mComfirBtn setTitle:@"确定修改" forState:UIControlStateNormal];
        [_mComfirBtn addTarget:self action:@selector(onclickComfir:) forControlEvents:UIControlEventTouchUpInside];
        _mComfirBtn.layer.masksToBounds = YES;
        _mComfirBtn.layer.cornerRadius = 5.0f;
    }
    
    return _mComfirBtn;
}
#pragma mark networking
-(void)updatePasswd{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"oldPasswd":[MyFounctions md5:self.mOldPwdView.mInputPwd.text],@"passwd":[MyFounctions md5:self.mNewPwdView.mInputPwd.text]};
    [HttpApi updatePasswd:mParamDic SuccessBlock:^(id responseBody) {
        ZJLoginVC *mLoginVc = [[ZJLoginVC alloc]init];
        BaseNavigationgVC *mLoginNaviGationVC = [[BaseNavigationgVC alloc]initWithRootViewController:mLoginVc];
        [self.tabBarController presentViewController:mLoginNaviGationVC animated:YES completion:^{
            [MyFounctions removeUserInfo];
        }];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark even response
-(void)onclickComfir:(UIButton *)sender{
    if (self.mOldPwdView.mInputPwd.text == nil || self.mOldPwdView.mInputPwd.text.length==0) {
        ShowMSG(@"请输入旧密码");
        return;
    }
    if (self.mNewPwdView.mInputPwd.text == nil || self.mNewPwdView.mInputPwd.text.length==0) {
        ShowMSG(@"请输入新密码");
        return;
    }

    if (self.mComNewPwdView.mInputPwd.text == nil || self.mComNewPwdView.mInputPwd.text.length==0) {
        ShowMSG(@"请输入再次密码");
        return;
    }
    
    if (self.mComNewPwdView.mInputPwd.text != self.mComNewPwdView.mInputPwd.text) {
        ShowMSG(@"两次输入的密码不一致");
        return;
    }

    [self updatePasswd];
}
@end
