//
//  ZJRouteCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRouteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_leader;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_status;
@property (weak, nonatomic) IBOutlet UILabel *mlab_toCity;
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@property (weak, nonatomic) IBOutlet UILabel *mlab_stutsLable;

@property(nonatomic,assign)int dis;

@property(nonatomic,copy)void(^inviteBtnBlock)(UIButton *sender);
-(void)onclickInviteBtnBlock:(void(^)(UIButton *sender))block;
@property(nonatomic,copy)void(^checkBtnBlock)(UIButton *sender);
-(void)onclickCheckBtnBlock:(void(^)(UIButton *sender))block;
@property(nonatomic,copy)void(^statusBtnBlock)(UIButton *sender);
-(void)onclickStatusBtnBlock:(void(^)(UIButton *sender))block;

-(void)cellSetMapDelagete;
-(void)unCellSetMapDelagete;
-(void)mapViewDelloc;

-(void)loadDataSoreWithModel:(ZJMyRoteModel *)model;
@end
