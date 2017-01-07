//
//  ZJSelectDateView.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/18.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSelectDateView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePIcker;
@property(nonatomic,copy)void(^comfirBlock)(NSString *sender);
-(void)onclickComfirBlock:(void(^)(NSString *sender))block;
@end
