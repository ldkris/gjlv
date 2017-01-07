//
//  ZJDMyCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDMyCell1.h"

@implementation ZJDMyCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mlab_dcx.layer.masksToBounds = YES;
    self.mlab_dcx.layer.cornerRadius = 10.0f;
    self.mlab_dcx.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onclickAllRoute:(id)sender {
    self.mAllRouteBlock(sender);
}
- (IBAction)onclickDCXBtn:(id)sender {
    self.mDCXBlock(sender);
}
- (IBAction)onclickDDPBtn:(id)sender {
    self.mDDPBlock(sender);
}

-(void)onclickDCXBlock:(void (^)(UIButton *))block{
    self.mDCXBlock = block;
}
-(void)onclickDDPBBlock:(void (^)(UIButton *))block{
    self.mDDPBlock = block;
}
-(void)onclickAllRouteBlock:(void (^)(UIButton *))block{
    self.mAllRouteBlock = block;
}

-(void)loadDCXCount:(NSString *)count{
    if (count ==nil || count.length==0 || [count isEqualToString:@"0"] ) {
        return;
    }
    self.mlab_dcx.hidden = NO;
    [self.mlab_dcx setText:count];
}
@end
