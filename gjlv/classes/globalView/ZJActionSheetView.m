//
//  ZJActionSheetView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJActionSheetView.h"

@implementation ZJActionSheetView
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
    _mDataSoure = @[];
    
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
    
    _infoTablView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        // 磨砂效果
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        // 磨砂视图
//        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        [_blurEffectView.layer setMasksToBounds:YES];
//        [_blurEffectView.layer setCornerRadius:10.0f];
//        [_blurEffectView setFrame:CGRectMake(0, 0, 300, 150) ];
//        [_blurEffectView setCenter:_sheetWindow.center];
//        [_sheetWindow addSubview:_blurEffectView];
//        
//    } else {
//        // 屏幕截图 - 调用苹果官方框架实现磨砂效果
//        _blurEffectView = [[UIView alloc] init];
//        [_blurEffectView.layer setMasksToBounds:YES];
//        [_blurEffectView.layer setCornerRadius:10.0f];
//        [_blurEffectView setFrame:CGRectMake(0, 0, 300, 150) ];
//        [_blurEffectView setCenter:_sheetWindow.center];
//        [_sheetWindow addSubview:_blurEffectView];
//    }
    
}

-(void)dismiss{
    _sheetWindow.hidden = YES;
}
-(void)show:(NSArray *)titles{
    self.mDataSoure = titles;
    [self.infoTablView reloadData];
    self.sheetWindow.hidden = NO;
}
+(void)showTitles:(NSArray *)titles andSelectBlock:(void(^)(NSInteger index))block{
  
}
@end
