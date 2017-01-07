//
//  ZJRegisterVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRegisterVC.h"
#import "ZJRegisterCell.h"
#import "ZJRegisterFootView.h"
@interface ZJRegisterVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)NSArray *mImageDataSoure;
@end

@implementation ZJRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.viewType == 2) {
        self.title = @"忘记密码";
        return;
    }
    self.title = @"新用户注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        if (self.viewType == 2) {
         _mDataSoure = @[@"输入手机号",@"输入验证码",@"请输入密码",@"请再次输入密码"];
        }else{
         _mDataSoure = @[@"输入手机号",@"输入验证码",@"请输入密码",@"请再次输入密码",@"请输入推荐人编码(选填)"];
        }
    }
    return _mDataSoure;
}
-(NSArray *)mImageDataSoure{
    if (_mImageDataSoure == nil) {
        if (self.viewType == 2) {
             _mImageDataSoure = @[@"Register_phone",@"Register_code",@"Register_pwd",@"Register_pwd"];
        }else{
             _mImageDataSoure = @[@"Register_phone",@"Register_code",@"Register_pwd",@"Register_pwd",@"Register_yqcode"];
        }
    }
    return _mImageDataSoure;
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = [NSString stringWithFormat:@"ZJRegisterCell%ld%ld",indexPath.section,indexPath.row];
    [tableView registerNib:[UINib nibWithNibName:@"ZJRegisterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    ZJRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell.mTF_input setPlaceholder:self.mDataSoure[indexPath.row]];
    [cell.mImageView setImage:[UIImage imageNamed:self.mImageDataSoure[indexPath.row]]];
    if (indexPath.row == 1) {
        cell.mBtn_getCode.hidden = NO;
        cell.mlab_markCode.hidden = NO;
    }
    [cell onclickGetCodeBtnBlock:^(UIButton *sender) {
       //获取验证码
        ZJRegisterCell *phoneCell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (phoneCell.mTF_input.text == nil || phoneCell.mTF_input.text.length==0) {
            ShowMSG(@"请输入手机号码");
            return ;
        }
    
        if (self.viewType == 2) {
            //忘记密码
            [[ZJNetWorkingHelper shareNetWork]mValidateInfo:@{@"account":__BASE64(phoneCell.mTF_input.text)} SuccessBlock:^(id responseBody) {
                [[ZJNetWorkingHelper shareNetWork]mGetMobileVcode:@{@"account":__BASE64(phoneCell.mTF_input.text)} SuccessBlock:^(id responseBody) {
                    ShowMSG(responseBody[@"vcode"]);
                    [MyFounctions startTime:sender];
                } FailureBlock:^(NSError *error) {
                    
                }];
                
            } FailureBlock:^(NSError *error) {
                
            }];
        }else{
            //注册
            [[ZJNetWorkingHelper shareNetWork]mGetMobileVcode:@{@"account":__BASE64(phoneCell.mTF_input.text)} SuccessBlock:^(id responseBody) {
                LDLOG(@"手机验证码 ======== %@",responseBody[@"vcode"]);
                 ShowMSG(responseBody[@"vcode"]);
                [MyFounctions startTime:sender];
            } FailureBlock:^(NSError *error) {
                
            }];
        }
    }];
    
    return cell;

}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ZJRegisterFootView *footView = [[NSBundle mainBundle]loadNibNamed:@"ZJRegisterFootView" owner:nil options:nil][0];
    if (self.viewType == 2) {
        footView.mBtn_read.hidden = YES;
        footView.mBtn_areement.hidden = YES;
        footView.mlab_text.hidden = YES;
        [footView.mBtn_register setTitle:@"重置密码" forState:UIControlStateNormal];
    }

    [footView onclickAgreementBtnBlock:^(UIButton *sender) {
        //用户协议
    }];
    [footView onclickRegisterBtnBlock:^(UIButton *sender) {
        //注册
        
        NSString *mPhoneStr;
        NSString *mVerCodeStr;
        NSString *mPWDStr;
        NSString *mAPWDStr;
        NSString *mInviteCodeStr;
        
        ZJRegisterCell *phoneCell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        mPhoneStr = phoneCell.mTF_input.text;
        
        ZJRegisterCell *VcodeCell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        mVerCodeStr = VcodeCell.mTF_input.text;
        
        ZJRegisterCell *PWDcell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        mPWDStr = PWDcell.mTF_input.text;
        
        ZJRegisterCell *APWDCell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        mAPWDStr = APWDCell.mTF_input.text;
        
        ZJRegisterCell *InviteCodecell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        mInviteCodeStr = InviteCodecell.mTF_input.text;
        
        if (mPhoneStr==nil || mPhoneStr.length == 0) {
            ShowMSG(@"手机号不能为空！");
            return;
        }
        if (mVerCodeStr==nil || mVerCodeStr.length == 0) {
            ShowMSG(@"验证码不能为空！");
            return;
        }
        if (mPWDStr==nil || mPWDStr.length == 0) {
            ShowMSG(@"密码不能为空！");
            return;
        }
        if (mAPWDStr==nil || mAPWDStr.length == 0) {
            ShowMSG(@"请再次输入密码！");
            return;
        }
        if (![mAPWDStr isEqualToString:mAPWDStr]) {
            ShowMSG(@"两次输入的密码不一致！");
            return;
        }
        
        NSMutableDictionary *mParamDic = [NSMutableDictionary dictionary];
      
        if(self.viewType == 2){
            [mParamDic setObject:ZJ_UserID forKey:@"userId"];
            [mParamDic setObject:[MyFounctions md5:mPWDStr] forKey:@"password"];
            [[ZJNetWorkingHelper shareNetWork]mForgetPwd:mParamDic SuccessBlock:^(id responseBody) {
                [self.navigationController popViewControllerAnimated:YES];
            } FailureBlock:^(NSError *error) {
                
            }];
        }else{
            [mParamDic setObject:__BASE64(mPhoneStr) forKey:@"account"];
            [mParamDic setObject:mVerCodeStr forKey:@"vcode"];
            [mParamDic setObject:[MyFounctions md5:mPWDStr] forKey:@"password"];
            if (mInviteCodeStr && mInviteCodeStr.length>0) {
                [mParamDic setObject:mInviteCodeStr forKey:@"inviteCode"];
            }
            [[ZJNetWorkingHelper shareNetWork]mRegister:mParamDic SuccessBlock:^(id responseBody) {
               // [self.navigationController popViewControllerAnimated:YES];
                
                [[ZJNetWorkingHelper shareNetWork]mLogin:@{@"account":__BASE64(mPhoneStr),@"password":[MyFounctions md5:mPWDStr],@"type":@"1"} SuccessBlock:^(id responseBody) {
                    NSMutableDictionary*userInfoDic = [NSMutableDictionary dictionaryWithDictionary:responseBody];
                    [userInfoDic setObject:responseBody[@"uname"] forKey:@"name"];
                    [userInfoDic setObject:responseBody[@"userId"] forKey:@"userId"];
                    [userInfoDic setObject:mPhoneStr forKey:@"phoneNum"];
                    [MyFounctions saveUserInfo:userInfoDic];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    if (![EMClient sharedClient].isLoggedIn) {
                        [[EMClient sharedClient]loginWithUsername:[NSString stringWithFormat:@"user_%@",mPhoneStr]  password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
                            if (!aError) {
                                [[EMClient sharedClient].options setIsAutoLogin:YES];
                                [[EMClient sharedClient] addDelegate:(id)self delegateQueue:nil];
                                [[EMClient sharedClient] addDelegate:(id)self delegateQueue:nil];
                                [[EMClient sharedClient].groupManager addDelegate:(id)self delegateQueue:nil];
                                [[EMClient sharedClient].roomManager addDelegate:(id)self delegateQueue:nil];
                                [[EMClient sharedClient].chatManager addDelegate:(id)self];
                                [[EMClient sharedClient].contactManager addDelegate:(id)self delegateQueue:nil];
                                
                            }
                            
                        }];
                    }
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
            } FailureBlock:^(NSError *error) {
                
            }];
        }
    }];
    [footView onclickReadBtnBlock:^(UIButton *sender) {
        //已阅
    }];
    return footView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZJRegisterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.mTF_input becomeFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
