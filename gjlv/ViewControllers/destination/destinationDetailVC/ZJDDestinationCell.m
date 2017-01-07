//
//  ZJDDestinationCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDestinationCell.h"

@implementation ZJDDestinationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mlab_name.text = @"";
    self.mlab_time.text = @"";
}
-(void)loadCellWithModel:(ZJSceneListModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mname;
    self.mlab_time.text = model.mctime;
    [self.btn_goodCoun setTitle:[model.mgoodCount stringValue] forState:UIControlStateNormal];
    [self.img_bg sd_setImageWithURL:[NSURL URLWithString:model.mphoto] placeholderImage:[UIImage imageNamed:@"dd_def2.png"]];
}
@end
