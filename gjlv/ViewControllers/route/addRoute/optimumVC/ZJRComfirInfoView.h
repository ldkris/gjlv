//
//  ZJRComfirInfoView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/21.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJRComfirInfoView : UIView
@property(nonatomic,copy)void(^comfirBlock)(UIButton *sender);
-(void)onclickComfirBlock:(void(^)(UIButton *sender))block;
@property(nonatomic,retain)NSString *adultNum;
@property(nonatomic,retain)NSString *childNum;
@property(nonatomic,retain)NSString *carNum;
@property(nonatomic,retain)NSString *dateStr;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,copy)void(^selectDate)(UIButton *sender);
-(void)onclickselectDateBlock:(void(^)(UIButton *sender))block;
@end
