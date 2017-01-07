//
//  ZJModels.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJModels.h"

@implementation ZJModels
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}
@end

@implementation ZJUserInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mName":@"name",
             @"mNickName":@"nickName",
             @"mHeadImgUrl":@"headImgUrl",
             @"mSignature":@"signature",
             @"mMobile":@"mobile",
             @"mSex":@"sex",
             @"mCarModel":@"carModel",
             @"mCarNo":@"carNo",
             @"mCarAge":@"carAge",
             @"mLjjslc":@"ljjslc",
             @"mXytxsb":@"xytxsb",
             @"mTravelList":@"travelList",
             @"mZczjjl":@"zczjjl"};
}
@end
@implementation ZJHotelListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mHid":@"hid",
             @"mHname":@"hname",
             @"mHphoto":@"hphoto",
             @"mHaddress":@"address",
             @"mHjl":@"jl",
             @"mHcommentCount":@"commentCount",
             @"mHfloorPrice":@"floorPrice",
             @"mHcomments":@"comments",
             @"mHlat":@"lat",
             @"mHlng":@"lng",
           };
}
@end

@implementation ZJHotelDetialModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mHdesc":@"hdesc",
             @"mHname":@"hname",
             @"mHphoto":@"hphoto",
             @"mHaddress":@"address",
             @"mHdtips":@"dtips",
             @"mHcommentCount":@"commentCount",
             @"mHfloorPrice":@"floorPrice",
             @"mHfacilities":@"facilities",
             @"mHlat":@"lat",
             @"mHlng":@"lng",
             };
}
@end
@implementation ZJHotelCommentModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mcid":@"cid",
             @"muid":@"uid",
             @"muname":@"uname",
             @"mcontent":@"content",
             @"mcreateTime":@"createTime",
             @"mscore":@"score",
             @"msscore":@"sscore",
             @"mescore":@"escore",
             @"mphotos":@"photos",
             @"mheadPhoto":@"headPhoto"
             };
}
@end

@implementation ZJDelicacyListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mdid":@"did",
             @"mdname":@"dname",
             @"mphoto":@"photo",
             @"maddress":@"address",
             @"mjl":@"jl",
             @"mtotalNum":@"totalNum",
             @"mcname":@"cname",
             @"mheadImgUrl":@"headImgUrl",
             @"mcomment":@"comment",
             @"mlng":@"lng",
             @"mlat":@"lat",
             };
}
@end

@implementation ZJDelicacyDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mdname":@"dname",
             @"mphoto":@"photo",
             @"maddress":@"address",
             @"mtraffic":@"traffic",
             @"mtotalNum":@"totalNum",
             @"mdtips":@"dtips",
             @"mspends":@"spends",
             @"mlng":@"lng",
             @"mlat":@"lat",
             @"mphone":@"phone"
             };
}
@end

@implementation ZJDestModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mdestId":@"destId",
             @"mdname":@"dname",
             @"mtitle":@"title",
             @"mphotos":@"photos",
             @"mtags":@"tags",
             @"mlat":@"lat",
             @"mlng":@"lng",
             @"mDid":@"did"};
};
@end

@implementation ZJSceneListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mname":@"name",
             @"msceneId":@"sceneId",
             @"mphoto":@"photo",
             @"mgoodCount":@"goodCount",
             @"mctime":@"ctime",
             @"mlng":@"lng",
             @"mlat":@"lat",};
};
@end

@implementation ZJSceneDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"muname":@"uname",
             @"muphoto":@"uphoto",
             @"mtitle":@"ctime",
             @"maddress":@"address",
             @"mlng":@"lng",
             @"mlat":@"lat",
             @"mphotos":@"photos",
             @"misLike":@"isLike",
             @"mgoodCount":@"goodCount",
             @"mgusers":@"gusers",
             @"mctime":@"ctime",
             @"mcontent":@"content",
             @"misOptimum":@"isOptimum",
             @"mcommentCount":@"commentCount"
         };
};
@end

@implementation ZJSceneCommModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mcid":@"cid",
             @"muid":@"uid",
             @"muname":@"uname",
             @"mheadPhoto":@"headPhoto",
             @"mcontent":@"content",
             @"mcreateTime":@"createTime",
             };
};
@end

@implementation ZJSpotModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"msname":@"sname",
             @"maddress":@"address",
             @"mlng":@"lng",
             @"mlat":@"lat",
             @"mphotos":@"photos",
             @"mjl":@"jl",
             @"msid":@"sid"
             };
};
@end


@implementation ZJNearUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"muserId":@"userId",
             @"mheadImgUrl":@"headImgUrl",
             @"mnickname":@"nickname",
             @"mdst":@"dst",
             @"mjl":@"jl",
             @"misFriend":@"isFriend",
             @"mlng":@"lng",
             @"mlat":@"lat",
             @"mobile":@"mobile"
             };
};
@end

@implementation ZJCatalogModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mcname":@"cname",
             @"mdescStr":@"descStr",
             @"mcatalogs":@"catalogs",
             };
};
@end

@implementation ZJLenderListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mleaderId":@"leaderId",
             @"mnickname":@"nickname",
             @"mheadImgUrl":@"headImgUrl",
             @"mgoodArea":@"goodArea",
             @"msrvCount":@"srvCount",
             };
};
@end

@implementation ZJLeaderDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mleaderId":@"leaderId",
             @"mnickname":@"nickname",
             @"mheadImgUrl":@"headImgUrl",
             @"mgoodArea":@"goodArea",
             @"msrvCount":@"srvCount",
             @"mscore":@"score",
             @"mremarks":@"remarks",
             @"mmobile":@"mobile",
             };
};
@end
@implementation ZJFootMarkModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mtotalMileage":@"totalMileage",
             @"mnickname":@"nickname",
             @"mheadImgUrl":@"headImgUrl",
             @"mranking":@"ranking",
             @"mcgcy":@"cgcy",
             @"mroutes":@"routes"
             };
};
@end
@implementation ZJRouteModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mrid":@"rid",
             @"mrname":@"rname",
             @"mafters":@"afters",
             @"mTagName":@"tagName",
              @"mTagRemarks":@"tagRemarks",
              @"mIsGood":@"isGood",
             };
};
@end

@implementation ZJAfterModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"maid":@"aid",
             @"maname":@"aname",
             @"mlng":@"lng",
             @"mlat":@"lat",
             @"msortNo":@"sortNo",
             @"mtype":@"type",
             };
};
@end

@implementation ZJMyRoteModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mcreater":@"creater",
             @"mcreatename":@"createname",
             @"minviteCode":@"inviteCode",
             @"mrid":@"rid",
             @"mrname":@"rname",
             @"mstatus":@"status",
             @"mafters":@"afters",
             @"mleaderId":@"leader",
             @"mTagRemarks":@"tagRemarks",
             @"mTagName":@"tagName",
             };
};
@end
@implementation ZJTrafficListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mtrafficId":@"trafficId",
             @"mphoto":@"photo",
             @"mcontent":@"content",
             @"mtype":@"type",
             @"mtime":@"time",
             @"mlng":@"lng",
             @"mlat":@"lat",
             @"mjl":@"jl",
             @"mName":@"name",
             @"mNickName":@"nickName",
             @"mHeadImageUrl":@"headImgUrl",
             @"mAddress":@"address"
             };
};
@end
