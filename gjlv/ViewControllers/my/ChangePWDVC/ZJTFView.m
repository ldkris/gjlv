//
//  ZJTFView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJTFView.h"

@implementation ZJTFView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.mInputPwd.delegate = (id)self;
    [ self.mInputPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.btn_sPwd.enabled = NO;
    self.btn_cancelPwd.enabled = NO;
    
    [self.mInputPwd setSecureTextEntry:YES];
}

- (void)textFieldDidChange:(UITextView *)textField {
    if(textField.text.length == 0 ){
        [self.markView setBackgroundColor:SL_GRAY];
        [self.btn_sPwd setImage:[UIImage imageNamed:@"c_unsPwd"] forState:UIControlStateNormal];
        
        self.btn_sPwd.enabled = NO;
        self.btn_cancelPwd.enabled = NO;
    }else{
        [self.markView setBackgroundColor:BG_Yellow];
        [self.btn_sPwd setImage:[UIImage imageNamed:@"c_sPwd"] forState:UIControlStateNormal];
        
        self.btn_sPwd.enabled = YES;
        self.btn_cancelPwd.enabled = YES;
    }

}
- (IBAction)onclickSBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.mInputPwd setSecureTextEntry:!self.mInputPwd.selected];
}
- (IBAction)onclickCancelBtn:(UIButton *)sender {
    self.mInputPwd.text = @"";
}
@end
