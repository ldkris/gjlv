//
//  ZJDDCollectionViewCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDCollectionViewCell.h"

@implementation ZJDDCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mImageView.layer.masksToBounds = YES;
    self.mImageView.layer.cornerRadius = 15.0f;
}
-(void)loadCellDataWithDic:(NSDictionary *)dic{
    if (dic == nil) {
        return;
    }
    [self.mImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"gurl"]] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];

}
@end
