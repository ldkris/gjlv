//
//  ZJCustomRouteCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCustomRouteCell1.h"

@implementation ZJCustomRouteCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadDataSoure:(ZJAfterModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_title.text = model.maname;
}
@end
