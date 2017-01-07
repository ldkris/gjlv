//
//  BaseNavigationgVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseNavigationgVC.h"

@interface BaseNavigationgVC ()

@end

@implementation BaseNavigationgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setBarTintColor:RGBACOLOR(223, 185, 106, 1)];
    self.navigationBar.translucent = NO;
    //标题颜色
    [self.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    viewController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
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
