//
//  MyFounctions.m
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "MyFounctions.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static NSBundle *bundle = nil;

@implementation MyFounctions
#pragma mark 注册通知权限
+(void)registerNotificationCompetence{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}
+(void)registerLocationPermissions:(CLLocationManager *)locationMangae{
    // 判断是否 iOS 8
    if([locationMangae respondsToSelector:@selector(requestAlwaysAuthorization)]) {
         [locationMangae requestAlwaysAuthorization]; // 永久授权
        [locationMangae requestWhenInUseAuthorization]; //使用中授权
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [locationMangae requestWhenInUseAuthorization];//?只在前台开启定位
        [locationMangae requestAlwaysAuthorization];//?在后台也可定位
    }
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//            locationMangae.allowsBackgroundLocationUpdates = YES;
//        }
    
    [locationMangae startUpdatingLocation];
}
#pragma mark md5
+(NSString *)md5:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

#pragma mark ---------- base64
+(NSString *)encodeToBase64String:(UIImage *)image
{
    NSString *baseStr = [UIImageJPEGRepresentation(image,1) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //remove special char
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                         (CFStringRef)baseStr,
                                                                                         NULL,
                                                                                         CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                         kCFStringEncodingUTF8);
    return baseString;
}
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = (char *)malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

#pragma mark date


+(NSString*)getTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

+(NSString *)getCurrentDate{

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *fixString = [dateFormatter stringFromDate:[NSDate date]];
    
    return fixString;
}
+(NSString *)getCurrentDateWithDateFormatter:(NSString *)dateFormatter{
    
    NSDateFormatter* mDateFormatter = [[NSDateFormatter alloc]init];
    [mDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [mDateFormatter setDateFormat:dateFormatter];
    NSString *fixString = [mDateFormatter stringFromDate:[NSDate date]];
    
    return fixString;
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+(NSInteger)getCurrentDateMonth//get calender month
{
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    //    NSInteger day=[conponent day];
    //    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    return month;
}
+(NSInteger)getCurrentDateDay//get calender day
{
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    //    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    //    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    return day;
}
+(NSInteger)getCurrentDateWeekday
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    return weekday;
}
+(NSInteger)getCurrentDateWeekdayWithSeperateDays:(NSInteger)days
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:days*60*60*24];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    return weekday;
}
+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSString *)stringFromDate:(NSDate *)date dateFormatterStr:(NSString *)dateFormatterStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:dateFormatterStr];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
#pragma mark color
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
#pragma mark userInfo
+(NSMutableDictionary*)getUserDetailInfo
{
    NSArray* array = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
    NSString* savePath = [NSString stringWithFormat:@"%@/detailuser",[array objectAtIndex: 0]];
    NSMutableDictionary *user= [[NSKeyedUnarchiver unarchiveObjectWithFile:savePath] objectAtIndex:0];
    return user;
}
+(NSMutableDictionary*)getUserInfo
{
    NSArray* array = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
    NSString* savePath = [NSString stringWithFormat:@"%@/user",[array objectAtIndex: 0]];
    NSMutableDictionary *user= [[NSKeyedUnarchiver unarchiveObjectWithFile:savePath] objectAtIndex:0];
    return user;
}

+(void)saveDetailUserInfo:(NSMutableDictionary *)user
{
    NSArray* array = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
    NSString* savePath = [NSString stringWithFormat:@"%@/detailuser",[array objectAtIndex: 0]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    [NSKeyedArchiver archiveRootObject:[NSArray arrayWithObject:user] toFile:savePath];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUser" object:nil userInfo:nil];
}
+(void)saveUserInfo:(NSMutableDictionary *)user
{
    NSArray* array = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
    NSString* savePath = [NSString stringWithFormat:@"%@/user",[array objectAtIndex: 0]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    [NSKeyedArchiver archiveRootObject:[NSArray arrayWithObject:user] toFile:savePath];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUser" object:nil userInfo:nil];
}
+(void)removeUserDetailInfo
{
    NSArray* array = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
    NSString* savePath = [NSString stringWithFormat:@"%@/detailuser",[array objectAtIndex: 0]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/portrait",[NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES ) objectAtIndex: 0]]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/portrait",[NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES ) objectAtIndex: 0]] error:nil];
    }
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUser" object:nil userInfo:nil];
}
+(void)removeUserInfo
{
    NSArray* array = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
    NSString* savePath = [NSString stringWithFormat:@"%@/user",[array objectAtIndex: 0]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/portrait",[NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES ) objectAtIndex: 0]]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/portrait",[NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES ) objectAtIndex: 0]] error:nil];
    }
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUser" object:nil userInfo:nil];
}

+(void)startTime:(UIButton *)sender{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
        }else{
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                [sender setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                sender.titleLabel.font = [UIFont systemFontOfSize: 10.0];
                sender.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


+ ( NSBundle * )bundle{
    
    return bundle;
    
}
+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *string = [def valueForKey:@"userLanguage"];
    
    if(string.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        
        NSString *current = [languages objectAtIndex:0];
        
        string = current;
        
        [def setValue:current forKey:@"userLanguage"];
        
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}
+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    
    [def synchronize];
}

+(void)callPhone:(NSString *)phoneStr{
    if (phoneStr && phoneStr.length>0) {
        NSString *temp = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
        NSURL *url = [NSURL URLWithString:temp];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

//指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSData *)imageData:(UIImage *)myimage

{
    
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    
    if (data.length>100*1024) {
        
        if (data.length>1024*1024) {//1M以及以上
            
            data=UIImageJPEGRepresentation(myimage, 0.1);
            
        }else if (data.length>512*1024) {//0.5M-1M
            
            data=UIImageJPEGRepresentation(myimage, 0.5);
            
        }else if (data.length>200*1024) {//0.25M-0.5M
            
            data=UIImageJPEGRepresentation(myimage, 0.9);
            
        }
        
    }
    
    return data;
    
}
@end
