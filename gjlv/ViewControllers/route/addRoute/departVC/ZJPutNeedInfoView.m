//
//  ZJPutNeedInfoView.m
//  gjlv
//
//  Created by 刘冬 on 2017/1/6.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import "ZJPutNeedInfoView.h"

@implementation ZJPutNeedInfoView

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
    [self.mContentView insertSubview:mBarBgView atIndex:0];
    [mBarBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    self.tf.placeholder = @"输入其他的需求";
    
    self.mContentView.layer.masksToBounds = YES;
    self.mContentView.layer.cornerRadius = 8.0;
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclickTap:)];
    mTap.delegate = self;
    [self addGestureRecognizer:mTap];
    
    self.btn_dJD.selected = YES;
    self.btn_djd.selected = NO;
    self.mTypeStr = self.btn_dJD.titleLabel.text;
    [ self.btn_dJD setImage:[UIImage imageNamed:@"icon_yes_rb"] forState:UIControlStateSelected];
    [ self.btn_dJD setImage:[UIImage imageNamed:@"icon_no_rb"] forState:UIControlStateNormal];
    [ self.btn_djd setImage:[UIImage imageNamed:@"icon_yes_rb"] forState:UIControlStateSelected];
    [ self.btn_djd setImage:[UIImage imageNamed:@"icon_no_rb"] forState:UIControlStateNormal];
}
- (IBAction)onclickPutBtn:(id)sender {
    if (self.putBtnBlock) {
        self.putBtnBlock(sender);
    }
}
-(void)onclickTap:(UITapGestureRecognizer*)tap{
    if (self.tf.isFirstResponder) {
        [self.tf resignFirstResponder];
        return;
    }
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(self.mContentView.frame, touchPoint);
}
- (IBAction)onclickDJDBtn:(UIButton *)sender {
    sender.selected =  !sender.selected;
    self.btn_djd.selected = !sender.selected;
    self.mTypeStr = sender.titleLabel.text;
}
- (IBAction)onclickDMPBtn:(UIButton*)sender {
    sender.selected =  !sender.selected;
    self.btn_dJD.selected = !sender.selected;
    self.mTypeStr = sender.titleLabel.text;
}

@end
