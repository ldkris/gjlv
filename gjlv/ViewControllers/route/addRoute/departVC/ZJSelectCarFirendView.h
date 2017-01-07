//
//  ZJSelectCarFirendView.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/23.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSelectCarFirendView : UIView
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property(copy,nonatomic)void(^ComfirBlock)(UIButton *sender);
@property(copy,nonatomic)void(^CancelBlock)(UIButton *sender);

-(void)onclickComfirBtnBlock:(void(^)(UIButton *sender))block;
-(void)onclickCancelBtnBlock:(void(^)(UIButton *sender))block;
@end
