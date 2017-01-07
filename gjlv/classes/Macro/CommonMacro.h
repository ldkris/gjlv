//
//  Header.h
//  
//
//  Created by ZhaoFucheng on 15/1/3.
//  Copyright (c) 2015年 . All rights reserved.
//
/**************************************************
 * 内容描述: 公共宏命令
 * 创 建 人: 刘冬
 * 创建日期: 2015-01-03
 **************************************************/

#ifndef ____Header_h
#define ____Header_h

/***************常用路径**************/
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/***************常用尺寸**************/
#define MainScreenFrame         [[UIScreen mainScreen] bounds]
#define MainScreenFrame_Width   MainScreenFrame.size.width
#define MainScreenFrame_Height  MainScreenFrame.size.height
#define UI_NAVIGATION_BAR_HEIGHT    44.0f
#define UI_TAB_BAR_HEIGHT           49.0f
#define UI_STATUS_BAR_HEIGHT        20.0f

/***************常用字体**************/
#define DEFAULT_FONT(s) [UIFont fontWithName:@"Arial" size:s]
#define DEFAULT_BOLD_FONT(s) [UIFont fontWithName:@"Arial-BoldMT" size:s]
#define DEFAULT_HelveticaBOLD_FONT(s) [UIFont fontWithName:@"Helvetica-Bold" size:s]
/***************常用颜色**************/
#define COLOR_CLEAR [UIColor clearColor]
#define COLOR_GRAY  [UIColor grayColor]
#define COLOR_WHITE [UIColor whiteColor]
#define COLOR_BLACK [UIColor blackColor]
#define COLOR_RED   [UIColor redColor]
#define COLOR_LOW_GRAY [PanliHelper colorWithHexString:@"#5d5d5d"]
#define COLOR_NAVBAR_TITLE [PanliHelper colorWithHexString:@"#4B4B4B"]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/***************系统版本检测**************/
//ios7以后
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

/**
 *判断是否大于等于ios7
 */
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
/**
 *判断是否大于等于ios8
 */
#define IS_IOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
/*
 *获取系统版本号
 */
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
/*
 *判断系统版本是否与v相等
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
/*
 *判断系统版本是否大于v
 */
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
/*
 *判断系统版本是否大于等于v
 */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
/*
 *判断系统版本是否小于v
 */
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/*
 *判断系统版本是否小于等于v
 */
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/***************设备检测**************/
//是iPad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//是iPhoneOriTouch
#define isIPhoneOrITouch ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

/***************APP**************/
/**
 *  APP名字
 */
#define APPName     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
/**
 *  APP版本
 */
#define APPVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/**
 *  APPBundleVersion
 */
#define APPBundleVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/**
 *环境配置开关,发布时请注释此宏
 */
#define DEBUG_FLAG

#ifdef DEBUG_FLAG
/***************开发环境*******************/
#define LDLOG(...)           NSLog(__VA_ARGS__)

#else
/***************正式环境*******************/
#define LDLOG(...)

#endif

#endif

#define ShowMSG(msg) [[[UIAlertView alloc]initWithTitle:APPName message:(msg) delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil]show]

#define HttpApi  [SLNetWorkingHelper shareNetWork]

#define lA_CHINESE @"zh-Hans"
#define lA_ENGLISH @"en"
#define LDLocalizedString(key) [[MyFounctions bundle] localizedStringForKey:(key) value:nil table:nil]

#define BG_Yellow       RGBACOLOR(223, 185, 106, 1)
#define SL_GRAY         RGBACOLOR(240, 240, 240, 1)
#define SL_GRAY_Hard    RGBACOLOR(102, 102, 102, 1)
#define SL_GRAY_BLACK   RGBACOLOR(51, 51, 51, 1)

#define SLImgaeNmane(imageName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]]

#define ZJ_UserID [MyFounctions getUserInfo][@"userId"]
#define HttpApi  [ZJNetWorkingHelper shareNetWork]
#define isTest  0
