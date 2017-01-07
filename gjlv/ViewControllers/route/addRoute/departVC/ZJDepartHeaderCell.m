//
//  ZJDepartHeaderCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDepartHeaderCell.h"

@implementation ZJDepartHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)onclickBackBtnBlock:(void (^)(UIButton *))block{
    self.backBlock = block;
}
-(void)onclickAddBtnBlock:(void (^)(UIButton *))block{
    self.addBlock = block;
}
-(void)onclickDownOrUpBtnBlock:(void (^)(UIButton *))block{
    self.downOrUpBlock = block;
}
- (IBAction)onlcickBackBtn:(id)sender {
    if (self.backBlock) {
        self.backBlock(sender);
    }
}
- (IBAction)onclickAddBtn:(id)sender {
    if (self.addBlock) {
        self.addBlock(sender);
    }
}
- (IBAction)onclickDwonOrUpBtn:(id)sender {
    if (self.downOrUpBlock) {
        self.downOrUpBlock(sender);
    }
}
-(void)loadDataSoureWithModel:(ZJMyRoteModel *)model{
    if (model == nil) {
        return;
    }
    if (model.mleaderId == nil) {
        [self.btn_status setTitle:@"为您推荐的领队" forState:UIControlStateNormal];
        return;
    }
    switch ([model.mstatus integerValue]) {
        case 2:{
            [self.btn_status setTitle:@"服务中" forState:UIControlStateNormal];
            break;}
        case 1:
            [self.btn_status setTitle:@"待服务" forState:UIControlStateNormal];
            break;
        case 3:
            if (model.mcreater == nil) {
                [self.btn_status setTitle:@"已结束" forState:UIControlStateNormal];
                
            }else{
                [self.btn_status setTitle:@"待评价" forState:UIControlStateNormal];
            }
            break;
        case 4:
            [self.btn_status setTitle:@"已评价" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
@end
