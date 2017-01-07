//
//  ZJFoodCell3Cell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodCell3Cell.h"
#import "RouteAnnotation.h"
@implementation ZJFoodCell3Cell{
   IBOutlet BMKMapView* _mapView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _mapView.delegate = (id)self;
    [_mapView setZoomLevel:15];
   
}
- (IBAction)onlickNviBtn:(id)sender {
    if (self.naviBlock) {
        self.naviBlock(sender);
    }
}
-(void)onclickNavigationgBlock:(void(^)(UIButton *sender))block{
    self.naviBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}
-(void)loadlocWithlonlat:(CLLocationCoordinate2D )coor{
    _mapView.delegate = (id)self;
    [_mapView removeAnnotations:[_mapView annotations]];
    [_mapView setCenterCoordinate:coor];
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = coor;
    item.type = 4;
    [_mapView addAnnotation:item]; // 添加起点标注

}
-(void)cellSetMapDelagete{
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_mapView viewWillAppear];
}
-(void)unCellSetMapDelagete{
    _mapView.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_mapView viewWillDisappear];
}

-(void)mapViewDelloc{
    if (_mapView) {
        _mapView = nil;
    }
}
-(void)dealloc{
    if (_mapView) {
        _mapView = nil;
    }
}
@end
