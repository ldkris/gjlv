//
//  ZJGAounrdCarCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJGAounrdCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_Name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_dis;
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property(nonatomic,copy)void(^onclickAddFBlock)(UIButton *sneder);
-(void)onclickAddFWithBlock:(void (^)(UIButton *sender))block;

-(void)loadDataSoure:(ZJNearUserModel *)model;
-(void)loadDataSoureWithDic:(NSDictionary *)model;


@end
