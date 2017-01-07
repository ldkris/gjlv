//
//  ZJCommentCell2.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCommentCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property(nonatomic,copy)void (^SelectBlock)(NSIndexPath* indexPath);
-(void)SelectBlock:(void (^)(NSIndexPath *))SelectBlock;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end
