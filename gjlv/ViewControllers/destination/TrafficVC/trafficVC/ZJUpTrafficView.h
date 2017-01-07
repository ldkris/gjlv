//
//  ZJUpTrafficView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJUpTrafficView : UIView
@property(nonatomic,copy)void(^selectMapBtn)(UIButton *sender);
@property(nonatomic,copy)void(^takePhotoBtn)(UIButton *sender);

-(void)onclickSelectMapBtn:(void(^)(UIButton *sender))block;
-(void)onclickTakePhotoBtnBtn:(void(^)(UIButton *sender))block;
@end
