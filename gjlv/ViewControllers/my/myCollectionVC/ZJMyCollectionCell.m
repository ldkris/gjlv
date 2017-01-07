//
//  ZJMyCollectionCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyCollectionCell.h"

@implementation ZJMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataWithModel:(ZJDestModel *)model{
    if(model == nil){
        return;
    }
    [self.mimg_bg sd_setImageWithURL:[NSURL URLWithString:model.mphotos] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
    self.mlab_name.text = model.mdname;
    self.mlab_subTitle.text = model.mtitle;
    if (model.mtags && model.mtags.count >=2) {
        self.mla_tag.text = model.mtags[0][@"tname"];
        self.mlab_tag1.text = model.mtags[1][@"tname"];
    }else if (model.mtags && model.mtags.count >=1){
        self.mla_tag.text = model.mtags[0][@"tname"];
        self.mlab_tag1.text = @"";
    }else{
        self.mla_tag.text = @"";
        self.mlab_tag1.text = @"";
    }
}
@end
