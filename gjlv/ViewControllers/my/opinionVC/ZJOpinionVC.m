//
//  ZJOpinionVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJOpinionVC.h"
#import "PlaceholderTextView.h"
@interface ZJOpinionVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_sub;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *tf_input;

@end

@implementation ZJOpinionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.btn_sub.layer.masksToBounds = YES;
    self.btn_sub.layer.cornerRadius = 5.0f;
    
    self.title = @"意见反馈";
    
    self.tf_input.placeholder = @"亲！来说点什么吧！我们将不断完善。。。";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView{
    
}
- (IBAction)onclickSubmitBtn:(id)sender {
    if (self.tf_input.text == nil || self.tf_input.text.length == 0) {
        ShowMSG(@"亲！来说点什么吧！我们将不断完善。。。");
    }
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"content":self.tf_input.text};
    [HttpApi putFeedback:mParaDic SuccessBlock:^(id responseBody) {
        [self.navigationController popViewControllerAnimated:YES];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

@end
