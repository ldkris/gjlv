//
//  NSString+MD5.h
//  QCRoadRescue
//
//  Created by 刘冬 on 15/7/22.
//  Copyright (c) 2015年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (MD5)
/**
 * 功能描述: MD5加密
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)MD5;
@end
