//
//  ZJSHeaderView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@property (copy, nonatomic) void(^deleBtnBlock)(UIButton *sender);
-(void)onclickDeleBtnWithBlock:(void(^)(UIButton *sender))block;
@end
