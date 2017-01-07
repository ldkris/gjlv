//
//  ZJAroundCarCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJAroundCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_Name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_dis;
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;
@property (weak, nonatomic) IBOutlet UIButton *btn;

-(void)loadDataSoure:(ZJNearUserModel *)model;
@end
