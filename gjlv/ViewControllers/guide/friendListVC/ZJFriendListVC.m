//
//  ZJFriendListVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFriendListVC.h"
#import "ZJChatVC.h"
#import "ApplyFriendCell.h"
@interface ZJFriendListVC ()<ApplyFriendCellDelegate>
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *applySource;
@end

static ZJFriendListVC *controller = nil;

@implementation ZJFriendListVC

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    self.showRefreshHeader = YES;
    
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    _applySource = [NSMutableArray array];
    
    [self loadDataSourceFromLocalDB];//获取好友申请列表
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - public 好友

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
    
    for (NSString *buddy in buddyList) {
        [self.contactsSource addObject:buddy];
    }
    [self _sortDataArray:self.contactsSource];
    
    [self.tableView reloadData];
}
#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:loginUsername];
        NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
        if (ary == nil || ary.count == 0) {
            NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
            [appleys addObject:dictionary];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:loginUsername];
        }else{
            for (NSDictionary *infoDic in ary) {
                if (![infoDic[@"username"] isEqualToString:applyUsername]) {
                    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
                    [appleys addObject:dictionary];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:loginUsername];
                }else{
                    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
                    [appleys replaceObjectAtIndex:[appleys indexOfObject:dictionary] withObject:infoDic];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:loginUsername];
                }
            }
        }
//        [self loadDataSourceFromLocalDB];
    }
}
- (void)loadDataSourceFromLocalDB
{
    [self.applySource removeAllObjects];
    NSString *loginName = [[EMClient sharedClient] currentUsername];
    if(loginName && [loginName length] > 0)
    {
        NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:loginName];
        NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
        [self.applySource addObjectsFromArray:ary];
        NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)clear
{
    [_applySource removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark - private data 好友排序

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    for (NSString *buddy in buddyList) {
        if (![blockList containsObject:buddy]) {
            [contactsSource addObject:buddy];
        }
    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    for (EaseUserModel *buddy in contactsSource) {
        EaseUserModel *model = buddy;
        if (model) {
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            NSString *firstLetter;
          
            firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.buddy];
        
            if (model.nickname && model.nickname.length>0) {
                firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
            }
            
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - data 好友

- (void)tableViewDidTriggerHeaderRefresh
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadDataSourceFromLocalDB];
        
        EMError *error = nil;
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            NSMutableArray *contactsSource = [NSMutableArray arrayWithArray:buddyList];
            NSMutableArray *tempDataArray = [NSMutableArray array];
            
            // remove the contact that is currently in the black list
            NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
            for (NSInteger i = 0; i < buddyList.count; i++) {
                NSString *buddy = [buddyList objectAtIndex:i];
                if (![blockList containsObject:buddy]) {
                    [contactsSource addObject:buddy];
                    
                    id<IUserModel> model = nil;
                    if (weakself.dataSource && [weakself.dataSource respondsToSelector:@selector(userListViewController:modelForBuddy:)]) {
                        model = [weakself.dataSource userListViewController:self modelForBuddy:buddy];
                    }
                    else{
                        model = [[EaseUserModel alloc] initWithBuddy:buddy];
                    }
                    
                    if(model){
                        [tempDataArray addObject:model];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.dataArray removeAllObjects];
                [weakself _sortDataArray:tempDataArray];
                weakself.contactsSource = tempDataArray;
            });
        }else{
            [self reloadDataSource];
        }
        [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
    });
}

#pragma mark - Table view data source
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.dataArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        if (self.applySource.count==0) {
            return 0.00f;
        }
    }
   return 22;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    if (section == 0 && self.applySource.count >0) {
        [label setText:@"新朋友"];
    }else{
      [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    }
    [contentView addSubview:label];
    return contentView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return self.applySource.count;
    }
    return [self.dataArray[section - 1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ApplyFriendCell";
        ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // Configure the cell...
        if (cell == nil) {
            cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *info = self.applySource[indexPath.row];
        
        if (info && [[info allKeys] count]>0) {
            cell.contentLabel.text = info[@"applyMessage"];
            ApplyStyle applyStyle = [info[@"applyStyle"] intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if(applyStyle == ApplyStyleFriend){
                
                cell.titleLabel.text = info[@"username"];
                cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
            }
        }
        return cell;
    }
    
    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.avatarView.imageView.layer.masksToBounds = YES;
    cell.avatarView.imageView.layer.cornerRadius = 15.0f;
    id<IUserModel> model = nil;
    if ([self.dataSource respondsToSelector:@selector(userListViewController:userModelForIndexPath:)]) {
        model = [self.dataSource userListViewController:self userModelForIndexPath:indexPath];
    }
    else
    {
        model = self.dataArray[indexPath.section - 1][indexPath.row];
    }
  
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    
    id<IUserModel> model = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(userListViewController:userModelForIndexPath:)])
    {
        model = [self.dataSource userListViewController:self userModelForIndexPath:indexPath];
    }
    else {
        model = self.dataArray[indexPath.section - 1][indexPath.row];
    }
    
    if (model) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userListViewController:didSelectUserModel:)]) {
            [self.delegate userListViewController:self didSelectUserModel:model];
        } else {
            ZJChatVC *viewController = [[ZJChatVC alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
            viewController.title = model.nickname;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}
#pragma mark EaseUsersListViewControllerDelegate 头像 呢称
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy{
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
    
    NSDictionary *mParamDic = @{@"chatusers":buddy,@"userId":ZJ_UserID};
    
    [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
        NSArray *tempArray = responseBody[@"users"];
        if (tempArray && tempArray.count>0) {
            NSDictionary *info = tempArray[0];
            model.nickname = info[@"nickname"];
            model.avatarURLPath = info[@"headImgUrl"];
            [self _sortDataArray:self.contactsSource];
            [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    
    return model;
}

-(void )getUserInfo:(NSDictionary *)chatInfo{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:chatInfo];
    
    NSDictionary *mParamDic = @{@"chatusers":chatInfo[@"username"],@"userId":ZJ_UserID};
    [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
        NSArray *tempArray = responseBody[@"users"];
        if (tempArray && tempArray.count>0) {
            NSDictionary *info = tempArray[0];
            [result setObject:info[@"nickname"] forKey:@"nickName"];
            [result setObject:info[@"headImgUrl"] forKey:@"headImgUrl"];

            [self.applySource removeAllObjects];
            [self.applySource addObject:result];
            NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
            
        }
    } FailureBlock:^(NSError *error) {
        
    }];

}
#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *entity = [self.applySource objectAtIndex:indexPath.row];
    if (entity && [[entity allKeys] count]>0) {
        ApplyStyle applyStyle = [entity[@"applyStyle"] intValue];
        if(applyStyle == ApplyStyleFriend){
            [[EMClient sharedClient].contactManager approveFriendRequestFromUser:entity[@"username"] completion:^(NSString *aUsername, EMError *aError) {
                if (aError == nil) {
                    [self.applySource removeObject:entity];
                    
                    NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:[[EMClient sharedClient] currentUsername]];
                    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
                    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
                    NSDictionary *needDelete;
                    for (NSDictionary *tempEntity in appleys) {
                        if ([entity[@"username"] isEqualToString:tempEntity[@"username"]]) {
                            needDelete = entity;
                            break;
                        }
                    }
                    [appleys removeObject:needDelete];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[[EMClient sharedClient] currentUsername]];
                    
                    NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
                    [self.tableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
        }
    }
}
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *entity = [self.applySource objectAtIndex:indexPath.row];
    if (entity && [[entity allKeys] count]>0) {
        ApplyStyle applyStyle = [entity[@"applyStyle"] intValue];
        if(applyStyle == ApplyStyleFriend){
            [[EMClient sharedClient].contactManager declineFriendRequestFromUser:entity[@"username"] completion:^(NSString *aUsername, EMError *aError) {
                if (aError == nil) {
                    [self.applySource removeObject:entity];
                    
                    NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:[[EMClient sharedClient] currentUsername]];
                    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
                    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
                    NSDictionary *needDelete;
                    for (NSDictionary *tempEntity in appleys) {
                        if ([entity[@"username"] isEqualToString:tempEntity[@"username"]]) {
                            needDelete = entity;
                            break;
                        }
                    }
                    [appleys removeObject:needDelete];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[[EMClient sharedClient] currentUsername]];
                    
                    NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
                    [self.tableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
        }
    }
}
@end
