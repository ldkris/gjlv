//
//  ZJTabBarVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJTabBarVC.h"
#import "ZJLoginVC.h"
@interface ZJTabBarVC ()
@property(nonatomic,retain)NSMutableArray *mBtns;

@end

@implementation ZJTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatCustomTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)mBtns{
    if(_mBtns == nil){
        _mBtns = [NSMutableArray array];
    }
    return _mBtns;
}
-(void)creatCustomTabBar{
    self.tabBar.hidden = YES;
    
    if (self.mBarView == nil) {
        self.mBarView = [[UIView alloc]init];
        [self.mBarView setBackgroundColor:[UIColor blackColor]];
    }
    [self.view addSubview:self.mBarView];
    [self.mBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    NSArray *barImages = @[@"tab_home",@"tab_Destination",@"tab_ld",@"tab_lx",@"tab_wd"];
    NSArray *barSelectImages = @[@"tab_home_select",@"tab_Destination_select",@"tab_ld_select",@"tab_lx_select",@"tab_wd_select"];
    UIButton *mOldBarBtn;
    for (int i =0; i<barImages.count; i++) {
        UIButton *mBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mBarBtn setTag:i];
        [mBarBtn setImage:[UIImage imageNamed:barImages[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [mBarBtn setBackgroundColor:BG_Yellow];
            [mBarBtn setImage:[UIImage imageNamed:barSelectImages[i]] forState:UIControlStateNormal];
        }
        [mBarBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [mBarBtn addTarget:self action:@selector(onclickBarBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mBarView addSubview:mBarBtn];
        [mBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(mOldBarBtn == nil){
                make.left.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(MainScreenFrame_Width/5);
            }else{
                make.top.bottom.mas_equalTo(0);
                make.left.equalTo(mOldBarBtn.mas_right);
                make.width.mas_equalTo(MainScreenFrame_Width/5);
            }
        }];
        mOldBarBtn = mBarBtn;
        [self.mBtns addObject:mBarBtn];
    }
}
-(void)onclickBarBtn:(UIButton *)sender{
    NSArray *barImages = @[@"tab_home",@"tab_Destination",@"tab_ld",@"tab_lx",@"tab_wd"];
    NSArray *barSelectImages = @[@"tab_home_select",@"tab_Destination_select",@"tab_ld_select",@"tab_lx_select",@"tab_wd_select"];
    for (UIButton *btn in self.mBtns) {
        if(btn == sender){
            [sender setBackgroundColor:BG_Yellow];
            [sender setImage:[UIImage imageNamed:barSelectImages[sender.tag]] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundColor:[UIColor blackColor]];
            [btn setImage:[UIImage imageNamed:barImages[btn.tag]] forState:UIControlStateNormal];
        }
    }
//    UIViewController *tempVC =  self.viewControllers[sender.tag];
    [self setSelectedIndex:sender.tag];
}

-(void)selectVCWithIndex:(NSInteger)index{
    [self setSelectedIndex:index];
    NSArray *barImages = @[@"tab_home",@"tab_Destination",@"tab_ld",@"tab_lx",@"tab_wd"];
    NSArray *barSelectImages = @[@"tab_home_select",@"tab_Destination_select",@"tab_ld_select",@"tab_lx_select",@"tab_wd_select"];
    for (UIButton *btn in self.mBtns) {
        if(btn.tag == index){
            [btn setBackgroundColor:BG_Yellow];
            [btn setImage:[UIImage imageNamed:barSelectImages[index]] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundColor:[UIColor blackColor]];
            [btn setImage:[UIImage imageNamed:barImages[btn.tag]] forState:UIControlStateNormal];
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
