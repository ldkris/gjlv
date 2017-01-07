//
//  ZJBoardMapCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJBoardMapCell.h"

@implementation ZJBoardMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = BG_Yellow.CGColor;
    self.layer.borderWidth = 1.0f;
}
-(void)loadDataWithModel:(ZJHotelListModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mHname;
    self.mlab_jl.text = [NSString stringWithFormat:@"距您%0.2f公里",[model.mHjl floatValue]/1000];
    self.mlab_adress.text = [NSString stringWithFormat:@"位于%@",model.mHaddress];
    self.mlab_ccount.text = [model.mHcommentCount stringValue];
    self.mlab_fprice.text = [NSString stringWithFormat:@"￥%@",[model.mHfloorPrice stringValue]];
    [self.mimg_hotel sd_setImageWithURL:[NSURL URLWithString:model.mHphoto] placeholderImage:[UIImage imageNamed:@"f_def.png"]];
    self.mlab_comment.text = @"";
    if (model.mHcomments && model.mHcomments.count>0) {
        ZJHotelCommentModel *comment = [MTLJSONAdapter modelOfClass:[ZJHotelCommentModel class] fromJSONDictionary:model.mHcomments[0] error:nil];
        self.mlab_comment.text = [NSString stringWithFormat:@"%@：%@",  comment.muname,comment.mcontent];
    }
}
@end
