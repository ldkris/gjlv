//
//  ZJModels.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJModels : MTLModel<MTLJSONSerializing>

@end


@interface ZJUserInfoModel : MTLModel<MTLJSONSerializing>
/**
 名字
 */
@property(nonatomic,retain)NSString *mName;
/**
 呢城
 */
@property(nonatomic,retain)NSString *mNickName;
/**
 头像
 */
@property(nonatomic,retain)NSString *mHeadImgUrl;
/**
 签名
 */
@property(nonatomic,retain)NSString *mSignature;
/**
 手机号
 */
@property(nonatomic,retain)NSString *mMobile;
/**
 性别 1男 2女
 */
@property(nonatomic,retain)NSNumber *mSex;
/**
  车型
 */
@property(nonatomic,retain)NSString *mCarModel;
/**
 车牌
 */
@property(nonatomic,retain)NSString *mCarNo;
/**
 车龄
 */
@property(nonatomic,retain)NSNumber *mCarAge;
/**
 累计驾驶里程
 */
@property(nonatomic,retain)NSNumber *mLjjslc;
/**
 最长自驾距离
 */
@property(nonatomic,retain)NSNumber *mZczjjl;
/**
 现有通信设备
 */
@property(nonatomic,retain)NSString *mXytxsb;
/**
 自驾经历
 */
@property(nonatomic,retain)NSArray *mTravelList;
@end
@interface ZJHotelListModel : MTLModel<MTLJSONSerializing>
/**
 酒店ID
 */
@property(nonatomic,retain)NSNumber *mHid;
/**
 酒店名字
 */
@property(nonatomic,retain)NSString *mHname;
/**
 酒店图片
 */
@property(nonatomic,retain)NSString *mHphoto;
/**
 酒店地址
 */
@property(nonatomic,retain)NSString *mHaddress;
/**
 距离
 */
@property(nonatomic,retain)NSNumber *mHjl;
/**
 评论数量
 */
@property(nonatomic,retain)NSNumber *mHcommentCount;
/**
 最低价
 */
@property(nonatomic,retain)NSNumber *mHfloorPrice;
/**
 评论列表
 */
@property(nonatomic,retain)NSArray *mHcomments;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mHlat;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mHlng;
@end
@interface ZJHotelDetialModel : MTLModel<MTLJSONSerializing>
/**
 酒店名字
 */
@property(nonatomic,retain)NSString *mHname;
/**
 酒店图片
 */
@property(nonatomic,retain)NSString *mHphoto;
/**
 酒店描述
 */
@property(nonatomic,retain)NSString *mHdesc;
/**
 酒店地址
 */
@property(nonatomic,retain)NSString *mHaddress;
/**
 酒店攻略
 */
@property(nonatomic,retain)NSString *mHdtips;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mHlat;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mHlng;
/**
 评论数
 */
@property(nonatomic,retain)NSNumber *mHcommentCount;
/**
 最低价
 */
@property(nonatomic,retain)NSNumber *mHfloorPrice;
/**
 酒店设施列表
 */
@property(nonatomic,retain)NSArray *mHfacilities;
@end

@interface ZJHotelCommentModel : MTLModel<MTLJSONSerializing>
/**
 评论ID
 */
@property(nonatomic,retain)NSNumber *mcid;
/**
 点评人ID
 */
@property(nonatomic,retain)NSNumber *muid;
/**
 点评人名称
 */
@property(nonatomic,retain)NSString *muname;
/**
 点评人头像
 */
@property(nonatomic,retain)NSString *mheadPhoto;
/**
 点评人内容
 */
@property(nonatomic,retain)NSString *mcontent;
/**
 点评时间
 */
@property(nonatomic,retain)NSString *mcreateTime;
/**
 星形评分
 */
@property(nonatomic,retain)NSNumber *mscore;
/**
 服务评分
 */
@property(nonatomic,retain)NSNumber *msscore;
/**
 环境评分
 */
@property(nonatomic,retain)NSNumber *mescore;
/**
 图片
 */
@property(nonatomic,retain)NSString *mphotos;
@end

@interface ZJDelicacyListModel : MTLModel<MTLJSONSerializing>
/**
 美食ID
 */
@property(nonatomic,retain)NSNumber *mdid;
/**
 美食名字
 */
@property(nonatomic,retain)NSString *mdname;
/**
 美食图片
 */
@property(nonatomic,retain)NSString *mphoto;
/**
 美食地址
 */
@property(nonatomic,retain)NSString *maddress;
/**
 距离
 */
@property(nonatomic,retain)NSNumber *mjl;
/**
 评论数量
 */
@property(nonatomic,retain)NSNumber *mtotalNum;
/**
 评论人姓名
 */
@property(nonatomic,retain)NSString *mcname;
/**
 评论人头像
 */
@property(nonatomic,retain)NSString *mheadImgUrl;
/**
 评论人内容
 */
@property(nonatomic,retain)NSString *mcomment;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
@end

@interface ZJDelicacyDetailModel : MTLModel<MTLJSONSerializing>
/**
 美食名字
 */
@property(nonatomic,retain)NSString *mdname;
/**
 美食图片
 */
@property(nonatomic,retain)NSString *mphoto;
/**
 美食地址
 */
@property(nonatomic,retain)NSString *maddress;
/**
 评论数量
 */
@property(nonatomic,retain)NSNumber *mtotalNum;
/**
 交通
 */
@property(nonatomic,retain)NSString *mtraffic;
/**
 餐厅攻略
 */
@property(nonatomic,retain)NSString *mdtips;
/**
 人均消费
 */
@property(nonatomic,retain)NSString *mspends;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
/**
 纬度
 */
@property(nonatomic,retain)NSString *mphone;
@end

@interface ZJDestModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,retain)NSNumber *mDid;
/**
 区域代码
 */
@property(nonatomic,retain)NSNumber *mdestId;
/**
 名称
 */
@property(nonatomic,retain)NSString *mdname;
/**
 标题
 */
@property(nonatomic,retain)NSString *mtitle;
/**
 目的地图片
 */
@property(nonatomic,retain)NSString *mphotos;
/**
 标签列表
 */
@property(nonatomic,retain)NSArray *mtags;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
@end
@interface ZJSceneListModel : MTLModel<MTLJSONSerializing>
/**
 名称
 */
@property(nonatomic,retain)NSString *mname;
/**
 实景ID
 */
@property(nonatomic,retain)NSNumber *msceneId;
/**
 图片
 */
@property(nonatomic,retain)NSString *mphoto;
/**
 点赞数
 */
@property(nonatomic,retain)NSNumber *mgoodCount;
/**
 发布时间
 */
@property(nonatomic,retain)NSString *mctime;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
@end

@interface ZJSceneDetailModel : MTLModel<MTLJSONSerializing>
/**
 用户昵称
 */
@property(nonatomic,retain)NSString *muname;
/**
 用户头像
 */
@property(nonatomic,retain)NSString *muphoto;
/**
 实景标题
 */
@property(nonatomic,retain)NSString *mtitle;
/**
 拍摄时间
 */
@property(nonatomic,retain)NSString *mctime;
/**
 拍摄地点
 */
@property(nonatomic,retain)NSString *maddress;
/**
 拍摄地点
 */
@property(nonatomic,retain)NSString *mcontent;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
/**
 是否为最佳拍摄地 1为是 2为否
 */
@property(nonatomic,retain)NSNumber *misOptimum;
/**
 实景图片多张用逗号隔开
 */
@property(nonatomic,retain)NSString *mphotos;
/**
 0:没有点赞 1:已点赞
 */
@property(nonatomic,retain) NSNumber *misLike;
/**
 评论数量
 */
@property(nonatomic,retain) NSNumber *mcommentCount;
/**
 点赞数量
 */
@property(nonatomic,retain)NSNumber *mgoodCount;
/**
 点赞用户列表
 */
@property(nonatomic,retain)NSArray *mgusers;
@end

@interface ZJSceneCommModel : MTLModel<MTLJSONSerializing>
/**
 评论ID
 */
@property(nonatomic,retain)NSNumber *mcid;
/**
 点评人ID
 */
@property(nonatomic,retain)NSNumber *muid;
/**
 点评人名称
 */
@property(nonatomic,retain)NSString *muname;
/**
 点评人头像
 */
@property(nonatomic,retain)NSString *mheadPhoto;
/**
 点评内容
 */
@property(nonatomic,retain)NSString *mcontent;
/**
 点评时间
 */
@property(nonatomic,retain)NSString *mcreateTime;
@end

@interface ZJSpotModel : MTLModel<MTLJSONSerializing>
/**
 景点ID
 */
@property(nonatomic,retain)NSNumber *msid;
/**
 景点名字
 */
@property(nonatomic,retain)NSString *msname;
/**
 地址
 */
@property(nonatomic,retain)NSString *maddress;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
/**
 图片
 */
@property(nonatomic,retain)NSString *mphotos;
/**
 与我的距离
 */
@property(nonatomic,retain)NSNumber *mjl;
@end

@interface ZJNearUserModel : MTLModel<MTLJSONSerializing>
/**
 电话
 */
@property(nonatomic,retain)NSString *mobile;
/**
 用户ID
 */
@property(nonatomic,retain)NSNumber *muserId;
/**
 头像
 */
@property(nonatomic,retain)NSString *mheadImgUrl;
/**
 用户昵称
 */
@property(nonatomic,retain)NSString *mnickname;
/**
 目的地
 */
@property(nonatomic,retain)NSString *mdst;
/**
 与我的距离
 */
@property(nonatomic,retain)NSNumber *mjl;
/**
  0 否 1 是
 */
@property(nonatomic,retain)NSNumber *misFriend;
/**
 用户所在经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 用户所在纬度
 */
@property(nonatomic,retain)NSNumber *mlat;

@end

@interface ZJCatalogModel : MTLModel<MTLJSONSerializing>
/**
 目录名称
 */
@property(nonatomic,retain)NSString *mcname;
/**
 目录内容
 */
@property(nonatomic,retain)NSString *mdescStr;
/**
 子目录列表
 */
@property(nonatomic,retain)NSArray *mcatalogs;
@end

@interface ZJLenderListModel : MTLModel<MTLJSONSerializing>
/**
 领队ID
 */
@property(nonatomic,retain)NSNumber *mleaderId;
/**
 领队昵称
 */
@property(nonatomic,retain)NSString *mnickname;
/**
 领队头像
 */
@property(nonatomic,retain)NSString *mheadImgUrl;
/**
 擅长区域
 */
@property(nonatomic,retain)NSString *mgoodArea;
/**
 服务次数
 */
@property(nonatomic,retain)NSNumber *msrvCount;
@end
@interface ZJLeaderDetailModel : MTLModel<MTLJSONSerializing>
/**
 领队ID
 */
@property(nonatomic,retain)NSNumber *mleaderId;
/**
 领队昵称
 */
@property(nonatomic,retain)NSString *mnickname;
/**
 领队头像
 */
@property(nonatomic,retain)NSString *mheadImgUrl;
/**
 擅长区域
 */
@property(nonatomic,retain)NSString *mgoodArea;
/**
 服务次数
 */
@property(nonatomic,retain)NSNumber *msrvCount;
/**
 服务星级
 */
@property(nonatomic,retain)NSNumber *mscore;
/**
 自己介绍
 */
@property(nonatomic,retain)NSString *mremarks;
/**
 联系电话
 */
@property(nonatomic,retain)NSString *mmobile;
@end

@interface ZJFootMarkModel : MTLModel<MTLJSONSerializing>
/**
 累计里程 单位公里
 */
@property(nonatomic,retain)NSNumber *mtotalMileage;
/**
 用户昵称
 */
@property(nonatomic,retain)NSString *mnickname;
/**
 用户头像
 */
@property(nonatomic,retain)NSString *mheadImgUrl;
/**
 排名
 */
@property(nonatomic,retain)NSNumber *mranking;
/**
超过多少名车友
 */
@property(nonatomic,retain)NSNumber *mcgcy;
/**
旅行线路列表
 */
@property(nonatomic,retain)NSArray *mroutes;
@end

@interface ZJRouteModel : MTLModel<MTLJSONSerializing>
/**
 用户昵称
 */
@property(nonatomic,retain)NSNumber *mrid;
/**
 用户昵称
 */
@property(nonatomic,retain)NSString *mrname;
/**
 用户昵称
 */
@property(nonatomic,retain)NSArray *mafters;
/**
 标签名
 */
@property(nonatomic,retain)NSString *mTagName;
/**
 标签名详情
 */
@property(nonatomic,retain)NSString *mTagRemarks;
/**
 是是否是精选
 */
@property(nonatomic,retain)NSNumber *mIsGood;
@end
@interface ZJAfterModel : MTLModel<MTLJSONSerializing>
/**
 途经ID
 */
@property(nonatomic,retain)NSNumber *maid;
/**
 途经点名称
 */
@property(nonatomic,retain)NSString *maname;
/**
 用户所在经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 用户所在纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
/**
 排序号
 */
@property(nonatomic,retain)NSNumber *msortNo;
/**
 1 去 2 返
 */
@property(nonatomic,retain)NSNumber *mtype;
@end

@interface ZJMyRoteModel : MTLModel<MTLJSONSerializing>
/**
 领队ID
 */
@property(nonatomic,retain)NSNumber *mleaderId;
/**
 线路设计人
 */
@property(nonatomic,retain)NSNumber *mcreater;
/**
 成人数量
 */
@property(nonatomic,retain)NSNumber *madultcount;
/**
车辆数量
 */
@property(nonatomic,retain)NSNumber *mcarcount;
/**
 儿童数量
 */
@property(nonatomic,retain)NSNumber *mchildrencount;
/**
 线路设计人姓名
 */
@property(nonatomic,retain)NSString *mcreatename;
/**
 邀请码
 */
@property(nonatomic,retain)NSString *minviteCode;
/**
 邀请码
 */
@property(nonatomic,retain)NSNumber *mrid;
/**
 线路名称
 */
@property(nonatomic,retain)NSString *mrname;
/**
 线路状态 1待出行 2已出行 3待评价 4已评价
 */
@property(nonatomic,retain)NSNumber *mstatus;
/**
 途经点列表
 */
@property(nonatomic,retain)NSArray *mafters;
/**
 标签名
 */
@property(nonatomic,retain)NSString *mTagName;
/**
 标签名详情
 */
@property(nonatomic,retain)NSString *mTagRemarks;
@end
@interface ZJTrafficListModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,retain)NSString *mName;
@property(nonatomic,retain)NSString *mAddress;
@property(nonatomic,retain)NSString *mNickName;
@property(nonatomic,retain)NSString *mHeadImageUrl;
/**
 路况ID
 */
@property(nonatomic,retain)NSNumber *mtrafficId;
/**
 路况ID
 */
@property(nonatomic,retain)NSString *mphoto;
/**
 路况内容
 */
@property(nonatomic,retain)NSString *mcontent;
/**
 路况类型1拥堵 2车祸 3封路 4施工 5积水 6故障
 */
@property(nonatomic,retain)NSNumber *mtype;
/**
 发布时间
 */
@property(nonatomic,retain)NSString *mtime;
/**
 经度
 */
@property(nonatomic,retain)NSNumber *mlng;
/**
 纬度
 */
@property(nonatomic,retain)NSNumber *mlat;
/**
 距离
 */
@property(nonatomic,retain)NSNumber *mjl;
@end
