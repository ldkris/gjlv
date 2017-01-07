//
//  ZJSelectCarFirendView.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/23.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSelectCarFirendView.h"

@implementation ZJSelectCarFirendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.mContentView.layer.masksToBounds = YES;
    self.mContentView.layer.cornerRadius = 10.0f;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.mContentView insertSubview:mBarBgView atIndex:0];
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
-(void)onclickCancelBtnBlock:(void (^)(UIButton *))block{
    self.CancelBlock = block;
}
-(void)onclickComfirBtnBlock:(void (^)(UIButton *))block{
    self.ComfirBlock = block;
}
- (IBAction)onclickLookDetailBtn:(id)sender {
    if (self.CancelBlock ) {
        self.CancelBlock(sender);
    }
    
}
- (IBAction)onclickChatBtn:(id)sender {
    if (self.ComfirBlock ) {
        self.ComfirBlock(sender);
    }

}
@end
