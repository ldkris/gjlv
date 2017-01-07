//
//  ZJRegisterCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRegisterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_line;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_markCode;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_getCode;

@property(nonatomic,copy)void(^getCodeBloclk)(UIButton *sender);
-(void)onclickGetCodeBtnBlock:(void(^)(UIButton *sender))block;
@end
