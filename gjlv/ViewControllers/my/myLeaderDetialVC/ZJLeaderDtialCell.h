//
//  ZJLeaderDtialCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLeaderDtialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_head;

-(void)loadDataWithModel:(ZJLeaderDetailModel *)model;
@end
