//
//  ZJSearchPointVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJSearchPointVC : BaseViewController
@property(nonatomic,copy)void(^BackInfoBlock)(BMKPoiInfo *info);

-(void)backInfoBlock:(void(^)(BMKPoiInfo *info))block;
@end
