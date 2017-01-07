//
//  ZJCommentCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCommentCell.h"

@implementation ZJCommentCell{
    
    NSMutableArray *_mMarkBtns;
    NSMutableArray *_mKWMarkBtns;
    NSMutableArray *_mHJMarkBtns;
    NSMutableArray *_mFWMarkBtns;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _mMarkBtns = [NSMutableArray array];
    _mKWMarkBtns = [NSMutableArray array];
    _mHJMarkBtns = [NSMutableArray array];
    _mFWMarkBtns = [NSMutableArray array];
    
    UIButton *oldMakr;
    for (int i = 0; i<5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [markBtn setImage:[[UIImage imageNamed:@"a_kmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [markBtn addTarget:self action:@selector(onclickMakrsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [markBtn setTag:i];
        [self.mMarkBtnView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.left.equalTo(self.mMarkBtnView.mas_left);
            }else{
                make.left.equalTo(oldMakr.mas_right).with.offset(0);
            }
            make.top.mas_equalTo(0);
            make.height.width.mas_equalTo(40);
        }];
        [_mMarkBtns addObject:markBtn];
        oldMakr = markBtn;
    }
    
    //口味
    UIButton *kwOldMakr;
    for (int i = 0; i<5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [markBtn setImage:[[UIImage imageNamed:@"c_unlike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [markBtn addTarget:self action:@selector(onclickKWMakrsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [markBtn setTag:10+i];
        [self.mKWMarkBtnView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kwOldMakr == nil) {
                make.left.equalTo(self.mKWMarkBtnView.mas_left);
            }else{
                make.left.equalTo(kwOldMakr.mas_right).with.offset(0);
            }
            make.top.mas_equalTo(0);
            make.height.width.mas_equalTo(40);
        }];
        [_mKWMarkBtns addObject:markBtn];
        kwOldMakr = markBtn;
    }
    
    
    //环境
    UIButton *HJOldMakr;
    for (int i = 0; i<5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [markBtn setImage:[[UIImage imageNamed:@"c_unlike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [markBtn addTarget:self action:@selector(onclickKHJakrsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [markBtn setTag:20+i];
        [self.mHJMarkBtnView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (HJOldMakr == nil) {
                make.left.equalTo(self.mHJMarkBtnView.mas_left);
            }else{
                make.left.equalTo(HJOldMakr.mas_right).with.offset(0);
            }
            make.top.mas_equalTo(0);
            make.height.width.mas_equalTo(40);
        }];
        [_mHJMarkBtns addObject:markBtn];
        HJOldMakr = markBtn;
    }
    
    //服务
    UIButton *FWOldMakr;
    for (int i = 0; i<5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [markBtn setImage:[[UIImage imageNamed:@"c_unlike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [markBtn addTarget:self action:@selector(onclickFWMakrsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [markBtn setTag:30+i];
        [self.mFWMarkBtnView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (FWOldMakr == nil) {
                make.left.equalTo(self.mFWMarkBtnView.mas_left);
            }else{
                make.left.equalTo(FWOldMakr.mas_right).with.offset(0);
            }
            make.top.mas_equalTo(0);
            make.height.width.mas_equalTo(40);
        }];
        [_mFWMarkBtns addObject:markBtn];
        FWOldMakr = markBtn;
    }
    
}

-(void)onclickMakrsBtn:(UIButton *)sender{
    
    for (UIButton *tempBtn in _mMarkBtns) {
        [tempBtn setImage:[[UIImage imageNamed:@"a_kmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        if (tempBtn.tag <= (sender.tag)) {
            [tempBtn setImage:[[UIImage imageNamed:@"a_smark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    if (self.mMarkBlock) {
        NSString *mark = [NSString stringWithFormat:@"%ld",sender.tag];
        self.mMarkBlock(mark);
    }
}
-(void)onclickKWMakrsBtn:(UIButton *)sender{
    
    for (UIButton *tempBtn in _mKWMarkBtns) {
        [tempBtn setImage:[[UIImage imageNamed:@"c_unlike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        if (tempBtn.tag <= sender.tag) {
            [tempBtn setImage:[[UIImage imageNamed:@"c_like"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    
    if (self.mKWMarkBlock) {
        NSString *mark = [NSString stringWithFormat:@"%ld",sender.tag - 10];
        self.mKWMarkBlock(mark);
    }
}
-(void)onclickKHJakrsBtn:(UIButton *)sender{
    
    for (UIButton *tempBtn in _mHJMarkBtns) {
        [tempBtn setImage:[[UIImage imageNamed:@"c_unlike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        if (tempBtn.tag <= sender.tag) {
            [tempBtn setImage:[[UIImage imageNamed:@"c_like"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    
    if (self.mHJMarkBlock) {
        NSString *mark = [NSString stringWithFormat:@"%ld",sender.tag - 20];
        self.mHJMarkBlock(mark);
    }
}

-(void)onclickFWMakrsBtn:(UIButton *)sender{
    for (UIButton *tempBtn in _mFWMarkBtns) {
        [tempBtn setImage:[[UIImage imageNamed:@"c_unlike"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        if (tempBtn.tag <= sender.tag) {
            [tempBtn setImage:[[UIImage imageNamed:@"c_like"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    
    if (self.mFWMarkBtnView) {
        NSString *mark = [NSString stringWithFormat:@"%ld",sender.tag - 30];
        self.mFWMarkBlock(mark);
    }
}

-(void)backMarkBlock:(void (^)(NSString *))block{
    self.mMarkBlock = block;
}
-(void)backKWMarkBlock:(void (^)(NSString *))block{
    self.mKWMarkBlock = block;
}
-(void)backFWMarkBlock:(void (^)(NSString *))block{
    self.mFWMarkBlock = block;
}
-(void)backHJMarkBlock:(void (^)(NSString *))block{
    self.mHJMarkBlock = block;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
