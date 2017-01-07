//
//  ZJFoodCell1.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJFoodCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImgeView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;

-(void)loadDataSoureWithModel:(ZJDelicacyDetailModel *)model;


@end
