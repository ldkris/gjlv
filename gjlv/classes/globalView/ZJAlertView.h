//
//  ZJAlertView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJAlertView : NSObject
@property (nonatomic,retain) UIWindow *sheetWindow;
@property (nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic,retain) UIView *blurEffectView;
@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) UILabel *mTitleLable;

@property(nonatomic,copy)void(^comfirBlock)(UIButton *sender);
@property(nonatomic,copy)void(^cancelBlock)(UIButton *sender);

+ (instancetype)shareSheet;
-(void)show;
-(void)dismiss;

-(void)showTitle:(NSString *)title cancelTitle:(NSString*)cancelStr comfirTitle:(NSString *)comfirStr cancelBlock:(void(^)(UIButton *sender))cancelBlock comfirBlock:(void(^)(UIButton *sender))comBlcok;

@end
