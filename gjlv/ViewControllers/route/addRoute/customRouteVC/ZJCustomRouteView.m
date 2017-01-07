//
//  ZJCustomRouteView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCustomRouteView.h"

@implementation ZJCustomRouteView

-(void)awakeFromNib{
    [super awakeFromNib];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [mBarBgView.layer setMasksToBounds:YES];
    [mBarBgView.layer setCornerRadius:5.0f];
    [self.mContetView insertSubview:mBarBgView atIndex:0];
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
-(void)onclickChangeBlock:(void (^)())block{
    self.changeBlock = block;
}
-(void)onclickDeleBlock:(void (^)())block{
    self.deleBlock = block;
}
-(void)onclickCheckBlock:(void (^)())block{
    self.checkBlock = block;
}
- (IBAction)onclickDelegate:(id)sender {
    if (self.deleBlock) {
        self.deleBlock();
    }
}
- (IBAction)onclickCheckBtn:(id)sender {
    if (self.checkBlock) {
        self.checkBlock();
    }

}
- (IBAction)onclickGOBtn:(UIButton *)sender {
    
    if (_mtype == 1) {
        _mtype = 2;
    }else{
        _mtype = 1;
    }
    if (_mtype == 1) {
        [self.btn_gb setImage:[UIImage imageNamed:@"r_gb.png"] forState:UIControlStateNormal];
    }else{
        [self.btn_gb setImage:[UIImage imageNamed:@"r_gbb.png"] forState:UIControlStateNormal];
    }
    [sender setTag:_mtype];
    if (self.changeBlock) {
        self.changeBlock(sender);
    }
}
@end
