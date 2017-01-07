//
//  UIColor+HexString.h
//  FCFinancial
//
//  Created by 刘冬 on 15/11/6.
//  Copyright © 2015年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
