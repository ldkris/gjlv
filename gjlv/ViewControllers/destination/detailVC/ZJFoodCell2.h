//
//  ZJFoodCell2.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFoodCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_text;

-(void)loadDataSoureWithModel:(ZJDelicacyDetailModel *)model;

@property(nonatomic,copy)void(^callPhoneBlock)(UIButton *sender);
-(void)onlickCallPhoneBlock:(void(^)(UIButton *sender))blcok;
@end
