//
//  ZJSHeaderView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSHeaderView.h"

@implementation ZJSHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)onclickDeleBtn:(id)sender {
    if (self.deleBtnBlock) {
        self.deleBtnBlock(sender);
    }
}
-(void)onclickDeleBtnWithBlock:(void (^)(UIButton *))block{
    self.deleBtnBlock = block;
}
@end
