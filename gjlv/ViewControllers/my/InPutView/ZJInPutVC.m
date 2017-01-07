//
//  ZJInPutVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJInPutVC.h"

@interface ZJInPutVC ()

@end

@implementation ZJInPutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
    [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
    [mRightBtn addTarget:self action:@selector(onclickRight:) forControlEvents:UIControlEventTouchUpInside];
    [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mRightBtn setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:mRightBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.mlab_description.text = [NSString stringWithFormat:@"请输入%@",self.title];
//    [_mTF_input setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    _mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",self.title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{

    switch (self.indexPath.row) {
        case 1:
            [self saveInfoWithNetWorkingKey:@"name"];
            break;
        case 2:
            [self saveInfoWithNetWorkingKey:@"nickName"];
            break;
        case 4:
            [self saveSexInfoWithNetWorkingKey:@"sex"];
            break;
        case 5:
            [self saveInfoWithNetWorkingKey:@"carModel"];
            break;
        case 6:
            [self saveInfoWithNetWorkingKey:@"carNo"];
            break;
        case 7:
            [self saveInfoWithNetWorkingKey:@"carAge"];
            break;
        case 10:
            [self saveInfoWithNetWorkingKey:@"xytxsb"];
            break;
            
        default:
            break;
    }
}

-(void)saveInfoWithNetWorkingKey:(NSString *)key{
    [[ZJNetWorkingHelper shareNetWork]mPutMyInfo:@{@"userId":ZJ_UserID,key:self.mTF_input.text} SuccessBlock:^(id responseBody) {
        [self.navigationController popViewControllerAnimated:YES];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)saveSexInfoWithNetWorkingKey:(NSString *)key{
    
   __block NSString *sexStr;
    
    if ([self.mTF_input.text isEqualToString:@"男"]||[self.mTF_input isEqual:@"女"]) {
        if ([self.mTF_input.text isEqualToString:@"男"]) {
            sexStr = @"1";
        }else{
            sexStr = @"2";
        }
        [[ZJNetWorkingHelper shareNetWork]mPutMyInfo:@{@"userId":ZJ_UserID,key:sexStr} SuccessBlock:^(id responseBody) {
            [self.navigationController popViewControllerAnimated:YES];
        } FailureBlock:^(NSError *error) {
            
        }];
    }else{
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APPName message:@"请输入正确的性别" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            sexStr = @"1";
            
            [[ZJNetWorkingHelper shareNetWork]mPutMyInfo:@{@"userId":ZJ_UserID,key:sexStr} SuccessBlock:^(id responseBody) {
                [self.navigationController popViewControllerAnimated:YES];
            } FailureBlock:^(NSError *error) {
                
            }];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            sexStr = @"2";
            
            [[ZJNetWorkingHelper shareNetWork]mPutMyInfo:@{@"userId":ZJ_UserID,key:sexStr} SuccessBlock:^(id responseBody) {
                [self.navigationController popViewControllerAnimated:YES];
            } FailureBlock:^(NSError *error) {
                
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
@end
