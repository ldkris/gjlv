//
//  ZJDDContentCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_TakePP;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;

-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model;
@end
