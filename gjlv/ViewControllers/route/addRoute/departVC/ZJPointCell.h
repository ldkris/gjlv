//
//  ZJPointCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

@interface ZJPointCell : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mHeadView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDistance;

@property(nonatomic,strong)void(^onclickBtn)(UIButton *);
@end
