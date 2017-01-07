//
//  ZJMenuAlertview.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJMenuAlertview : UIView
@property (nonatomic, strong) UIWindow *sheetWindow;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic,strong)   UICollectionView *mInfoCollectView;
@property(nonatomic,strong)   UIView *blurEffectView;
@property(nonatomic,strong)   UIView *bgView;

@property(nonatomic,copy)void(^selectIndex)(NSIndexPath *index);

+ (instancetype)shareSheet;
+(void)show;
+(void)showWithTitleS:(NSArray *)titleArray andImages:(NSArray *)imgArray Block:(void(^)(NSIndexPath *index))block;
+(void)dismiss;
@end
