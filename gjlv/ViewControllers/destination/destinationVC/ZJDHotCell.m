//
//  ZJDHotCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDHotCell.h"

@implementation ZJDHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_bg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataWithModel:(ZJDestModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_title.text = model.mdname;
    if([model.mphotos containsString:@","]){
        NSArray *mImageS = [model.mphotos componentsSeparatedByString:@","];
        if (mImageS && mImageS.count>0) {
            [self.img_bg sd_setImageWithURL:[NSURL URLWithString:mImageS[0]] placeholderImage:[UIImage imageNamed:@"d_default.png"]];
        }
    }else{
       [self.img_bg sd_setImageWithURL:[NSURL URLWithString:model.mphotos] placeholderImage:[UIImage imageNamed:@"d_default.png"]];
    }
}
@end
