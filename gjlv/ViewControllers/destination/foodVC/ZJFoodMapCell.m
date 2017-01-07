//
//  ZJFoodMapCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodMapCell.h"

@implementation ZJFoodMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = BG_Yellow.CGColor;
    self.layer.borderWidth = 1.0f;
}
-(void)loadDataWithModel:(ZJDelicacyListModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mdname;
    self.mlab_jl.text = [NSString stringWithFormat:@"距您%0.2f公里",[model.mjl floatValue]/1000];
    self.mlab_adress.text = [NSString stringWithFormat:@"位于%@",model.maddress];
    [self.mimg_hotel sd_setImageWithURL:[NSURL URLWithString:model.mphoto] placeholderImage:[UIImage imageNamed:@"f_def.png"]];
}
@end
