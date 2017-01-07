//
//  ZJDDHeaderCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_adress;
@property (weak, nonatomic) IBOutlet UIImageView *img_bg;
@property (weak, nonatomic) IBOutlet UIButton *btn_goodscount;

-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model;
@end
