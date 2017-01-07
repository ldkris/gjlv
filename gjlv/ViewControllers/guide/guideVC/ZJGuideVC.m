//
//  ZJGuideVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGuideVC.h"

@interface ZJGuideVC ()
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (nonatomic, strong) UIViewController *currentVC;
@property (weak, nonatomic) IBOutlet UIView *mBtnView;
@end

@implementation ZJGuideVC{
    ZJChatListVC *_mChatListVC;
    ZJFriendListVC *_mFirendListVC;
    ZJGroupListVC *_mGroupListVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"领队";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"r_add"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickRight:)];
    
    NSArray *mArray = @[@"消息",@"联系人",@"群组"];
    UIButton *mOldBtn;
    for (int i = 0; i<mArray.count; i++) {
        NSString *str = mArray[i];
        UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mTempBtn setTitle:str forState:UIControlStateNormal];
        [mTempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mTempBtn addTarget:self action:@selector(onclickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mTempBtn.titleLabel setFont:DEFAULT_FONT(13)];
        mTempBtn.tag = i +10;
        if(mTempBtn.tag == 10){
            [mTempBtn setTitleColor:BG_Yellow forState:UIControlStateNormal];
        }else{
            [mTempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [mTempBtn setBackgroundColor:SL_GRAY];
        [self.mBtnView addSubview:mTempBtn];
        [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldBtn == nil) {
                make.left.mas_equalTo(0);
            }else{
                make.left.equalTo(mOldBtn.mas_right).with.offset(0);
            }
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(MainScreenFrame_Width/mArray.count);
        }];
        
        UIView *mMarkView = [[UIView alloc]init];
        [mMarkView setBackgroundColor:SL_GRAY_Hard];
        [self.mBtnView addSubview:mMarkView];
        [mMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldBtn == nil) {
                make.left.mas_equalTo(MainScreenFrame_Width/mArray.count);
            }else{
                make.left.equalTo(mOldBtn.mas_right).with.offset(0);
            }
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(1);
        }];
        
        mOldBtn = mTempBtn;
    }
    
    [self addChildViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self unHideZJTbar];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark event reponse
-(void)onclickRight:(UIButton *)sender{
    
    [ZJMenuAlertview showWithTitleS:@[@"选择领队",@"附近车友",@"账号搜索",@"发起群聊"] andImages:@[@"zj_xzld",@"zj_fjcy",@"zj_sscy",@"zj_xzld"]  Block:^(NSIndexPath *index) {
        [ZJMenuAlertview dismiss];
        if (index.row == 0) {
            ZJGSelectLeaderVC *tempVC = [[ZJGSelectLeaderVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
            return ;
        }
        if (index.row == 2) {
            ZJSearchFirendVC *tempVC = [[ZJSearchFirendVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
            return ;
        }
        if (index.row == 1) {
            ZJGAounrdCarVC *tempVC = [[ZJGAounrdCarVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
        if (index.row == 3) {
            CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
            [self.navigationController pushViewController:createChatroom animated:YES];
        }
        
    }];
    
}
-(void)onclickTypeBtn:(UIButton *)sender{
    
    for (int i = 10; i<14; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        if (sender.tag == i) {
            [btn setTitleColor:BG_Yellow forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    switch (sender.tag) {
        case 10:{
            [self fitFrameForChildViewController:_mChatListVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_mChatListVC];
            
            [sender setTitleColor:BG_Yellow forState:UIControlStateNormal];
            UIButton *mBtn = [self.view viewWithTag:101];
            [mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;}
        case 11:{
            [self fitFrameForChildViewController:_mFirendListVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_mFirendListVC];
            
            [sender setTitleColor:BG_Yellow forState:UIControlStateNormal];
            UIButton *mBtn = [self.view viewWithTag:100];
            [mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;}
        case 12:{
            [self fitFrameForChildViewController:_mGroupListVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_mGroupListVC];
            
            [sender setTitleColor:BG_Yellow forState:UIControlStateNormal];
            UIButton *mBtn = [self.view viewWithTag:102];
            [mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;}
            
        default:
            break;
    }
}
#pragma mark private
-(void)addChildViews{
    _mGroupListVC = [[ZJGroupListVC alloc]init];
    self.GroupListVC = _mGroupListVC;
    [self addChildViewController:_mGroupListVC];
    [self fitFrameForChildViewController:_mGroupListVC];
    [self.mContentView addSubview:_mGroupListVC.view];
    
    _mFirendListVC = [[ZJFriendListVC alloc]init];
    self.FirendListVC = _mFirendListVC;
    [self addChildViewController:_mFirendListVC];
    [self.mContentView addSubview:_mFirendListVC.view];
    
    _mChatListVC = [[ZJChatListVC alloc]init];
    self.ChatListVC = _mChatListVC;
    [self addChildViewController:_mChatListVC];
    [self fitFrameForChildViewController:_mChatListVC];
    [self.mContentView addSubview:_mChatListVC.view];
    
    _currentVC = _mChatListVC;
    
}
- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.mContentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    if (newViewController == oldViewController) {
        return;
    }
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}
//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}


@end
