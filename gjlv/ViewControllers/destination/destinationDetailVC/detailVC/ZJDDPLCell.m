//
//  ZJDDPLCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDPLCell.h"

@implementation ZJDDPLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_head.layer.masksToBounds = YES;
    self.img_head.layer.cornerRadius = 35.0/2.0;
}
-(void)loadCellDataWithModel:(ZJSceneCommModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.muname;
    self.mlab_time.text = model.mcreateTime;
    self.mlab_content.text = model.mcontent;
    [self.img_head sd_setImageWithURL:[NSURL URLWithString:model.mheadPhoto] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
