//
//  NSString+MD5.m
//  QCRoadRescue
//
//  Created by 刘冬 on 15/7/22.
//  Copyright (c) 2015年 刘冬. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)
#pragma mark MD5加密
- (NSString *)MD5
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}
@end
