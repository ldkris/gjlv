//
//  ZJHomeMapCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJHomeMapCell : UITableViewCell
-(void)cellSetMapDelagete;
-(void)unCellSetMapDelagete;
-(void)mapViewDelloc;

-(void)loadMapline:(ZJRouteModel *)model;
@end
