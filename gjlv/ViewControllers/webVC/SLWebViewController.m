//
//  SLWebViewController.m
//  wxsl
//
//  Created by 刘冬 on 16/8/19.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWebViewController.h"

@interface SLWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;

@end

@implementation SLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"活动";
    
    NSURLRequest *mRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlStr]];
    self.mWebView.delegate = self;
    [self.mWebView loadRequest:mRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    NSString *title  = [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
