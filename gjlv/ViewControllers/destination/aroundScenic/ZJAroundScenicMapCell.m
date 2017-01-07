//
//  ZJAroundScenicMapCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJAroundScenicMapCell.h"

@implementation ZJAroundScenicMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = BG_Yellow.CGColor;
    self.layer.borderWidth = 1.0f;
}
-(void)loadDataWithModel:(ZJSpotModel *)model{
    if (model == nil) {
        return;
    }
    
    self.mlab_name.text = model.msname;
    self.mlab_jl.text = [NSString stringWithFormat:@"%ld",[model.mjl integerValue]/1000];
    self.mlab_adress.text = model.maddress;
    [self.mIMG_bg sd_setImageWithURL:[NSURL URLWithString:model.mphotos] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
}
@end
