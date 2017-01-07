//
//  ZJDepartCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDepartCell.h"
@interface ZJDepartCell()
@property (weak, nonatomic) IBOutlet UIImageView *mImgeView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;

@end
@implementation ZJDepartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.mImgeView.layer.masksToBounds = YES;
    self.mImgeView.layer.cornerRadius = 25.0f;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.contentView insertSubview:mBarBgView atIndex:0];
    
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
//    [self loadMarks:4];
}
-(void)loadDataSoureWithModel:(ZJLeaderDetailModel *)model{
    if (model == nil) {
        return;
    }
    [self.mImgeView sd_setImageWithURL:[NSURL URLWithString:model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
    self.mlab_name.text = model.mnickname;
    self.mlab_count.text = [[model.msrvCount stringValue] stringByAppendingString:@"次"];
    [self loadMarks:[model.mscore intValue]];
}
-(void)loadMarks:(int)count{
    UIImageView *oldMakr;
    for (int i = 0; i<5; i++) {
        UIImageView *markView = [[UIImageView alloc]init];
        [markView setImage:[UIImage imageNamed:@"ds_kmark"]];
        if (i<count) {
            [markView setImage:[UIImage imageNamed:@"ds_smark"]];
        }
        [self.contentView addSubview:markView];
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.left.equalTo(self.mlab_name.mas_left);
            }else{
                make.left.equalTo(oldMakr.mas_right).with.offset(5);
            }
            make.top.equalTo(self.mlab_name.mas_bottom).with.offset(8);
        }];
        
        oldMakr = markView;
    }

}
- (IBAction)onlcickDetailBtn:(id)sender {
    if ( self.detailBlcok) {
        self.detailBlcok(sender);
    }
    
}
- (IBAction)onclickSelectBtn:(id)sender {
    if ( self.selectBlcok) {
        self.selectBlcok(sender);
    }
}
-(void)onclickDeletailBtnBlock:(void (^)(UIButton *))block{
    self.detailBlcok = block;
}
-(void)onclickSelectBlcokBtnBlock:(void (^)(UIButton *))block{
    self.selectBlcok =block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
