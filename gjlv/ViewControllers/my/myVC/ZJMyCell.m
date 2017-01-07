//
//  ZJMyCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyCell.h"

@implementation ZJMyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_head.layer.masksToBounds = YES;
    self.img_head.layer.cornerRadius = 35.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onclickHeadIMGBtn:(id)sender {
    if (self.mHeadImgBlock) {
        self.mHeadImgBlock(sender);
    }
}
- (IBAction)onclickLDBtn:(id)sender {
    if (self.mLDBlock) {
        self.mLDBlock(sender);
    }
}

-(void)oncickLDBlock:(void (^)(UIButton *))block{
    self.mLDBlock = block;
}
-(void)oncickHeadImgBlock:(void (^)(UIButton *))block{
    self.mHeadImgBlock = block;
}
@end
