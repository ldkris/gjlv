//
//  ZJSelectDateView.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/18.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSelectDateView.h"

@implementation ZJSelectDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onclickCancel:(id)sender {
    [super removeFromSuperview];
}
-(void)onclickComfirBlock:(void (^)(NSString *))block{
    self.comfirBlock = block;
}
- (IBAction)onclickComrBlock:(id)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fixString = [dateFormatter stringFromDate:self.datePIcker.date];
    
    if (self.comfirBlock) {
        self.comfirBlock(fixString);
    }
}

@end
