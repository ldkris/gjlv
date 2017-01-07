//
//  BaseViewController.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJTabBarVC.h"
@interface BaseViewController ()

@end

@implementation BaseViewController{
    UITapGestureRecognizer *mTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = 10;
    self.pageIndex = 1;
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickGoBack:)];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideZJTbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)keyboardWillHide:(NSNotification *) notification {
    [self.view removeGestureRecognizer:mTap];
    mTap = nil;
}
- (void)keyboardWillShow:(NSNotification *) notification {
    if (mTap == nil) {
        mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allTFResignFirstResponder)];
        mTap.delegate = (id)self;
        [self.view addGestureRecognizer:mTap];
    }
}
#pragma mark public
-(void)hideZJTbar{
    if ([self.tabBarController isKindOfClass:[ZJTabBarVC class]]) {
        ZJTabBarVC *tempVC = (ZJTabBarVC *)self.tabBarController;
        self.tabBarController.tabBar.hidden = YES;
        tempVC.mBarView.hidden =YES;
        self.tabBarController.tabBar.hidden = YES;
    }
}
-(void)unHideZJTbar{
    if ([self.tabBarController isKindOfClass:[ZJTabBarVC class]]) {
        ZJTabBarVC *tempVC = (ZJTabBarVC *)self.tabBarController;
        tempVC.mBarView.hidden =NO;
        
    }
}
#pragma mark event response
-(void)onclickGoBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  收起所有键盘
 */
-(void)allTFResignFirstResponder{
    LDLOG(@"收起所有的键盘");
    for (id temp in self.view.subviews) {
        if ([temp isKindOfClass:[UITextField class]]) {
            UITextField *tempTF = (UITextField *)temp;
            [tempTF resignFirstResponder];
        }else if ([temp isKindOfClass:[UITextView class]]){
            UITextView *tempTF = (UITextView *)temp;
            [tempTF resignFirstResponder];
        }else{
            if([temp isKindOfClass:[UIView class]]){
                UIView *tempView = (UIView *)temp;
                if (tempView.subviews.count>0) {
                    for (id temp1 in tempView.subviews) {
                        if ([temp1 isKindOfClass:[UITextField class]]) {
                            UITextField *tempTF = (UITextField *)temp1;
                            [tempTF resignFirstResponder];
                        }
                        if ([temp1 isKindOfClass:[UITextView class]]) {
                            UITextView *tempTF = (UITextView *)temp1;
                            [tempTF resignFirstResponder];
                        }
                    }
                }
            }
        }
    }
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
