//
//  ZJRComfireViewCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/22.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRComfireViewCell1.h"

@implementation ZJRComfireViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.mSubContentView.layer setMasksToBounds:YES];
    [self.mSubContentView.layer setCornerRadius:5.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
