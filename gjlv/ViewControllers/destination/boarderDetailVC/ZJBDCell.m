//
//  ZJBDCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJBDCell.h"

@implementation ZJBDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mlab_text.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJHotelDetialModel *)model{
    if (model == nil) {
        return;
    }
    
    self.mlab_text.text = model.mHdtips;
}
@end
