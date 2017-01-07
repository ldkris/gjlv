//
//  ZJFoodMapCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFoodMapCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_jl;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_hotel;
@property (weak, nonatomic) IBOutlet UILabel *mlab_adress;
-(void)loadDataWithModel:(ZJHotelListModel *)model;
@end
