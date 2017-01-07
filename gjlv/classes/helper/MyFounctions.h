//
//  MyFounctions.h
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface MyFounctions : NSObject
/**
 *  注册统治权限
 */
+(void)registerNotificationCompetence;
/**
 *  或者定位权限
 *
 *  @param locationMangae locationMangae
 */
+(void)registerLocationPermissions:(CLLocationManager *)locationMangae;

#pragma mark md5
/**
 *  md5加密
 *
 *  @param str 加密的Str
 *
 */
+(NSString*)md5:(NSString *)str;


#pragma mark base 64
/**
 *  BASE64加密(图片)
 *
 *  @param image
 *
 */
+(NSString*)encodeToBase64String:(UIImage *)image;
/**
 *  Base64加密（文字）
 *
 *  @param text
 *
 */
+(NSString *)base64StringFromText:(NSString *)text;
/**
 *  Base64加密（data）
 *
 *  @param data
 *
 *  @return
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

#pragma mark ----------- date

+(NSString*)getTimeStamp;
/**
 *  获取当前时间
 *
 *  @return
 */
+(NSString *)getCurrentDate;
/**
 *  获取当前时间（时间格式）
 *
 *  @param dateFormatter 时间格式 如@"yyyy-MM-dd HH:mm:ss"
 *
 *  @return
 */
+(NSString *)getCurrentDateWithDateFormatter:(NSString *)dateFormatter;
/**
 *  获取当前月
 *
 *  @return
 */
+(NSInteger)getCurrentDateMonth;
/**
 *  获取当日
 *
 *  @return
 */
+(NSInteger)getCurrentDateDay;
/**
 *  获取当前周
 *
 *  @return
 */
+(NSInteger)getCurrentDateWeekday;
/**
 *  date 转成String YYYY-MM-DD
 *
 *  @param date
 *
 *  @return
 */
+ (NSString *)stringFromDate:(NSDate *)date;
/**
 *  date 转成String(根据时间格式)
 *
 *  @param date
 *  @param dateFormatterStr 如 YYYY-MM-DD
 *
 *  @return
 */
+ (NSString *)stringFromDate:(NSDate *)date dateFormatterStr:(NSString *)dateFormatterStr;

+(NSDate *)convertDateFromString:(NSString*)uiDate;
#pragma mark color
/**
 *  根据二进制字符串得到颜色
 *
 *  @param color 二进制颜色字符串
 *  @param alpha
 *
 *  @return
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
#pragma mark userInfo
/**
 *  获取用户信息
 *
 *  @return
 */
+(NSMutableDictionary*)getUserInfo;
+(NSMutableDictionary*)getUserDetailInfo;
/**
 *  保存用户信息
 *
 *  @param user
 */
+(void)saveUserInfo:(NSMutableDictionary *)user;

+(void)saveDetailUserInfo:(NSMutableDictionary *)user;
/**
 *  删除用户信息
 */
+(void)removeUserInfo;
+(void)removeUserDetailInfo;

/**
 *  验证码 倒计时
 *
 *  @param sender 
 */
+(void)startTime:(UIButton *)sender;

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

+(void)callPhone:(NSString *)phoneStr;

+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
