//
//  ZJUpTrafficView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJUpTrafficView.h"
#import "UIImage+dim.h"
@implementation ZJUpTrafficView



-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //    [self.mBarView addSubview:mBarBgView];
    [self insertSubview:mBarBgView atIndex:0];
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
//    UIImageView  *imageView=[[UIImageView alloc]init];
//    imageView.contentMode=UIViewContentModeScaleAspectFill;
//    imageView.image=[UIImage coreBlurImage:[UIImage imageNamed:@"home_mapDef"] withBlurNumber:0.6];
//    imageView.clipsToBounds=YES;
//    [self insertSubview:imageView atIndex:0];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.mas_equalTo(0);
//        }];
}
-(void)onclickSelectMapBtn:(void (^)(UIButton *))block{
    self.selectMapBtn = block;
}
-(void)onclickTakePhotoBtnBtn:(void (^)(UIButton *))block{
    self.takePhotoBtn = block;

}
- (IBAction)onclickSelectBtn:(id)sender {
//     [self removeFromSuperview];
    if ( self.selectMapBtn) {
        self.selectMapBtn(sender);
    }
}
- (IBAction)onclickTakePhotoBtn:(id)sender {
//     [self removeFromSuperview];
    if ( self.takePhotoBtn) {
        self.takePhotoBtn(sender);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
@end
