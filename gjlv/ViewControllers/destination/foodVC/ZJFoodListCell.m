//
//  ZJFoodListCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodListCell.h"

@implementation ZJFoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJDelicacyListModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mdname;
    self.mlab_jl.text = [NSString stringWithFormat:@"距您%0.2f公里",[model.mjl floatValue]/1000];
    self.mlab_adress.text = [NSString stringWithFormat:@"位于%@",model.maddress];
    self.mlab_ccount.text = [model.mtotalNum stringValue];
    [self.mimg_hotel sd_setImageWithURL:[NSURL URLWithString:model.mphoto] placeholderImage:[UIImage imageNamed:@"f_def.png"]];
    self.mlab_comment.text = @"";
    if (model.mcomment && model.mcomment.length>0) {
        self.img_bg.image = [UIImage imageNamed:@"f_textBG.png"];
        self.mlab_comment.text = [NSString stringWithFormat:@"%@：%@",  model.mcname,model.mcomment];
    }else{
        self.img_bg.image = nil;
       [self.img_bg mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(0);
       }];
    }
}
@end
