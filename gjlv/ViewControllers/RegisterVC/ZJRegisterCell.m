//
//  ZJRegisterCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRegisterCell.h"
@interface ZJRegisterCell()<UITextFieldDelegate>

@end
@implementation ZJRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mBtn_getCode.hidden = YES;
    self.mlab_markCode.hidden = YES;
    self.mTF_input.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)onclickGetCodeBtnBlock:(void (^)(UIButton *))block{
    self.getCodeBloclk = block;
}
- (IBAction)onclickGetCodeBtn:(id)sender {
    if (self.getCodeBloclk) {
        self.getCodeBloclk(sender);
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.mIMG_line.image = [UIImage imageNamed:@"Register_line.png"];
}
@end
