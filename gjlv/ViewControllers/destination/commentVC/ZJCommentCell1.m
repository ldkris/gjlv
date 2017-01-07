//
//  ZJCommentCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCommentCell1.h"

@implementation ZJCommentCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.TF_input.placeholder = @"填写您的评论";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
