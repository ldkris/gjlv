//
//  AppDelegate.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <UserNotifications/UserNotifications.h>
#import "ZJLoginVC.h"
#import "ZJGuideVC.h"
#import "ZJRegisterVC.h"
#import "ZJTabBarVC.h"
#import "BaseNavigationgVC.h"
#import "ZJHomeVC.h"
#import "ZJDestinationVC.h"
#import "ZJGuideVC.h"
#import "ZJRouteVC.h"
#import "ZJMyVC.h"
#import "ZJFriendListVC.h"
#import "ZJGroupListVC.h"
BMKMapManager* _mapManager;

@interface AppDelegate ()<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>
@property(retain,nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation AppDelegate{

     BMKLocationService* _locService;
}

#pragma mark getter
-(CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager =  [[CLLocationManager alloc]init];
    }
    return _locationManager;
}
#pragma mark app life cyle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *v = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [HttpApi getAppVersion:@{@"version":v} SuccessBlock:^(id responseBody) {
        LDLOG(@"%@",responseBody);
        
        NSString *isforce = responseBody[@"isforce"];
        NSString *downloadUrl = responseBody[@"downloadUrl"];
        NSString *content = responseBody[@"content"];
        
        if (isforce && downloadUrl && content) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APPName message:content preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不在提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [[NSUserDefaults standardUserDefaults]setObject:@"isUpdate" forKey:@"isUpdate"];
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *str = downloadUrl;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            
            // Add the actions.
            if ([isforce integerValue] == 0) {
                [alertController addAction:cancelAction];
            }
            
            [alertController addAction:otherAction];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    //注册定位权限
    [MyFounctions registerLocationPermissions:self.locationManager];
    //注册通知权限
    [MyFounctions registerNotificationCompetence];
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 1000;
    _locService.delegate = (id)self;
    [_locService startUserLocationService];
    
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57b432afe0f55a9832001a0a"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    BOOL ret = [_mapManager start:@"06LLrVHhnDP5ASaybXd64NkWIjoXMAqg" generalDelegate:(id)self];
    if (!ret) {
        LDLOG(@"manager start failed!");
    }
    //环信
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"develop";
#else
    apnsCertName = @"dis";
#endif
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:@"1155161201178082#gjlv"
                                         apnsCertName:apnsCertName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    if (![EMClient sharedClient].isLoggedIn) {
        NSString *userName = [MyFounctions getUserInfo][@"phoneNum"];
        if (userName) {
            NSString *mPhone = [NSString stringWithFormat:@"user_%@",userName];
            [[EMClient sharedClient]loginWithUsername:mPhone password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    [[EMClient sharedClient] addDelegate:(id)self delegateQueue:nil];
                    [[EMClient sharedClient] addDelegate:(id)self delegateQueue:nil];
                    [[EMClient sharedClient].groupManager addDelegate:(id)self delegateQueue:nil];
                    [[EMClient sharedClient].roomManager addDelegate:(id)self delegateQueue:nil];
                    [[EMClient sharedClient].chatManager addDelegate:(id)self];
                    [[EMClient sharedClient].contactManager addDelegate:(id)self delegateQueue:nil];
                   // [EMClient sharedClient].clien
                }
                
            }];
        }
        
    }
    
    if (self.window == nil) {
        self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, MainScreenFrame_Height)];
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    
    ZJHomeVC *mHomeVC = [[ZJHomeVC alloc]init];
    BaseNavigationgVC *mHomeNavVC = [[BaseNavigationgVC alloc]initWithRootViewController:mHomeVC];
    
    ZJDestinationVC *mDestinationVC = [[ZJDestinationVC alloc]init];
    BaseNavigationgVC *mDestinationNavVC = [[BaseNavigationgVC alloc]initWithRootViewController:mDestinationVC];
    
    ZJGuideVC *mZJGuideVC = [[ZJGuideVC alloc]init];
    BaseNavigationgVC *mGuideNavVC = [[BaseNavigationgVC alloc]initWithRootViewController:mZJGuideVC];
    
    ZJRouteVC *mRouteVC = [[ZJRouteVC alloc]init];
    BaseNavigationgVC *mRouteNavVC = [[BaseNavigationgVC alloc]initWithRootViewController:mRouteVC];
    
    ZJMyVC *mMyVC = [[ZJMyVC alloc]init];
    BaseNavigationgVC *mMyNavVC = [[BaseNavigationgVC alloc]initWithRootViewController:mMyVC];
    
    
    ZJTabBarVC *mTbaVC = [[ZJTabBarVC alloc]init];
    [mTbaVC setViewControllers:@[mHomeNavVC,mDestinationNavVC,mGuideNavVC,mRouteNavVC,mMyNavVC]];
    
    [self.window setRootViewController:mTbaVC];
    [self.window makeKeyAndVisible];
   
    
   
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark appdelegate
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if (_mainController) {
//        [_mainController didReceiveLocalNotification:notification];
//    }
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#pragma mark 百度
#pragma mark BMKUserLocationDelegate
//用户位置变化
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (ZJ_UserID) {
        //29.5889660000,106.5190890000
        NSDictionary *mparaDic = @{@"userId":ZJ_UserID,@"lat":[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude],@"lng":[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude]};
         //NSDictionary *mparaDic = @{@"userId":@"3",@"lat":@"29.5889660000",@"lng":@"106.5190890000"};
        [HttpApi upCoordinate:mparaDic SuccessBlock:^(id responseBody) {
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        LDLOG(@"联网成功");
    }
    else{
        LDLOG(@"onGetNetworkState %d",iError);
    }
    
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        LDLOG(@"授权成功");
    }
    else {
        LDLOG(@"onGetPermissionState %d",iError);
    }
}
#pragma mark -环信
#pragma mark EMClientDelegate
// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    
}
#pragma mark chatManagerDelegate
// 收到消息回调
- (void)messagesDidReceive:(NSArray *)aMessages
{
    for(EMMessage *message in aMessages){
    
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (message.chatType == EMChatTypeChat || message.chatType == EMChatTypeGroupChat) {
//#if !TARGET_IPHONE_SIMULATOR
            switch (state) {
                case UIApplicationStateActive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
//#endif
        }
        
        
        
        UITabBarController *mTabVC = (UITabBarController *)self.window.rootViewController;
        for (id tempVC  in mTabVC.viewControllers) {
            UINavigationController *tempNavVC = tempVC;
            for (id temp in tempNavVC.viewControllers) {
                if ([temp isKindOfClass:[ZJGuideVC class]]) {
                    ZJGuideVC *mGuideVC = temp;
                    [mGuideVC.ChatListVC refresh];
                    [mGuideVC.GroupListVC reloadDataSource];
                    
                    
                    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
                    NSInteger unreadCount = 0;
                    for (EMConversation *conversation in conversations) {
                        unreadCount += conversation.unreadMessagesCount;
                    }
                    UIApplication *application = [UIApplication sharedApplication];
                    [application setApplicationIconBadgeNumber:unreadCount];
                }
            }
        }
    }
   
}
- (void)userAccountDidLoginFromOtherDevice
{
   // [self _clearHelper];
    [MyFounctions removeUserInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];

    ZJLoginVC *mLoginVc = [[ZJLoginVC alloc]init];
    BaseNavigationgVC *mLoginNaviGationVC = [[BaseNavigationgVC alloc]initWithRootViewController:mLoginVc];
    [MyFounctions removeUserInfo];
    [[EMClient sharedClient]logout:YES completion:^(EMError *aError) {
        if (!aError) {
            [self.window.rootViewController presentViewController:mLoginNaviGationVC animated:YES completion:nil];
        }
    }];
}
#pragma mark EMContactManagerDelegate
//收到好友请求回调
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage{
    if (!aUsername) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    LDLOG(@"%@",dic);
    [[ZJFriendListVC shareController]addNewApply:dic];
}
#pragma mark EMGroupManagerDelegate
//收到群邀请
- (void)didReceiveGroupInvitation:(NSString *)aGroupId inviter:(NSString *)aInviter message:(NSString *)aMessage
{
    if (!aGroupId || !aInviter) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"groupId":aGroupId, @"username":aInviter, @"groupname":@"", @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    LDLOG(@"%@",dic);
    [[ZJGroupListVC shareController]addNewApply:dic];
    [[ZJGroupListVC shareController]loadDataSourceFromLocalDB];
}
#pragma mark  EMPushManagerDelegateDevice
- (void)easemobApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}
// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}
#pragma mark private
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3.0) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = @"";//[[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= 3.0) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:@"MessageType"];
    [userInfo setObject:message.conversationId forKey:@"ConversationChatter"];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
@end
