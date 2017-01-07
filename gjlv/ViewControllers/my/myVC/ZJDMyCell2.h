//
//  ZJDMyCell2.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDMyCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property(nonatomic,retain)void(^selectIndex)(NSIndexPath *index);

-(void)onclickSelectIdex:(void(^)(NSIndexPath *index))balock;
@end
