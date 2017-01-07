//
//  ZJDSearchCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDSearchCell.h"

@implementation ZJDSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadDataSoureWith:(ZJDestModel *)model{
    if (model==nil) {
        return;
    }
    self.mlab_title.text = model.mdname;
}
@end
