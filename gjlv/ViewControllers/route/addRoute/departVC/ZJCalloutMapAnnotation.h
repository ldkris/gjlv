//
//  ZJCalloutMapAnnotation.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface ZJCalloutMapAnnotation : NSObject<BMKAnnotation>
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息
- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;
@property(retain,nonatomic) id temp;
@end
