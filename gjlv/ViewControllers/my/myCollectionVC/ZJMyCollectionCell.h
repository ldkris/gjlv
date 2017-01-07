//
//  ZJMyCollectionCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJMyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *mla_tag;
@property (weak, nonatomic) IBOutlet UILabel *mlab_tag1;
@property (weak, nonatomic) IBOutlet UILabel *mlab_weath;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_bg;

-(void)loadDataWithModel:(ZJDestModel *)model;
@end
