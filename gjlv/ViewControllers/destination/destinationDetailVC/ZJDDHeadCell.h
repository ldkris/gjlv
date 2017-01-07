//
//  ZJDDHeadCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDHeadCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_bg;

-(void)loadCellWithModel:(ZJDestModel *)model;
@end
