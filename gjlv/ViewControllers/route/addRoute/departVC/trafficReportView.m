//
//  trafficReportView.m
//  gjlv
//
//  Created by 刘冬 on 2017/1/5.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import "trafficReportView.h"

@implementation trafficReportView
-(void)awakeFromNib{
    [super awakeFromNib
     ];
    UITapGestureRecognizer *mTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclickTapGesture)];
    mTapGesture.delegate = (id)self;
    [self addGestureRecognizer:mTapGesture];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(self.mView.frame, touchPoint);
}

- (IBAction)onclickSelectADBtn:(id)sender {
    if (self.selectMapPoint) {
        self.selectMapPoint(sender);
    }
}
- (IBAction)onclickSelectPhotoBtn:(id)sender {
    if(self.selectPhoto){
        self.selectPhoto(sender);
    }
}
- (IBAction)oncliPutBtn:(id)sender {
    if (self.putBtn) {
        self.putBtn(sender);
    }
}

-(void)onclickTapGesture{
    if (self.mtf_content.isFirstResponder) {
        [self.mtf_content resignFirstResponder];
        return;
    }
    [super removeFromSuperview];
}
@end
