//
//  ZJGroupListVC.m
//  gjlvLender
//
//  Created by 刘冬 on 2016/12/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGroupListVC.h"
#import "BaseTableViewCell.h"
#import "ZJChatVC.h"
#import "CreateGroupViewController.h"
#import "ApplyFriendCell.h"

@interface ZJGroupListVC ()<EMGroupManagerDelegate,ApplyFriendCellDelegate>
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *applySource;
@end

@implementation ZJGroupListVC
static ZJGroupListVC *controller = nil;

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
    
     _applySource = [NSMutableArray array];
    
#warning 把self注册为SDK的delegate
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.dataSource = [NSMutableArray array];
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    __weak __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataSourceFromLocalDB];
        [weakSelf reloadDataSource];
    }];

    [tableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)dealloc{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark private
- (void)loadDataSourceFromLocalDB
{
    [self.applySource removeAllObjects];
    NSString *loginName = [[EMClient sharedClient] currentUsername];
    if(loginName && [loginName length] > 0)
    {
        NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:[loginName stringByAppendingString:@"group"]];
        NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
        [self.applySource addObjectsFromArray:ary];
        NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma public
- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:[loginUsername stringByAppendingString:@"group"]];
        NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
        if (ary == nil || ary.count == 0) {
            NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
            [appleys addObject:dictionary];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:[loginUsername  stringByAppendingString:@"group"]];
        }else{
            for (NSDictionary *infoDic in ary) {
                if (![infoDic[@"username"] isEqualToString:applyUsername]) {
                    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
                    [appleys addObject:dictionary];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[loginUsername stringByAppendingString:@"group"]];
                }else{
                    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
                    [appleys replaceObjectAtIndex:[appleys indexOfObject:dictionary] withObject:infoDic];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[loginUsername stringByAppendingString:@"group"]];
                }
            }
        }
    }
}

#pragma mark - data

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    EMError *error;
    NSArray *rooms = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    if (!error) {
        [self.dataSource addObjectsFromArray:rooms];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }
 
}
#pragma mark - action

- (void)showPublicGroupList
{
//    PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] initWithStyle:UITableViewStylePlain];
//    [self.navigationController pushViewController:publicController animated:YES];
}

- (void)createGroup
{
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createChatroom animated:YES];
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return self.applySource.count;
    }
    return [self.dataSource count];
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
                cell.titleLabel.text = info[@"username"];
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
    
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    NSString *imageName = @"group_header";
    //        NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
    cell.imageView.image = [UIImage imageNamed:imageName];
    if (group.subject && group.subject.length > 0) {
        cell.textLabel.text = group.subject;
    }
    else {
        cell.textLabel.text = group.groupId;
    }
    cell.selectImgView.hidden = YES;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        return;
    }
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    ZJChatVC *chatController = [[ZJChatVC alloc]
                                
                                initWithConversationChatter:group.groupId
                                conversationType:EMConversationTypeGroupChat];
    chatController.title = group.subject;
    [self.navigationController pushViewController:chatController animated:YES];
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
        [label setText:@"新群邀请"];
    }else{
        //[label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    }
    [contentView addSubview:label];
    return contentView;
}
#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *entity = [self.applySource objectAtIndex:indexPath.row];
    if (entity && [[entity allKeys] count]>0) {
        ApplyStyle applyStyle = [entity[@"applyStyle"] intValue];
        if(applyStyle == ApplyStyleGroupInvitation){
            [[EMClient sharedClient].groupManager acceptInvitationFromGroup:entity[@"groupId"] inviter:entity[@"username"] completion:^(EMGroup *aGroup, EMError *aError) {
                if (aError == nil) {
                    [self.applySource removeObject:entity];
                    
                    NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:[[[EMClient sharedClient] currentUsername] stringByAppendingString:@"group"]];
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
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[[[EMClient sharedClient] currentUsername] stringByAppendingString:@"group"]];
                    
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
        if(applyStyle == ApplyStyleGroupInvitation){
        
            [[EMClient sharedClient].groupManager declineGroupInvitation:entity[@"groupId"] inviter:entity[@"username"] reason:@"" completion:^(EMError *aError) {
                if (aError == nil) {
                    [self.applySource removeObject:entity];
                    
                    NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:[[[EMClient sharedClient] currentUsername] stringByAppendingString:@"group"]];
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
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[[[EMClient sharedClient] currentUsername] stringByAppendingString:@"group"]];
                    
                    NSIndexSet *secontion = [NSIndexSet indexSetWithIndex:0];
                    [self.tableView reloadSections:secontion withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            
        }
    }
}
@end
