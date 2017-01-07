//
//  ZJChatVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJChatVC.h"
#import "ZJTabBarVC.h"
#import "ZJNetWorkingHelper.h"
#import "ChatGroupDetailViewController.h"
@interface ZJChatVC ()

@end

@implementation ZJChatVC{

    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    
    NSString *_myHeadImg;
    NSString *_herHeadImg;
    NSString *_herNickName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickGoBack:)];
    
    //Initialization
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType = self.conversation.type == EMConversationTypeChat ? EMChatToolbarTypeChat : EMChatToolbarTypeGroup;
    self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, MainScreenFrame_Width, chatbarHeight) type:barType];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    if (self.conversation.type  == EMChatToolbarTypeGroup) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"group_detail"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickGroupInfoBtn:)];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideZJTbar];
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark private
-(void)hideZJTbar{
    if ([self.tabBarController isKindOfClass:[ZJTabBarVC class]]) {
        ZJTabBarVC *tempVC = (ZJTabBarVC *)self.tabBarController;
        self.tabBarController.tabBar.hidden = YES;
        tempVC.mBarView.hidden =YES;
    }
}
#pragma mark event response
-(void)onclickGoBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onclickGroupInfoBtn:(UIButton *)sender{
    ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:self.conversation.conversationId];
    [self.navigationController pushViewController:detailController animated:YES];
}
#pragma mark 环信 头像 呢称
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    
    NSString *loginName = [[EMClient sharedClient] currentUsername];
    NSString *sender = message.from;
    BOOL isSender = [loginName isEqualToString:sender] ? YES : NO;
    if (message.chatType == EMChatTypeChat) {
        if(isSender){
             model.nickname = @"我";
            if (_myHeadImg == nil) {
                 NSDictionary *mParamDic = @{@"chatusers":sender,@"userId":ZJ_UserID};
                [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
                    NSArray *tempArray = responseBody[@"users"];
                    if (tempArray && tempArray.count>0) {
                        NSDictionary *info = tempArray[0];
                        model.avatarURLPath = info[@"headImgUrl"];
                        _myHeadImg = info[@"headImgUrl"];
    
                        [self.tableView reloadData];
                    }
                } FailureBlock:^(NSError *error) {
                    
                }];
            }else{
                model.avatarURLPath = _myHeadImg;
            }
        }else{
            if (_herHeadImg == nil) {
                NSDictionary *mParamDic = @{@"chatusers":sender,@"userId":ZJ_UserID};
                [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
                    NSArray *tempArray = responseBody[@"users"];
                    if (tempArray && tempArray.count>0) {
                        NSDictionary *info = tempArray[0];
                        model.nickname = info[@"nickname"];
                        model.avatarURLPath = info[@"headImgUrl"];
                        _herNickName = info[@"nickname"];
                        _myHeadImg = info[@"headImgUrl"];
                        [self.tableView reloadData];
                    }
                } FailureBlock:^(NSError *error) {
                    
                }];
            }else{
                model.nickname = _herNickName;
                model.avatarURLPath = _herHeadImg;
            }
         
        }
    }
    
    return model;
}
@end
