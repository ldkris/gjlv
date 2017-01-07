//
//  ZJFoodCell2.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodCell2.h"

@implementation ZJFoodCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataSoureWithModel:(ZJDelicacyDetailModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_text.text = model.mdtips;
}
-(void)onlickCallPhoneBlock:(void (^)(UIButton *))blcok{
    self.callPhoneBlock = blcok;
}
- (IBAction)onclickCallPhoneBtn:(id)sender {
    if (self.callPhoneBlock) {
        self.callPhoneBlock(sender);
    }
}
@end
