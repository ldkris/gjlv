//
//  ZJMyinfoCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJMyinfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLab_Title;
@property (weak, nonatomic) IBOutlet UILabel *mLab_subTitle;

-(void)loadDataIndexpath:(NSIndexPath *)indexPath model:(ZJUserInfoModel *)model;
@end
