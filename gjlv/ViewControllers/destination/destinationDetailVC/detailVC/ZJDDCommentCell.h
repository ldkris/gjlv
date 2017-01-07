//
//  ZJDDCommentCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDDCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;

-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model;
@end
