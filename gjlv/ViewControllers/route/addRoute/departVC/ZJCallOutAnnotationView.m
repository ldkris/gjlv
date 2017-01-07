//
//  ZJCallOutAnnotationView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

#define Arror_height 6

@implementation ZJCallOutAnnotationView
@synthesize contentView;
@synthesize busInfoView;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{   self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -60);
        self.frame = CGRectMake(0, 0, 100, 65);
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}
-(void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context {
    CGRect rrect = self.bounds; CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect); CGFloat miny = CGRectGetMinY(rrect),
    //midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius); CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius); CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius); CGContextClosePath(context);
}

@end
