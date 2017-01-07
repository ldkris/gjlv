//
//  ZJInputInviteCodeVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJInputInviteCodeVC.h"

@interface ZJInputInviteCodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UIButton *btn_comfire;

@end

@implementation ZJInputInviteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"请输入邀请码";
    
    [_mTF_input setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_btn_comfire.layer setCornerRadius:5.0f];
    [_btn_comfire.layer setMasksToBounds:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclickComfireBtn:(id)sender {
    if (self.mTF_input.text == nil || self.mTF_input.text.length==0) {
        ShowMSG(@"请输入邀请码");
        return;
    }
    //190712017
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"inviteCode":self.mTF_input.text};
    [HttpApi getRouteByInviteCode:mParamDic SuccessBlock:^(id responseBody) {
        [self.navigationController popViewControllerAnimated:YES];
    } FailureBlock:^(NSError *error) {
        
    }];
}

@end
