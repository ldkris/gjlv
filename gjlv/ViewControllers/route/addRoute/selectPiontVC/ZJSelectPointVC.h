//
//  ZJSelectPointVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJSelectPointVC : BaseViewController
@property(nonatomic,copy)void(^backBlock)(id info);
-(void)backInfoBlock:(void(^)(id info))block;
@end
