//
//  ZJMyleaderCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJMyleaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_sevCount;
@property (weak, nonatomic) IBOutlet UILabel *mlab_dis;

-(void)loadDataWihtModel:(ZJLenderListModel *)model;
@end
