//
//  ZJCustomRouteView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCustomRouteView : UIView
@property (weak, nonatomic) IBOutlet UIView *mContetView;
@property (weak, nonatomic) IBOutlet UILabel *mLab_title;
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_mark;
@property (weak, nonatomic) IBOutlet UIButton *btn_gb;
@property(nonatomic,assign)NSInteger mtype;
@property(nonatomic,copy)void(^deleBlock)();
@property(nonatomic,copy)void(^checkBlock)();
@property(nonatomic,copy)void(^changeBlock)(UIButton *sender);

-(void)onclickDeleBlock:(void(^)())block;
-(void)onclickCheckBlock:(void(^)())block;
-(void)onclickChangeBlock:(void(^)(UIButton *sender))block;
@end
