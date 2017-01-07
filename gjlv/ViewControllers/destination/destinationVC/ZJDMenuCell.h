//
//  ZJDMenuCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImg_select;
@property (weak, nonatomic) IBOutlet UIImageView *mImg_mark;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;

-(void)setSelectedCellStyle;
-(void)setunSelectedCellStyle;
@end
