//
//  ZJSelectMapVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJSelectMapVC : BaseViewController
@property(nonatomic,copy)void(^backBlock)(id temp);
-(void)backInfo:(void(^)(id temp))blcok;
@end
