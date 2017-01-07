//
//  ZJDepartCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDepartCell : UITableViewCell
@property(nonatomic,copy)void(^detailBlcok)(UIButton *sender);
@property(nonatomic,copy)void(^selectBlcok)(UIButton *sender);
-(void)onclickDeletailBtnBlock:(void(^)(UIButton *sender))block;
-(void)onclickSelectBlcokBtnBlock:(void(^)(UIButton *sender))block;
-(void)loadDataSoureWithModel:(ZJLeaderDetailModel *)model;
@end
