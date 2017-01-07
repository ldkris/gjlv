//
//  ZJDMenuCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDMenuCell.h"

@implementation ZJDMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.mImg_select.hidden = YES;
}
-(void)setSelectedCellStyle{
//    self.mImg_select.hidden = NO;
//    [self.mlab_name setTextColor:[UIColor whiteColor]];
}

-(void)setunSelectedCellStyle{
//    self.mImg_select.hidden = YES;
//    [self.mlab_name setTextColor:[UIColor blackColor]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
