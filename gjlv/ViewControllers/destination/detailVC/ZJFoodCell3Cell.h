//
//  ZJFoodCell3Cell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFoodCell3Cell : UITableViewCell
-(void)cellSetMapDelagete;
-(void)unCellSetMapDelagete;
-(void)mapViewDelloc;

-(void)loadlocWithlonlat:(CLLocationCoordinate2D )coor;

@property(nonatomic,copy)void(^naviBlock)(UIButton *sender);
-(void)onclickNavigationgBlock:(void(^)(UIButton *sender))block;
@end
