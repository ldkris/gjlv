//
//  ZJFoodCell4.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodCell4.h"

@implementation ZJFoodCell4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJHotelDetialModel *)model{
    if (model == nil) {
        self.mlab_title.text = @"";
        return;
    }
    self.mlab_title.text = model.mHaddress;
}
-(void)loadDelDataWithMdel:(ZJDelicacyDetailModel *)model indexPath:(NSIndexPath *)indexPath{
    if (model == nil) {
        self.mlab_title.text = @"";
        return;
    }
    switch (indexPath.row) {
        case 3:
            self.mlab_title.text = model.maddress;
            break;
        case 4:
            self.mlab_text.text = @"交通";
            self.mlab_title.text = model.mtraffic;
            break;
            
        case 5:
            self.mlab_text.text = @"人均消费";
            self.mlab_title.text = [model.mspends stringByAppendingString:@"元"];
            break;
            
        default:
            self.mlab_text.text = @"";
            self.mlab_title.text = @"";
            break;
    }
    
}
@end
