//
//  BaseViewController.h
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void)hideZJTbar;
-(void)unHideZJTbar;
- (void)keyboardWillShow:(NSNotification *) notification;
- (void)keyboardWillHide:(NSNotification *) notification;
    
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,assign)NSInteger pageSize;
 
@end
