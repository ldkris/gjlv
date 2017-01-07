//
//  trafficReportView.h
//  gjlv
//
//  Created by 刘冬 on 2017/1/5.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface trafficReportView : UIView
@property (weak, nonatomic) IBOutlet UILabel *mlab_ad;
@property (weak, nonatomic) IBOutlet UITextField *mtf_content;
@property (weak, nonatomic) IBOutlet UIView *mView;

@property(nonatomic,copy)void (^selectMapPoint)(UIButton *sender);
@property(nonatomic,copy)void (^selectPhoto)(UIButton *sender);
@property(nonatomic,copy)void (^putBtn)(UIButton *sender);
@end
