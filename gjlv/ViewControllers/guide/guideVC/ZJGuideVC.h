//
//  ZJGuideVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJChatListVC.h"
#import "ZJFriendListVC.h"
#import "ZJGAounrdCarVC.h"
#import "ZJGSelectLeaderVC.h"
#import "ZJSearchFirendVC.h"
#import "ZJGroupListVC.h"
#import "CreateGroupViewController.h"
@interface ZJGuideVC : BaseViewController
@property (weak, nonatomic)ZJChatListVC *ChatListVC;
@property (weak, nonatomic)ZJFriendListVC *FirendListVC;
@property (weak, nonatomic)ZJGroupListVC *GroupListVC;
@end
