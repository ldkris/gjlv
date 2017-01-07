//
//  ZJTrafficeCellTableViewCell.h
//  gjlv
//
//  Created by 刘冬 on 2017/1/6.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTrafficeCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;
@property (weak, nonatomic) IBOutlet UILabel *mlab_ad;
@property (weak, nonatomic) IBOutlet UIImageView *mContentImageView;
-(void)loadCellDataWith:(ZJTrafficListModel *)cell;
@end
