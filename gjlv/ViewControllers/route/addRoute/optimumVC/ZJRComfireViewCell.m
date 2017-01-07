//
//  ZJRComfireViewCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/21.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRComfireViewCell.h"
@interface ZJRComfireViewCell()
@property (weak, nonatomic) IBOutlet UIView *mSubContentView;

@end
@implementation ZJRComfireViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.mSubContentView.layer setMasksToBounds:YES];
    [self.mSubContentView.layer setCornerRadius:5.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onclickAddBtn:(id)sender {
    int count = [self.mlab_num.text intValue];
    count++;
    self.mlab_num.text = [NSString stringWithFormat:@"%d",count];
}
- (IBAction)onclickJianBtn:(id)sender {
    int count = [self.mlab_num.text intValue];
    if (count <= 0) {
        return;
    }
    count--;
    self.mlab_num.text = [NSString stringWithFormat:@"%d",count];

}

@end
