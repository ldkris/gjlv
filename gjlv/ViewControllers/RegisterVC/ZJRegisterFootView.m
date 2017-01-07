//
//  ZJRegisterFootView.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRegisterFootView.h"
@interface ZJRegisterFootView ()


@end
@implementation ZJRegisterFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
//    [self.mBtn_read.layer setMasksToBounds:YES];
//    [self.mBtn_read.layer setCornerRadius:5.0f];
//    [self.mBtn_read.layer setBorderColor:SL_GRAY_BLACK.CGColor];
//    [self.mBtn_read.layer setBorderWidth:0.5f];
}
#pragma mark event response
- (IBAction)onclickReadBtn:(id)sender {
    
    if (self.ReadBlock) {
        self.ReadBlock(sender);
    }

}
- (IBAction)onclickAgreementBtn:(id)sender {
    
    if (self.AgreementBlock) {
        self.AgreementBlock(sender);
    }
}
- (IBAction)onclickRegisterBtn:(id)sender {
    if (self.RegisterBlock) {
        self.RegisterBlock(sender);
    }
}
#pragma mark public
-(void)onclickReadBtnBlock:(void (^)(UIButton *))block{
    self.ReadBlock = block;
}
-(void)onclickRegisterBtnBlock:(void (^)(UIButton *))block{
    self.RegisterBlock = block;
}
-(void)onclickAgreementBtnBlock:(void (^)(UIButton *))block{
    self.AgreementBlock = block;
}
@end
