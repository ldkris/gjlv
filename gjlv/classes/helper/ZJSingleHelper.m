//
//  ZJSingleHelper.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSingleHelper.h"

@implementation ZJSingleHelper
+(ZJSingleHelper *)shareNetWork{
    static ZJSingleHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ZJSingleHelper alloc]init];
    });
    return _sharedClient;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        //29.6049920000,106.5302320000
        _mUeserPt = CLLocationCoordinate2DMake(29.6049920000, 106.5302320000);
    }
    return self;
}
@end
