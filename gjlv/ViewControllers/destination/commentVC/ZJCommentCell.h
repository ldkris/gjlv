//
//  ZJCommentCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/12/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mHJMarkBtnView;
@property (weak, nonatomic) IBOutlet UIView *mFWMarkBtnView;
@property (weak, nonatomic) IBOutlet UIView *mKWMarkBtnView;
@property (weak, nonatomic) IBOutlet UIView *mMarkBtnView;


@property(nonatomic,copy)void(^mKWMarkBlock)(NSString *mark);
@property(nonatomic,copy)void(^mFWMarkBlock)(NSString *mark);
@property(nonatomic,copy)void(^mMarkBlock)(NSString *mark);
@property(nonatomic,copy)void(^mHJMarkBlock)(NSString *mark);

-(void)backKWMarkBlock:(void(^)(NSString *mark))block;
-(void)backMarkBlock:(void(^)(NSString *mark))block;
-(void)backFWMarkBlock:(void(^)(NSString *mark))block;
-(void)backHJMarkBlock:(void(^)(NSString *mark))block;
@end
