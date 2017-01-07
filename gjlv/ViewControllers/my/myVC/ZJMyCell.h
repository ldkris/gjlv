//
//  ZJMyCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJMyCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
//名字
@property (weak, nonatomic) IBOutlet UILabel *mlab_Name;
//电话
@property (weak, nonatomic) IBOutlet UILabel *mlab_phoneNum;
@property(nonatomic,copy)void(^ mHeadImgBlock)(UIButton *sender);
@property(nonatomic,copy)void(^ mLDBlock)(UIButton *sender);

-(void)oncickHeadImgBlock:(void(^)(UIButton *sender))block;
-(void)oncickLDBlock:(void(^)(UIButton *sender))block;
@end
