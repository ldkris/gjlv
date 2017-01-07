//
//  ZJPutInfoView.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/18.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPutInfoView : UIView
@property (weak, nonatomic) IBOutlet UIView *mcontentView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;
@property (weak, nonatomic) IBOutlet UILabel *mlab_adress;
@property(nonatomic,copy)void(^sendBlock)(UIButton *sender);
-(void)onclickSendBtnWithBlock:(void(^)(UIButton *sender))block;
@end
