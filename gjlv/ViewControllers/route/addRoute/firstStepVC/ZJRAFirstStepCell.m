//
//  ZJRAFirstStepCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRAFirstStepCell.h"

@implementation ZJRAFirstStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellDataSoure:(ZJMyRoteModel *)model{
    if (model == nil) {
        return;
    }
    NSArray *mTempArray = model.mafters;
    if (mTempArray) {
        NSMutableString *infoStr = [NSMutableString string];
        for (NSDictionary *info in mTempArray) {
            NSError *error;
            ZJAfterModel *model1 = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:info error:&error];
            if (!error) {
                if ([info isEqual:[mTempArray lastObject]]) {
                    [infoStr appendFormat:@"%@", [NSString stringWithFormat:@"%@",model1.maname]];
                }else{
                    [infoStr appendFormat:@"%@", [NSString stringWithFormat:@"%@>",model1.maname]];
                }
            }
        }
        self.mlab_titke.text = infoStr;
    }
}
@end
