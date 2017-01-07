//
//  ZJMyleaderCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyleaderCell.h"

@implementation ZJMyleaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.img_head.layer setMasksToBounds:YES];
    [self.img_head.layer setCornerRadius:35.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWihtModel:(ZJLenderListModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mnickname;
    self.mlab_sevCount.text = [[model.msrvCount stringValue]stringByAppendingString:@"次"];
    self.mlab_dis.text = model.mgoodArea;
    [self.img_head sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
}
@end
