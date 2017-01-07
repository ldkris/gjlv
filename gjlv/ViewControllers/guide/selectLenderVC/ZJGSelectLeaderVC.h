//
//  ZJGSelectLeaderVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJGSelectLeaderVC : BaseViewController
@property(nonatomic,copy)void(^backInfo)(ZJLeaderDetailModel *leadInfo);
-(void)BackInfoWithBlock:(void(^)(ZJLeaderDetailModel *leadInfo))block;
@end
