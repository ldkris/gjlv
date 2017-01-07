//
//  ZJDepartCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDepartCell1.h"

@implementation ZJDepartCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mImgeView.layer.masksToBounds = YES;
    self.mImgeView.layer.cornerRadius = 25.0f;
   // [self loadMarks:3];
}
-(void)loadDataSoureWithModel:(ZJLeaderDetailModel *)model{
    if (model == nil) {
        return;
    }
    [self.mImgeView sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
    self.mlab_name.text = model.mnickname;
    self.mlab_count.text = [[model.msrvCount stringValue] stringByAppendingString:@"次"];
    [self loadMarks:[model.mscore intValue]];
}
- (IBAction)onclickChatBtn:(id)sender {
    if (self.ChatBlcok) {
        self.ChatBlcok(sender);
    }
}
- (IBAction)onclickCallBtn:(id)sender {
    if (self.CallBlcok) {
        self.CallBlcok(sender);
    }
}
-(void)onclickCallBtnBlock:(void(^)(UIButton *sender))block{
    self.CallBlcok = block;
}
-(void)onclickChatBlcokBtnBlock:(void(^)(UIButton *sender))block{
    self.ChatBlcok =block;
}
-(void)loadMarks:(int)count{
    UIImageView *oldMakr;
    for (int i = 0; i<5; i++) {
        UIImageView *markView = [[UIImageView alloc]init];
        [markView setImage:[UIImage imageNamed:@"ds_kmark"]];
        if (i<count) {
            [markView setImage:[UIImage imageNamed:@"ds_smark"]];
        }
        [self.contentView addSubview:markView];
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.left.equalTo(self.mlab_name.mas_left);
            }else{
                make.left.equalTo(oldMakr.mas_right).with.offset(5);
            }
            make.top.equalTo(self.mlab_name.mas_bottom).with.offset(8);
        }];
        
        oldMakr = markView;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
