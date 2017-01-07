//
//  ZJChatListVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJChatListVC.h"
#import "ZJChatVC.h"
@interface ZJChatListVC ()

@end

@implementation ZJChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.showRefreshHeader = YES;
    self.delegate = (id)self;
    self.dataSource = (id)self;
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}
#pragma mark - public
-(void)refresh
{
    [self refreshAndSortView];
}
- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    [self.dataArray removeAllObjects];
    NSMutableArray *mLenderArray = [NSMutableArray array];
    NSMutableArray *mUserArray = [NSMutableArray array];
    
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                               modelForConversation:converstion];
        }
        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        if (model) {
           // if(model.conversation.type ==EMConversationTypeChat){
                if ([model.title containsString:@"leader_"]) {
                    [mLenderArray addObject:model];
                }
                if ([model.title containsString:@"user_"] || model.conversation.type ==EMConversationTypeGroupChat) {
                    [mUserArray addObject:model];
                }
           // }else{
            
          //  }
        }
    }
    [self.dataArray addObjectsFromArray:@[mLenderArray,mUserArray]];
    [self.tableView reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}
#pragma mark event response

#pragma mark tableviewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger row = [self.dataArray[section] count];
    if (row>0) {
        return 22;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSInteger row = [self.dataArray[section] count];
    if (row>0) {
        UIView *contentView = [[UIView alloc] init];
        [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
        label.backgroundColor = [UIColor clearColor];
        [label setText:@[@"领队",@"朋友"][section]];
        [label setFont:DEFAULT_FONT(13)];
        [contentView addSubview:label];
        return contentView;
    }
    
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = self.dataArray[indexPath.section][indexPath.row] ;
    cell.model = model;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[self.dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
    } else {
        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [self.dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    cell.detailLabelFont = DEFAULT_FONT(13);
    cell.avatarView.imageView.layer.masksToBounds = YES;
    cell.avatarView.imageView.layer.cornerRadius = 20.0;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         EaseConversationModel *model = self.dataArray[indexPath.section][indexPath.row];
        NSMutableArray *array = self.dataArray[indexPath.section];
       
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
        [array removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
        EaseConversationModel *model = self.dataArray[indexPath.section][indexPath.row];
        if (model) {
            [self.delegate conversationListViewController:self didSelectConversationModel:model];
        }
    } else {
        EaseConversationModel *model = self.dataArray[indexPath.section][indexPath.row];
        if (model) {
            ZJChatVC *viewController = [[ZJChatVC alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
            viewController.title = model.title;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}
#pragma mark EaseConversationListViewControllerDatasoure
//最后一条消息展示时间样例
- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}
#pragma mark EaseConversationListViewControllerDelegate
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            ZJChatVC *chatController = [[ZJChatVC alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatController.title = conversationModel.title;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
}
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)versationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        NSDictionary *mParamDic = @{@"chatusers":model.title,@"userId":ZJ_UserID};
        
        [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
            NSArray *tempArray = responseBody[@"users"];
            if (tempArray && tempArray.count>0) {
                NSDictionary *info = tempArray[0];
                model.title = info[@"nickname"];
                model.avatarURLPath = info[@"headImgUrl"];
                [self.tableView reloadData];
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    }else{
        NSString *imageName = @"groupPublicHeader";
        if (![model.conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:model.conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:model.conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    model.conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = model.conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}
@end
