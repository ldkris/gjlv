//
//  ZJPutInfoView.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/18.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJPutInfoView.h"

@implementation ZJPutInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.mcontentView insertSubview:mBarBgView atIndex:0];
    
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    self.mcontentView.layer.masksToBounds = YES;
    self.mcontentView.layer.cornerRadius = 15.0f;
}
- (IBAction)onclickCancel:(id)sender {
    [self removeFromSuperview];
}
-(void)onclickSendBtnWithBlock:(void (^)(UIButton *))block{
    self.sendBlock = block;
}
- (IBAction)onclickSenderBtn:(id)sender {
    if (self.sendBlock) {
        self.sendBlock(sender);
    }
}
@end
