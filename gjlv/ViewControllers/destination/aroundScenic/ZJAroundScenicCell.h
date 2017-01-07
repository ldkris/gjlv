//
//  ZJAroundScenicCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJAroundScenicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_jl;
@property (weak, nonatomic) IBOutlet UILabel *mlab_poples;
@property (weak, nonatomic) IBOutlet UILabel *mlab_weath;
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_bg;

-(void)loadDataWithModel:(ZJSpotModel *)model;
@end
