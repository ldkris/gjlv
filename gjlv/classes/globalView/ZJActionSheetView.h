//
//  ZJActionSheetView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJActionSheetView : NSObject
@property (nonatomic,retain) UIWindow *sheetWindow;
@property (nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic,retain) UIView *blurEffectView;
@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) UITableView *infoTablView;

@property(nonatomic,retain)NSArray *mDataSoure;
@end
