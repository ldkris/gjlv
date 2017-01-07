//
//  ZJASDCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJASDCell.h"

@implementation ZJASDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJCatalogModel *)model{
    if (model == nil) {
        return;
    }
    
    self.mlab_ml.text = model.mcname;
    
//    NSString *str = @"人生若只如初见，何事秋风悲画扇。\n等闲变却故人心，却道故人心易变。\n骊山语罢清宵半，泪雨霖铃终不怨。\n何如薄幸锦衣郎，比翼连枝当日愿。";
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.mdescStr];
    
   NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.mdescStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mlab_content.attributedText = attrStr;
}
@end
