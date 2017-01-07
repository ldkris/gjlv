//
//  ZJCallOutAnnotationView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJPointCell.h"
@interface ZJCallOutAnnotationView : BMKAnnotationView
@property(nonatomic,retain) UIView *contentView;  //添加一个UIView
@property(nonatomic,retain) ZJPointCell *busInfoView;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView
@end
