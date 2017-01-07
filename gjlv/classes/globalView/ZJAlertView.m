//
//  ZJAlertView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJAlertView.h"

@implementation ZJAlertView
+ (instancetype)shareSheet{
    static id shareSheet;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareSheet = [[[self class] alloc] init];
        
    });
    return shareSheet;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSheetWindow];
    }
    return self;
}
- (void)initSheetWindow{
    _sheetWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, MainScreenFrame_Height)];
    _sheetWindow.windowLevel = UIWindowLevelStatusBar;
//    _sheetWindow.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    _sheetWindow.hidden = NO;
    
    _bgView = [[UIView alloc]init];
    [_bgView setBackgroundColor:[UIColor clearColor]];
    [_bgView setFrame:_sheetWindow.frame];
    [_sheetWindow addSubview:_bgView];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.delegate = (id)self;
    [_bgView addGestureRecognizer:_tapGesture];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // 磨砂效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        // 磨砂视图
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [_blurEffectView.layer setMasksToBounds:YES];
        [_blurEffectView.layer setCornerRadius:10.0f];
        [_blurEffectView setFrame:CGRectMake(0, 0, 300, 150) ];
        [_blurEffectView setCenter:_sheetWindow.center];
        [_sheetWindow addSubview:_blurEffectView];
        
    } else {
        // 屏幕截图 - 调用苹果官方框架实现磨砂效果
        _blurEffectView = [[UIView alloc] init];
        [_blurEffectView.layer setMasksToBounds:YES];
        [_blurEffectView.layer setCornerRadius:10.0f];
        [_blurEffectView setFrame:CGRectMake(0, 0, 300, 150) ];
        [_blurEffectView setCenter:_sheetWindow.center];
        [_sheetWindow addSubview:_blurEffectView];
    }
    
    _mTitleLable = [[UILabel alloc]init];
    [_mTitleLable setText:@"asd?"];
    [_mTitleLable setFont:DEFAULT_FONT(16)];
    [_mTitleLable setTextColor:[UIColor whiteColor]];
    [_blurEffectView addSubview:_mTitleLable];
    
    [_mTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-25);
    }];
    
}
-(void)SingleTap:(UITapGestureRecognizer *)sender{
    [self dismiss];
}
-(void)dismiss{
    _sheetWindow.hidden = YES;
}
-(void)show{
    self.sheetWindow.hidden = NO;
}
-(void)showTitle:(NSString *)title cancelTitle:(NSString *)cancelStr comfirTitle:(NSString *)comfirStr cancelBlock:(void (^)(UIButton *))cancelBlock comfirBlock:(void (^)(UIButton *))comBlcok{
    [self show];
    if (title) {
        _mTitleLable.text = title;
    }

    if (cancelStr) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(onclickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [cancelBtn.layer setBorderWidth:0.5];
        [cancelBtn.titleLabel setFont:DEFAULT_FONT(14)];
        [_blurEffectView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(1);
            make.left.mas_equalTo(-1);
            make.right.mas_equalTo(-_blurEffectView.frame.size.width/2);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (comfirStr) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:comfirStr forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BG_Yellow forState:UIControlStateNormal];
        [cancelBtn.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [cancelBtn.layer setBorderWidth:0.5];
        [cancelBtn addTarget:self action:@selector(onclickcomFirlBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn.titleLabel setFont:DEFAULT_FONT(14)];
        [_blurEffectView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(1);
            make.right.mas_equalTo(1);
            make.left.mas_equalTo(_blurEffectView.frame.size.width/2);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (comBlcok) {
        self.comfirBlock = comBlcok;
    }
    
    if (cancelBlock) {
        self.cancelBlock = cancelBlock;
    }

}

-(void)onclickcomFirlBtn:(UIButton *)sender{
    if (self.comfirBlock) {
        [self dismiss];
        self.comfirBlock(sender);
    }
}
-(void)onclickCancelBtn:(UIButton *)sender{
    if (self.cancelBlock) {
        [self dismiss];
        self.cancelBlock(sender);
    }
}
@end
