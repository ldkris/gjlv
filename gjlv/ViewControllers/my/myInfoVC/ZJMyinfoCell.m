//
//  ZJMyinfoCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyinfoCell.h"

@implementation ZJMyinfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataIndexpath:(NSIndexPath *)indexPath model:(ZJUserInfoModel *)model{
    if (model == nil) {
        return;
    }
    switch (indexPath.row) {
        case 1:
            self.mLab_subTitle.text = model.mName;
            break;
        case 2:
            self.mLab_subTitle.text = model.mNickName;
            break;
        case 3:
            self.mLab_subTitle.text = model.mMobile;
            break;
        case 4:
            self.mLab_subTitle.text = [model.mSex stringValue];
            break;
        case 5:
            self.mLab_subTitle.text = model.mCarModel;
            break;
        case 6:
            self.mLab_subTitle.text = model.mCarNo;
            break;
        case 7:
            self.mLab_subTitle.text = [model.mCarAge stringValue];
            break;
        case 8:
            self.mLab_subTitle.text = [model.mLjjslc stringValue];
            break;
        case 9:
            self.mLab_subTitle.text = [model.mZczjjl stringValue];
            break;
        case 10:
            self.mLab_subTitle.text = model.mXytxsb;
            break;
            
        default:
              self.mLab_subTitle.text = @"";
            break;
    }
}
@end
