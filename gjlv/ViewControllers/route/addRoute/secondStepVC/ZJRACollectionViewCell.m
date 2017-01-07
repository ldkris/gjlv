//
//  ZJRACollectionViewCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRACollectionViewCell.h"

@implementation ZJRACollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadCellDataWithModel:(ZJMyRoteModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_title.text = model.mTagRemarks;
    self.mlab_jl.text = @"10公里";
}
@end
