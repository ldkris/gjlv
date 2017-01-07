//
//  ZJDDPLCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDPLCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;
-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model;
@end
