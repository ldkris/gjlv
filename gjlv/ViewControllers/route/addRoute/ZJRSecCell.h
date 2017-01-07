//
//  ZJRSecCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRSecCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIImageView *makrView;
@property (weak, nonatomic) IBOutlet UILabel *mLab_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_gb;

@property(nonatomic,assign)NSInteger mtype;
-(void)annBack;
-(void)annGo;
-(void)loadDataSoure:(ZJAfterModel *)model;
@property(nonatomic,copy)void(^MoreMenuBtnBlokc)(UIButton *sender);
-(void)onclickMoreMenuBtnBlock:(void(^)(UIButton *sender))block;

@property(nonatomic,copy)void(^mDeleBtnBlokc)(UIButton *sender);
-(void)onclickDeleBtnBlokcBlock:(void(^)(UIButton *sender))block;
@end
