//
//  ZJDepartCell1.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDepartCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImgeView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;
@property(nonatomic,copy)void(^CallBlcok)(UIButton *sender);
@property(nonatomic,copy)void(^ChatBlcok)(UIButton *sender);
-(void)onclickCallBtnBlock:(void(^)(UIButton *sender))block;
-(void)onclickChatBlcokBtnBlock:(void(^)(UIButton *sender))block;
-(void)loadDataSoureWithModel:(ZJLeaderDetailModel *)model;
@end
