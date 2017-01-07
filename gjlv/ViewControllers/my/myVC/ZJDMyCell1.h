//
//  ZJDMyCell1.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDMyCell1 : UITableViewCell
@property(nonatomic,copy)void(^mAllRouteBlock)(UIButton *sender);
@property(nonatomic,copy)void(^mDCXBlock)(UIButton *sender);
@property(nonatomic,copy)void(^mDDPBlock)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UILabel *mlab_dcx;

-(void)onclickAllRouteBlock:(void(^)(UIButton *sender))block;
-(void)onclickDCXBlock:(void(^)(UIButton *sender))block;
-(void)onclickDDPBBlock:(void(^)(UIButton *sender))block;

-(void)loadDCXCount:(NSString *)count;
@end
