//
//  ZJPutNeedInfoView.h
//  gjlv
//
//  Created by 刘冬 on 2017/1/6.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
@interface ZJPutNeedInfoView : UIView
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *tf;
@property (weak, nonatomic) IBOutlet UIButton *btn_dJD;
@property (weak, nonatomic) IBOutlet UIButton *btn_djd;
@property(strong,nonatomic)NSString *mTypeStr;
@property(nonatomic,copy)void(^putBtnBlock)(UIButton *sender);
@end
