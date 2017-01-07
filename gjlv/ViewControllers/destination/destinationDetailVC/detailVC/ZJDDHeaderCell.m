//
//  ZJDDHeaderCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDHeaderCell.h"

@implementation ZJDDHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_bg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model{
    if (model == nil) {
        return;
    }
    
    [self.img_bg sd_setImageWithURL:[NSURL URLWithString:model.mphotos] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
    
    UIImage *image = [MyFounctions imageCompressForWidth:self.img_bg.image targetWidth:MainScreenFrame_Width];
    self.img_bg.image = image;
    
    self.mlab_adress.text = model.maddress;
    [self.btn_goodscount setTitle:[NSString stringWithFormat:@"附近有%@条",model.mcommentCount] forState:UIControlStateNormal];
}
@end
