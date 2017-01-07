//
//  ZJFoodCell4.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFoodCell4 : UITableViewCell
//二级
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
//一级
@property (weak, nonatomic) IBOutlet UILabel *mlab_text;

/**
 加载住宿

 */
-(void)loadDataWithModel:(ZJHotelDetialModel *)model;

/**
 加载美食数据

 @param model 美食
 */
-(void)loadDelDataWithMdel:(ZJDelicacyDetailModel *)model indexPath:(NSIndexPath *)indexPath;
@end
