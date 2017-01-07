//
//  ZJRegisterFootView.h
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRegisterFootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mBtn_register;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_areement;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_read;
@property (weak, nonatomic) IBOutlet UILabel *mlab_text;

@property(nonatomic,copy)void(^ReadBlock)(UIButton *sender);
@property(nonatomic,copy)void(^RegisterBlock)(UIButton *sender);
@property(nonatomic,copy)void(^AgreementBlock)(UIButton *sender);

- (void)onclickReadBtnBlock:(void(^)(UIButton *sender))block;
- (void)onclickAgreementBtnBlock:(void(^)(UIButton *sender))block;
- (void)onclickRegisterBtnBlock:(void(^)(UIButton *sender))block;

@end
