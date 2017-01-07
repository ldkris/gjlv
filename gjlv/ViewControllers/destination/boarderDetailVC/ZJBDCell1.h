//
//  ZJBDCell1.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJBDCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property(nonatomic,retain)NSArray *mDataSoure;
-(void)loadDataWithModel:(ZJHotelDetialModel *)model;
@end
