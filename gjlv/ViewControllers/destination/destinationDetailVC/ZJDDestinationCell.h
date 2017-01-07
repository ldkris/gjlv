//
//  ZJDDestinationCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDestinationCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_bg;
@property (weak, nonatomic) IBOutlet UIButton *btn_goodCoun;
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
-(void)loadCellWithModel:(ZJSceneListModel *)model;
@end
