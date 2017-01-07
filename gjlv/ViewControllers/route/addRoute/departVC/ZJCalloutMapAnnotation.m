//
//  ZJCalloutMapAnnotation.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCalloutMapAnnotation.h"

@implementation ZJCalloutMapAnnotation
@synthesize latitude;
@synthesize longitude;
@synthesize locationInfo;
- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon
{
    if (self = [super init])
    {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}
-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}
@end
