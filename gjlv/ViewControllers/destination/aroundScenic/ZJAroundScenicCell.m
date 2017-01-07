//
//  ZJAroundScenicCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJAroundScenicCell.h"

@implementation ZJAroundScenicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJSpotModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.msname;
    self.mlab_jl.text = [NSString stringWithFormat:@"%ld",[model.mjl integerValue]/1000];
    [self.mIMG_bg sd_setImageWithURL:[NSURL URLWithString:model.mphotos] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
}
@end
