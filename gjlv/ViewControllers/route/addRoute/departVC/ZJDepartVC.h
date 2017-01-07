//
//  ZJDepartVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJDepartVC : BaseViewController
//我的路线
@property(nonatomic,retain)ZJMyRoteModel *mMyRouteModel;
//首页精选路线
@property(nonatomic,retain)ZJRouteModel *mMyRouteModel1;
//路线途经点
@property(nonatomic,retain)NSMutableArray *mADDRoutesPoint;
//系统路线（弃用）
@property(nonatomic,retain)NSArray *mSysemRouteLines;
//路线ID
@property(nonatomic,retain)NSString *mRid;
@end
