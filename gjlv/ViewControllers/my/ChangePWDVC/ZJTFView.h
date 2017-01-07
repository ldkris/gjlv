//
//  ZJTFView.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTFView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mIMG;
@property (weak, nonatomic) IBOutlet UITextField *mInputPwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_sPwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancelPwd;
@property (weak, nonatomic) IBOutlet UIView *markView;

@end
