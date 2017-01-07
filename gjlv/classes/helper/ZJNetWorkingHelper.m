//
//  ZJNetWorkingHelper.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJNetWorkingHelper.h"
#define TIMEOUT 30
#define BaseUrl @"http://112.74.68.26:8887/"
//#define BaseUrl @"http://192.168.31.185:8887/dt-user/"
@implementation ZJNetWorkingHelper
+(ZJNetWorkingHelper *)shareNetWork{
    static ZJNetWorkingHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ZJNetWorkingHelper alloc]init];
    });
    return _sharedClient;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(NSString *)sign:(NSDictionary *)param{
    NSArray * sortedKeys =
    [[param allKeys] sortedArrayUsingComparator:^(id string1, id string2)
     {
         return [((NSString *)string1) compare:((NSString *)string2)
                                       options:NSNumericSearch];
     }];
    
    NSMutableArray *ary=[NSMutableArray array];
    NSInteger i=0;
    while (i<sortedKeys.count)
    {
        NSString *str1=[sortedKeys objectAtIndex:i];
        if (![str1 isEqualToString:@"action"])
        {
            NSString *str=[NSString stringWithFormat:@"%@%@",str1,[param objectForKey:str1]];
            [ary addObject:str];
        }
        i++;
    }
    
    NSMutableArray *newary=[NSMutableArray arrayWithArray:ary];
    [newary insertObject:@"Zjy-dt" atIndex:0];
    [newary addObject:@"Zjy-dt"];
    
    //array to string
    NSMutableString *sign=[NSMutableString string];
    for (NSString *item in newary)
    {
        [sign appendString:item];
    }
    NSString *signEncode= [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//     NSLog(@"signEncode :%@",signEncode);
    //md5
    NSString *signResult=[MyFounctions md5:signEncode];
    
    return signResult;
}
#pragma mark base
-(AFHTTPSessionManager *)baseHtppRequest{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    //header 设置
    //    [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json",@"application/x-www-form-urlencoded",@"multipart/form-data",@"image/webp",@"text/json",nil];
    return manager;
}
-(void)basePostUrl:(NSString *)url param:(NSDictionary *)param isShowLoadingView:(BOOL)isShow Success:(SuccessBlock)success failure:(FailureBlock)faileure{
    
    if (isShow) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD show];
    }
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    //公共参数
    NSMutableDictionary *mTempDic;
    if (param == nil) {
        mTempDic = [NSMutableDictionary dictionary];
    }
    mTempDic = [NSMutableDictionary dictionaryWithDictionary:param];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *v = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *timestamp=[MyFounctions getTimeStamp];
    NSString *apptype=@"2";
    
    [mTempDic setValue:v forKey:@"v"];
    [mTempDic setValue:timestamp forKey:@"timestamp"];
    [mTempDic setValue:apptype forKey:@"apptype"];
    NSString *SingStr = [self sign:mTempDic];
    [mTempDic setObject:SingStr forKey:@"sign"];
    
    [manager POST:url parameters:mTempDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success && [responseObject[@"respCode"] integerValue]==0){
             //成功回调
             if (isShow) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                 });
             }
             success(responseObject);
         }else{
             //成功回调
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:responseObject[@"respMsg"]];
             });
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (faileure) {
             //失败回调
             dispatch_async(dispatch_get_main_queue(), ^{
                 LDLOG(@"网络错误 %@   url == %@ 错误码 == %@",error.userInfo[@"NSLocalizedDescription"],url ,error.userInfo[@"NSLocalizedDescription"]);
                 NSString *errorStr = error.userInfo[@"NSLocalizedDescription"];
                 if (errorStr) {
                     [SVProgressHUD showErrorWithStatus:errorStr];
                     return ;
                 }
                 [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSDebugDescription"]];
             });
             faileure(error);
         }
     }];
}


#pragma mark Login
-(void)mRegister:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/register.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark getMobileVcode
-(void)mGetMobileVcode:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"common/getMobileVcode.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)mLogin:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/login.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)mValidateInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/validateInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)mForgetPwd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/forgetPwd.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)mPutMyInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/putMyInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)mGetMyInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/getMyInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getUptoken:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"common/getUptoken.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getAdvert:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"common/getAdvert.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)upCoordinate:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/upCoordinate.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getHotelList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"hotel/getHotelList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getHotelDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"hotel/getHotelDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)putHotelComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"hotel/putHotelComment.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)getHotelCommentList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"hotel/getHotelCommentList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getDelicacyList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"delicacy/getDelicacyList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getDelicacyDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"delicacy/getDelicacyDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)putDelicacyComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"delicacy/putDelicacyComment.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)getDelicacyCommentList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"delicacy/getDelicacyCommentList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)getSceneList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"scene/getSceneList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getSceneDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"scene/getSceneDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)putSceneComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"scene/putSceneComment.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getSceneCommentList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"scene/getSceneCommentList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)likeScene:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"scene/like.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getMenuList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"dest/getMenuList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getDestList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"dest/getDestList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getDestDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"dest/getDestDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getHotSearchDestList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"dest/getHotSearchDestList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)putScene:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"scene/putScene.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)getSpotList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"spot/getSpotList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getSpotDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"spot/getSpotDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getNearbyUsers:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"user/getNearbyUsers.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getWaitTravelCount:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/getWaitTravelCount.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)updatePasswd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/updatePasswd.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)putFeedback:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/putFeedback.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getLeaderList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/getLeaderList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getLeaderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/getLeaderDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getFootprintList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/getFootprintList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getMyDestList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/getDestList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)getRecommendList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/getRecommendList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)getLeaderSrvList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/getLeaderSrvList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)getUserChatList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"chat/getUserChatList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)searchPeople:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"chat/searchPeople.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getAllLeaders:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"chat/getAllLeaders.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getRouteList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/getMyRouteList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}

-(void)searchRouteList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/searchRouteList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getRecommendLeader:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/getRecommendLeader.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)bindLeaderd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/bindLeaderd.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getNearbyRouteUsers:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/getNearbyRouteUsers.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)updateRouteStatusTraveling:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/updateRouteStatusTraveling.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)updateRouteStatusTraveled:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/updateRouteStatusTraveled.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)putLeaderComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/putLeaderComment.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)putRoute:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/putRoute.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getRouteByInviteCode:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/getRouteByInviteCode.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)putRescue:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/putRescue.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getTrafficList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"traffic/getTrafficList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)putTravelInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"route/putTravelInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getRadius:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"common/getRadius.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getAppVersion:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"common/getAppVersion.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)putDest:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"my/putDest.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)putTraffic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"traffic/putTraffic.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)putDemand:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"demand/putDemand.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)getTrafficDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"traffic/getTrafficDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
@end
