//
//  ZJRACollectionViewCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRACollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *mBGView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_jl;
-(void)loadCellDataWithModel:(ZJMyRoteModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@end
