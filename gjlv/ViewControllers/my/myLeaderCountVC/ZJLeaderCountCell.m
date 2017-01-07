//
//  ZJLeaderCountCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJLeaderCountCell.h"

@implementation ZJLeaderCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJLeaderDetailModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mnickname;
    self.mlab_count.text = [[model.msrvCount stringValue] stringByAppendingString:@"次"];
    self.mlab_mdq.text = model.mgoodArea;
    self.mlab_js.text = model.mremarks;
    
    [self.mimg_Head sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];

}
@end
