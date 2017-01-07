//
//  ZJLeaderDtialCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJLeaderDtialCell.h"

@implementation ZJLeaderDtialCell{
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadMarkbtns:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataWithModel:(ZJLeaderDetailModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_name.text = model.mnickname;
    [self.mIMG_head sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
    [self loadMarkbtns:[model.mscore intValue]];
}
-(void)loadMarkbtns:(int)count{
    int mark = 5 - count;
    UIButton *oldMakr;
    for (int i = 0; i<5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (i>=mark) {
            [markBtn setImage:[[UIImage imageNamed:@"a_smark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else{
            [markBtn setImage:[[UIImage imageNamed:@"a_kmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        [self.contentView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.right.equalTo(self.contentView.mas_right);
            }else{
                make.right.equalTo(oldMakr.mas_left).with.offset(0);
            }
            make.bottom.mas_equalTo(-8);
            make.height.width.mas_equalTo(30);
        }];
        oldMakr = markBtn;
    }
    
}
@end
