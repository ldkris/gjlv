//
//  ZJBDCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJBDCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_text;
-(void)loadDataWithModel:(ZJHotelDetialModel *)model;
@end
