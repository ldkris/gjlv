//
//  ZJDepartHeaderCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDepartHeaderCell : UITableViewCell
@property(nonatomic,copy)void(^backBlock)(UIButton *sender);
@property(nonatomic,copy)void(^addBlock)(UIButton *sender);
@property(nonatomic,copy)void(^downOrUpBlock)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UIButton *btn_status;
-(void)onclickBackBtnBlock:(void(^)(UIButton *sender))block;
-(void)onclickAddBtnBlock:(void(^)(UIButton *sender))block;
-(void)onclickDownOrUpBtnBlock:(void(^)(UIButton *sender))block;
-(void)loadDataSoureWithModel:(ZJMyRoteModel *)model;
@end
