//
//  ZJInPutVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJInPutVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UILabel *mlab_description;
@property(nonatomic,retain)NSIndexPath *indexPath;

//@property(nonatomic,copy)void(^backInfo)(NSString *info);
//-(void)backInfoBlock:(void(^)(NSString *infoStr))block;
@end
