//
//  ZJFoodCell6.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFoodCell6 : UITableViewCell
/**
 评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;
/**
 评论时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;
/**
 评论人ID
 */
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
/**
    头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *mimg_head;
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;

-(void)loadHotelDataWithModel:(ZJHotelCommentModel *)model;
@end
