//
//  ZJGroupListVC.h
//  gjlvLender
//
//  Created by 刘冬 on 2016/12/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJFriendListVC.h"
@interface ZJGroupListVC : UITableViewController
+ (instancetype)shareController;
- (void)addNewApply:(NSDictionary *)dictionary;
- (void)loadDataSourceFromLocalDB;
- (void)reloadDataSource;
@end
