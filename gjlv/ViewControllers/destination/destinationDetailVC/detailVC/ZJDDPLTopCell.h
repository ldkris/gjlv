//
//  ZJDDPLTopCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDPLTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;

-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model;
@end
