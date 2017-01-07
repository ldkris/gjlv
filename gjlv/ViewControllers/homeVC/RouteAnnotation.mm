//
//  RouteAnnotation.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/8/31.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

- ( UIImage *)createShareImage:(NSString *)str

{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    
    UIImage *image = [UIImage imageNamed:@"m_textBG" ];
    CGSize size= CGSizeMake (textSize.width + 12, textSize.height);
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathFill );
    // 画 打败了多少用户
    [str drawAtPoint : CGPointMake (10, 0) withAttributes : @{ NSFontAttributeName :DEFAULT_FONT(15), NSForegroundColorAttributeName :[ UIColor whiteColor] } ];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview
{
    BMKAnnotationView* view = nil;
    switch (_type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            view.canShowCallout = NO;
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"icon_start.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            view.canShowCallout = NO;
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"icon_end.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
               view.canShowCallout = NO;
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_bus.png"];
            }
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_rail.png"];
            }
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"route_node"];
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"pin_ad.png"];
            view.image = [image imageRotatedByDegrees:_degree];
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"waypoint_node"];
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [self createShareImage:self.title];
            view.image = [image imageRotatedByDegrees:_degree];
            [view setCenterOffset:CGPointMake(view.image.size.width/4 - 5, 0)];
        }
            break;
            
        case 6:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"stairs_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"stairs_node"];
            }
            view.image = [UIImage imageNamed:@"icon_stairs.png"];
        }
            break;
            
        case 7:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"t_yd"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"t_yd"];
            }
            view.image = [UIImage imageNamed:@"map_t_yd.png"];
        }
            break;
        case 8:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"map_t_ch"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"map_t_ch"];
            }
            view.image = [UIImage imageNamed:@"map_t_ch.png"];
        }
            break;
        case 9:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"map_t_fl"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"map_t_fl"];
            }
            view.image = [UIImage imageNamed:@"map_t_fl.png"];
        }
            break;
        case 10:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"map_t_sg"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"map_t_sg"];
            }
            view.image = [UIImage imageNamed:@"map_t_sg.png"];
        }
            break;
        case 11:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"map_t_js"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"map_t_js"];
            }
            view.image = [UIImage imageNamed:@"map_t_js.png"];
        }
            break;
        case 12:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"map_t_gz"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"map_t_gz"];
            }
            view.image = [UIImage imageNamed:@"map_t_gz.png"];
        }
            break;
        default:
            break;
    }
    
    if (view) {
        view.annotation = self;
        view.canShowCallout = NO;
    }
    return view;
}

@end
