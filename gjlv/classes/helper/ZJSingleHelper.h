//
//  ZJSingleHelper.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJSingleHelper : NSObject
@property(nonatomic,retain)ZJUserInfoModel*mUserInfo;
//用户的位置
@property(nonatomic,assign)CLLocationCoordinate2D mUeserPt;
+(ZJSingleHelper *)shareNetWork;
@end
