//
//  ZJDHotCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDHotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@property (weak, nonatomic) IBOutlet UILabel *mlab_temperature;
@property (weak, nonatomic) IBOutlet UIImageView *img_bg;

-(void)loadDataWithModel:(ZJDestModel *)model;
@end
