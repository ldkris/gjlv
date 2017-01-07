//
//  ZJDDContentCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDContentCell.h"

@implementation ZJDDContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mlab_TakePP.layer.masksToBounds = YES;
    self.mlab_TakePP.layer.cornerRadius = 2.0f;
    self.mlab_TakePP.layer.borderWidth = 0.5f;
    self.mlab_TakePP.layer.borderColor = BG_Yellow.CGColor;
    
    self.mimg_head.layer.masksToBounds = YES;
    self.mimg_head.layer.cornerRadius = self.mimg_head.frame.size.height/2;
    
    self.mlab_name.text = @"";
    self.mlab_time.text = @"";
    self.mlab_content.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model{
    if (model == nil) {
        return;
    }
    [self.mimg_head sd_setImageWithURL:[NSURL URLWithString:model.muphoto] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
    self.mlab_name.text = model.muname;
    if(model.mctime){
     self.mlab_time.text = [NSString stringWithFormat:@"拍摄于%@",model.mctime];
    }
    self.mlab_content.text = model.mcontent;
    
    if ([model.misOptimum integerValue] == 2) {
        self.mlab_TakePP.hidden = YES;
        [self.mlab_TakePP mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
@end
