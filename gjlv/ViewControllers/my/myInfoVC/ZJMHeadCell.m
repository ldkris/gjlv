//
//  ZJMHeadCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMHeadCell.h"

@implementation ZJMHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mIMG.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
