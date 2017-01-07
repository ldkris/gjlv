//
//  ZJASDCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJASDCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_ml;
@property (weak, nonatomic) IBOutlet UILabel *mlab_content;

-(void)loadDataWithModel:(ZJCatalogModel *)model;
@end
