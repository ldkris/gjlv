//
//  ZJTrafficCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJTrafficCell.h"

@implementation ZJTrafficCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
    [self.contentView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
