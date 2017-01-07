//
//  ZJCustomRouteCell1.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCustomRouteCell1 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@property (weak, nonatomic) IBOutlet UILabel *mlab_mark;
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_mark;
-(void)loadDataSoure:(ZJAfterModel *)model;
@end
