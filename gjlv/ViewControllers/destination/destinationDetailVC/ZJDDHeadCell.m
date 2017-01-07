//
//  ZJDDHeadCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDHeadCell.h"

@implementation ZJDDHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadCellWithModel:(ZJDestModel *)model{
    if(model == nil){
        return;
    }
    
    self.mlab_name.text = model.mdname;
    [self.mimg_bg sd_setImageWithURL:[NSURL URLWithString:model.mphotos] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
}
@end
