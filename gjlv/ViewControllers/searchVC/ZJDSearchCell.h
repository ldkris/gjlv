//
//  ZJDSearchCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDSearchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
-(void)loadDataSoureWith:(ZJDestModel *)model;
@end
