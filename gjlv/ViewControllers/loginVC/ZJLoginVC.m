//
//  ZJLoginVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJLoginVC.h"
#import "ZJRegisterVC.h"
#import "ZJTabBarVC.h"
#import "BaseNavigationgVC.h"
#import "ZJHomeVC.h"
#import "ZJDestinationVC.h"
#import "ZJGuideVC.h"
#import "ZJRouteVC.h"
#import "ZJMyVC.h"
@interface ZJLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *mTF_UserName;
@property (weak, nonatomic) IBOutlet UITextField *mTF_Pwd;

@property (weak, nonatomic) IBOutlet UIButton *mBtn_login;
@property (weak, nonatomic) IBOutlet UIView *mPhoneLoginVie;

@property (weak, nonatomic) IBOutlet UITextField *mTF_PUserName;
@property (weak, nonatomic) IBOutlet UITextField *mTF_PPwd;
@end

@implementation ZJLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadRightBarBtn];
    
    [self.mBtn_login.layer setMasksToBounds:YES];
    [self.mBtn_login.layer setCornerRadius:5.0f];
    
    self.mPhoneLoginVie.hidden=YES;
    
    [self.mTF_Pwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark prvate
-(void)loadRightBarBtn{
    UIBarButtonItem *mRightBt = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(onclickRightBarBtn:)];
    [mRightBt setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = mRightBt;
}
#pragma mark event response
- (void) textFieldDidChange:(UITextField *) sender {
    if (sender.text.length>=3) {
        [self.mBtn_login setEnabled:YES];
        [self.mBtn_login setBackgroundColor:BG_Yellow];
    }else{
        [self.mBtn_login setEnabled:NO];
        [self.mBtn_login setBackgroundColor:RGBACOLOR(238, 219, 179, 1)];
    }
}
-(void)onclickRightBarBtn:(UIBarButtonItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onclickUserLginBtn:(UIButton *)sender {
    self.mPhoneLoginVie.hidden = YES;
    [sender setTitleColor:BG_Yellow forState:UIControlStateNormal];
    UIButton *mBtn = [self.view viewWithTag:101];
    [mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (IBAction)onclickPhoneloginBtn:(UIButton *)sender {
    self.mPhoneLoginVie.hidden = NO;
    [sender setTitleColor:BG_Yellow forState:UIControlStateNormal];
    UIButton *mBtn = [self.view viewWithTag:100];
    [mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (IBAction)onclickLoginBtn:(id)sender {
    NSString *userName;
    NSString *pwd;
    NSString *type;
    if (self.mPhoneLoginVie.hidden == YES) {
        userName = self.mTF_UserName.text;
        pwd = [MyFounctions md5:self.mTF_Pwd.text];
        type= @"1";
    }else{
        userName = self.mTF_PUserName.text;
        pwd = self.mTF_PPwd.text;
        type= @"2";
    }
    
    if (userName== nil || userName.length == 0) {
        ShowMSG(@"请输入用户名");
        return;
    }
    
    if (pwd== nil || pwd.length == 0) {
        ShowMSG(@"请输入密码");
        return;
    }
   
    [[ZJNetWorkingHelper shareNetWork]mLogin:@{@"account":__BASE64(userName),@"password":pwd,@"type":type} SuccessBlock:^(id responseBody) {
        NSMutableDictionary*userInfoDic = [NSMutableDictionary dictionaryWithDictionary:responseBody];
        [userInfoDic setObject:responseBody[@"uname"] forKey:@"name"];
        [userInfoDic setObject:responseBody[@"userId"] forKey:@"userId"];
        [userInfoDic setObject:userName forKey:@"phoneNum"];
        [MyFounctions saveUserInfo:userInfoDic];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (![EMClient sharedClient].isLoggedIn) {
            [[EMClient sharedClient]loginWithUsername:[NSString stringWithFormat:@"user_%@",userName]  password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
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
    
}
- (IBAction)onclickRegisterBtn:(id)sender {
    ZJRegisterVC *tempVC = [[ZJRegisterVC alloc]init];
    tempVC.viewType = 1;
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickForGetPwdBtn:(id)sender {
    ZJRegisterVC *tempVC = [[ZJRegisterVC alloc]init];
    tempVC.viewType = 2;
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickGetCodeBtn:(id)sender {
    
    if (self.mTF_PUserName.text==nil || self.mTF_PUserName.text.length == 0) {
        ShowMSG(@"请输入手机号码！");
        return;
    }
    [[ZJNetWorkingHelper shareNetWork]mGetMobileVcode:@{@"account":__BASE64(self.mTF_PUserName.text)} SuccessBlock:^(id responseBody) {
        LDLOG(@"手机验证码 ======== %@",responseBody[@"vcode"]);
        ShowMSG(responseBody[@"vcode"]);
        [MyFounctions startTime:sender];
    } FailureBlock:^(NSError *error) {
        
    }];
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
