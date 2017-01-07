//
//  ZJGSelectLenderCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGSelectLenderCell.h"

@implementation ZJGSelectLenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = BG_Yellow.CGColor;
}
- (IBAction)onclickSelectBtn:(id)sender {
    if (self.selectBtn) {
        self.selectBtn(sender);
    }
}

-(void)onclickSelectBn:(void (^)(UIButton *))block{
    self.selectBtn = block;
}
-(void)loadDataWithModel:(ZJLeaderDetailModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mnickname;
    self.mlab_count.text = [[model.msrvCount stringValue] stringByAppendingString:@"次"];
    self.mlab_mdq.text = model.mgoodArea;
    self.mlab_js.text = @"无";
    if (model.mremarks && model.mremarks.length>0) {
        self.mlab_js.text = model.mremarks;
    }
   
    [self.mimg_Head sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
    
}
@end
