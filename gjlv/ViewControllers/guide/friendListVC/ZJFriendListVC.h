//
//  ZJFriendListVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface ZJFriendListVC : EaseUsersListViewController
+ (instancetype)shareController;
- (void)addNewApply:(NSDictionary *)dictionary;
- (void)loadDataSourceFromLocalDB;

- (void)reloadDataSource;
@end
