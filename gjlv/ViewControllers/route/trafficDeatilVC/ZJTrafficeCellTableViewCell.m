//
//  ZJTrafficeCellTableViewCell.m
//  gjlv
//
//  Created by 刘冬 on 2017/1/6.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import "ZJTrafficeCellTableViewCell.h"

@implementation ZJTrafficeCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mContentImageView.layer setMasksToBounds:YES];
   // [self.mContentImageView.layer setCornerRadius:<#(CGFloat)#>]
    
    [self.mImageView.layer setMasksToBounds:YES];
    [self.mImageView.layer setCornerRadius:25.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellDataWith:(ZJTrafficListModel *)cell{
    if (cell) {
       // self.mlab_name.text = @"";
        self.mlab_content.text = cell.mcontent;
        self.mlab_name.text = cell.mNickName;
        self.mlab_ad.text = cell.mAddress;
        NSString *Mstr = cell.mHeadImageUrl;
        if (Mstr && ![Mstr isKindOfClass:[NSNull class]]) {
            [self.mImageView sd_setImageWithURL:[NSURL URLWithString:Mstr] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
        }
        NSString *str = cell.mphoto;
        if (str && ![str isKindOfClass:[NSNull class]]) {
            [self.mContentImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"dd_def.png"]];
        }
    }
}
@end
