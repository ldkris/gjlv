//
//  ZJDTableviewCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDTableviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property(copy,nonatomic)void(^selectIndex)(NSIndexPath * index);
-(void)selecIndex:(void(^)(NSIndexPath * index))block;

-(void)loadDataWithModel:(ZJDestModel *)model;
@end
