//
//  ZJFoodCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodCell1.h"

@implementation ZJFoodCell1

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
    
    self.mlab_name.text = model.mdname;
    self.mlab_count.text = [model.mtotalNum stringValue];
    [self.mImgeView sd_setImageWithURL:[NSURL URLWithString:model.mphoto] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
    
}
@end
