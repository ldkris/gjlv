//
//  ZJAppraiseLeaderVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJAppraiseLeaderVC.h"
#import "PlaceholderTextView.h"
@interface ZJAppraiseLeaderVC ()
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@property (weak, nonatomic) IBOutlet UIView *mMarkBtnView;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *TF_input;
@end

@implementation ZJAppraiseLeaderVC{

    NSMutableArray *_mMarkBtns;
    ZJLeaderDetailModel *_model;
    
    NSInteger socre;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"重庆 - 丽江";
    
    socre = 0;
    
    self.mIMG_head.layer.masksToBounds  = YES;
    self.mIMG_head.layer.cornerRadius = 25.0f;
    
    _mMarkBtns = [NSMutableArray array];
    
    UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
    [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
    [mRightBtn addTarget:self action:@selector(onclickRight:) forControlEvents:UIControlEventTouchUpInside];
    [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:mRightBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.TF_input.placeholder = @"对此次出行领队是否满意？快快来告诉大家把！";
    
    [self loadMarkbtns];
    
    [self getLeaderDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getLeaderDetail{
    
    if (self.mMyRouteModel) {
        [HttpApi getLeaderDetail:@{@"userId":ZJ_UserID,@"leaderId":[self.mMyRouteModel.mleaderId stringValue]}SuccessBlock:^(id responseBody) {
            NSError *error;
            ZJLeaderDetailModel *temp = [MTLJSONAdapter modelOfClass:[ZJLeaderDetailModel class] fromJSONDictionary:responseBody error:&error];
            if (!error) {
                _model = temp;
                self.mlab_title.text = _model.mnickname;
                [self.mIMG_head sd_setImageWithURL:[NSURL URLWithString:_model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    }

}
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{
    [self.TF_input resignFirstResponder];
    if (self.TF_input.text.length == 0 || self.TF_input.text == nil) {
        ShowMSG(@"请输入评价");
        return;
    }
    NSDictionary *mParam = @{@"userId":ZJ_UserID,@"leaderId":[self.mMyRouteModel.mleaderId stringValue],@"urId":[self.mMyRouteModel.mrid stringValue],@"content":self.TF_input.text,@"score":[NSString stringWithFormat:@"%ld",socre]};
    [HttpApi putLeaderComment:mParam SuccessBlock:^(id responseBody) {
        [self.navigationController popViewControllerAnimated:YES];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)onclickMakrsBtn:(UIButton *)sender{
    socre = sender.tag;
    for (UIButton *tempBtn in _mMarkBtns) {
        [tempBtn setImage:[[UIImage imageNamed:@"a_kmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        if (tempBtn.tag <= sender.tag) {
            [tempBtn setImage:[[UIImage imageNamed:@"a_smark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
}
#pragma mark private
-(void)loadMarkbtns{
    UIButton *oldMakr;
    for (int i = 0; i<5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [markBtn setImage:[[UIImage imageNamed:@"a_kmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [markBtn addTarget:self action:@selector(onclickMakrsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [markBtn setTag:i];
        [self.mMarkBtnView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.left.equalTo(self.mMarkBtnView.mas_left);
            }else{
                make.left.equalTo(oldMakr.mas_right).with.offset(0);
            }
            make.top.mas_equalTo(0);
            make.height.width.mas_equalTo(40);
        }];
        [_mMarkBtns addObject:markBtn];
        oldMakr = markBtn;
    }
    
}


@end
