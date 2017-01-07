//
//  ZJDDPLTopCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDPLTopCell.h"

@implementation ZJDDPLTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_count.text = [model.mcommentCount stringValue];
}
@end
