//
//  ZJGSelectLenderCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJGSelectLenderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_Head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_mdq;
@property (weak, nonatomic) IBOutlet UILabel *mlab_js;
-(void)loadDataWithModel:(ZJLeaderDetailModel *)model;
@property(nonatomic,copy)void(^selectBtn)(UIButton *sender);
-(void)onclickSelectBn:(void(^)(UIButton *sender))block;
@end
