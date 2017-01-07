//
//  ZJNetWorkingHelper.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  成功回调
 *
 *  @param responseBody responseBody
 */
typedef void(^SuccessBlock)(id  responseBody);
/**
 *  失败回调
 *
 *  @param error error
 */
typedef void(^FailureBlock)(NSError * error);

@interface ZJNetWorkingHelper : NSObject
+(ZJNetWorkingHelper *)shareNetWork;


/**
 *  注册
 */
-(void)mRegister:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取验证码
 */
-(void)mGetMobileVcode:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  登陆
 */
-(void)mLogin:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  忘记密码验证账号是否存在
 */
-(void)mValidateInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  忘记密码
 */
-(void)mForgetPwd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  提交个人信息
 */
-(void)mPutMyInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取个人信息
 */
-(void)mGetMyInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取骑牛上传 1 头像 2目的地 3景点 4住宿 5美食 6实景
 */
-(void)getUptoken:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取手首页广告位
 */
-(void)getAdvert:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  上报用户坐标
 */
-(void)upCoordinate:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
#pragma mark 住宿相关接口
/**
 *  获取住宿列表
 */
-(void)getHotelList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取住宿详情
 */
-(void)getHotelDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  提交住宿评论
 */
-(void)putHotelComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取住宿点评列表接口
 */
-(void)getHotelCommentList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

#pragma mark 美食相关接口
/**
 *  获取美食列表
 */
-(void)getDelicacyList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取美食详情
 */
-(void)getDelicacyDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  提交美食评论
 */
-(void)putDelicacyComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取美食评论
 */
-(void)getDelicacyCommentList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

#pragma mark 实景相关接口
/**
 *  获取实景列表
 */
-(void)getSceneList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取实景列表
 */
-(void)getSceneDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  发布实景
 */
-(void)putScene:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  评论实景
 */
-(void)putSceneComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  点赞实景
 */
-(void)likeScene:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  评论实景
 */
-(void)putSceneComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取实景评论列表
 */
-(void)getSceneCommentList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
#pragma mark 目的地相关接口
/**
 *  获取省级菜单
 */
-(void)getMenuList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取目的地
 */
-(void)getDestList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取目的地详情
 */
-(void)getDestDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取热搜目的地
 */
-(void)getHotSearchDestList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

#pragma mark 周边景点
/**
 *  获取周边景点
 */
-(void)getSpotList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取景点详情 
 */
-(void)getSpotDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

#pragma mark 周边车友
/**
 *  获取周边车友
 */
-(void)getNearbyUsers:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

#pragma mark 我的
/**
 *  获取待出行数量
 */
-(void)getWaitTravelCount:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  修改密码
 */
-(void)updatePasswd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  提交建议
 */
-(void)putFeedback:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取的我领队
 */
-(void)getLeaderList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取的我领队详情
 */
-(void)getLeaderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取我的足迹
 */
-(void)getFootprintList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取我收藏目的地
 */
-(void)getMyDestList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 领队服务列表
 */
-(void)getLeaderSrvList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
#pragma mark 路线
/**
 *  首页的路线
 */
-(void)getRecommendList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  环信获取用户信息
 */
-(void)getUserChatList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 搜索用户
 */
-(void)searchPeople:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 * 获取领队
 */
-(void)getAllLeaders:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 获取我的路线
 */
-(void)getRouteList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 搜索路线
 */
-(void)searchRouteList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 搜索路线
 */
-(void)getRecommendLeader:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 绑定领队
 */
-(void)bindLeaderd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 获取线路上的车友
 */
-(void)getNearbyRouteUsers:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 出发
 */
-(void)updateRouteStatusTraveling:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 结束
 */
-(void)updateRouteStatusTraveled:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 评价领队
 */
-(void)putLeaderComment:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 发布路线
 */
-(void)putRoute:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 根据邀请码获取线路信息
 */
-(void)getRouteByInviteCode:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 发布救援信息
 */
-(void)putRescue:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 获取路况
 */
-(void)getTrafficList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 提交线路的出行信息
 */
-(void)putTravelInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

-(void)getRadius:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

-(void)getAppVersion:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 收藏
 */
-(void)putDest:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  发布路况
 */
-(void)putTraffic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  发布需求
 */
-(void)putDemand:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  路况详情
 */
-(void)getTrafficDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
@end
