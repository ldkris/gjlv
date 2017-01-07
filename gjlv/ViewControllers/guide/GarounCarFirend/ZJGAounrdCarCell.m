//
//  ZJGAounrdCarCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGAounrdCarCell.h"

@implementation ZJGAounrdCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.btn.layer setMasksToBounds:YES];
    [self.btn.layer setCornerRadius:5.0f];
    
    [self.mIMG_head.layer setMasksToBounds:YES];
    [self.mIMG_head.layer setCornerRadius:self.mIMG_head
     .frame.size.height/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataSoure:(ZJNearUserModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_Name.text = model.mnickname;
    [self.mIMG_head sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
    if([model.misFriend boolValue]){
        [self.btn setTitle:@"聊天" forState:UIControlStateNormal];
    }else{
        [self.btn setTitle:@"加好友" forState:UIControlStateNormal];
    }
}
-(void)loadDataSoureWithDic:(NSDictionary *)model{
    if (model && [[model allKeys] count]>0) {
        self.mlab_Name.text = model[@"nickname"];
        if ([self.mIMG_head isKindOfClass:[NSString class]]) {
            [self.mIMG_head sd_setImageWithURL:[NSURL URLWithString:model[@"headImgUrl"]] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
        }
    }
}
-(void)onclickAddFWithBlock:(void (^)(UIButton *))block{
    self.onclickAddFBlock = block;
}
- (IBAction)onclickAddFBtn:(id)sender {
    if (self.onclickAddFBlock) {
        self.onclickAddFBlock(sender);
    }
}
@end
