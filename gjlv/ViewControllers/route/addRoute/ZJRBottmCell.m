//
//  ZJRBottmCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRBottmCell.h"
#import "UIButton+vertical.h"
@implementation ZJRBottmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _mtype = 1;
    
    UISwipeGestureRecognizer *mges = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onclickleftSwip:)];
    mges.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:mges];
    //
    UISwipeGestureRecognizer *mges1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onclickleftSwip:)];
    mges1.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:mges1];
    
    NSArray *mMoreBtns = @[@"新增线路节点",@"删除线路节点"];
    NSArray *mMoreColors = @[RGBACOLOR(223, 185, 106, 1),RGBACOLOR(199, 161, 92, 1),RGBACOLOR(186, 141, 76, 1)];
    NSArray *mMoreImg = @[@"r_madd",@"r_mdele",@"r_mlook"];
    UIButton *oldbtn;
    for (int i = 0; i<mMoreBtns.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:mMoreColors[i]];
        [btn setImage:[UIImage imageNamed:mMoreImg[i]] forState:UIControlStateNormal];
        [btn setTitle:mMoreBtns[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTag:i];
        [btn addTarget:self action:@selector(onclickMoreMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:DEFAULT_FONT(13)];
        [btn verticalImageAndTitle:20.0f];
        [self.moreView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldbtn == nil) {
                make.top.left.bottom.mas_offset(0);
                make.width.mas_offset((MainScreenFrame_Width-35)/mMoreBtns.count);
            }else{
                make.top.bottom.mas_offset(0);
                make.left.equalTo(oldbtn.mas_right);
                make.width.mas_offset((MainScreenFrame_Width-35)/mMoreBtns.count);
            }
        }];
        oldbtn = btn;
    }
    
}

#pragma mark public
-(void)onclickMoreMenuBtnBlock:(void (^)(UIButton *))block{
    [self annBack];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.MoreMenuBtnBlokc = block;
    });
    
}
-(void)onclickDeleBtnBlokcBlock:(void (^)(UIButton *))block{
    [self annBack];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mDeleBtnBlokc = block;
    });
}
-(void)loadDataSoure:(ZJAfterModel *)model{
    if (model == nil) {
        return;
    }
    _mtype = [model.mtype integerValue];
    if (_mtype == 1) {
        [self.btn_gb setImage:[UIImage imageNamed:@"r_gb.png"] forState:UIControlStateNormal];
    }else{
        [self.btn_gb setImage:[UIImage imageNamed:@"r_gbb.png"] forState:UIControlStateNormal];
    }
    self.mLab_title.text = model.maname;
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
    
}
#pragma mark private
-(void)annGo{
    [UIView animateWithDuration:0.5 animations:^{
        [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.x"]; ///.y 的话就向下移动。
        animation. fromValue = [NSNumber numberWithInteger:(MainScreenFrame_Width -  35)];
        animation. toValue = [NSNumber numberWithInteger:0];
        animation. duration = 0.2;
        animation. removedOnCompletion = NO ; //yes 的话，又返回原位置了。
        animation. repeatCount = 1 ;
        animation. fillMode = kCAFillModeForwards ;
        [self.moreView.layer addAnimation:animation forKey:@"transform.translation.x"];
    }];
}
-(void)annBack{
    
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.x"]; ///.y 的话就向下移动。
    animation. toValue = [NSNumber numberWithInteger:(MainScreenFrame_Width -  35)];
    animation. fromValue = [NSNumber numberWithInteger:0];
    animation. duration = 0.2;
    animation. removedOnCompletion = NO ; //yes 的话，又返回原位置了。
    animation. repeatCount = 1 ;
    animation. fillMode = kCAFillModeForwards ;
    [self.moreView.layer addAnimation:animation forKey:@"transform.translation.x"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo((MainScreenFrame_Width -  45));
        }];
    });
}
#pragma mark event response
- (void)onclickMoreMenuBtn:(UIButton *)sender {
    if (sender.tag == 0) {
        if (self.MoreMenuBtnBlokc) {
            self.MoreMenuBtnBlokc(sender);
        }
    }else{
        if (self.mDeleBtnBlokc) {
            self.mDeleBtnBlokc(sender);
        }
    }
}

- (IBAction)onclickMoreBtn:(id)sender {
    
    [self annGo];
}

-(void)onclickleftSwip:(UISwipeGestureRecognizer *)sender{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self annGo];
    }else{
        
        [self annBack];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
