//
//  ZJHomeMapCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJHomeMapCell.h"
#import "RouteAnnotation.h"
@interface ZJHomeMapCell(){

    IBOutlet BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
}
@property (weak, nonatomic) IBOutlet UIImageView *mImg_user;
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;

@end
@implementation ZJHomeMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mImg_user.layer setMasksToBounds:YES];
    [self.mlab_count.layer setMasksToBounds:YES];
    [self.mImg_user.layer setCornerRadius:16.0f];
    [self.mlab_count.layer setCornerRadius:16.0f];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.userInteractionEnabled = NO;
}
-(void)loadMapline:(ZJRouteModel *)model{
    
    if (model == nil || model.mafters == nil || model.mafters.count == 0) {
        return;
    }
    NSError *error;
    NSArray *tempAfters = [MTLJSONAdapter modelsOfClass:[ZJAfterModel class] fromJSONArray:model.mafters error:&error];
    if (!error && tempAfters.count>=2) {
        BMKPlanNode* start;
        BMKPlanNode* end;
        NSMutableArray *wayPointsArray = [NSMutableArray array];
        for (int i = 0; i < tempAfters.count; i++) {
            ZJAfterModel *info = tempAfters[i];
            if (i == 0) {
                NSString * starLat = [NSString stringWithFormat:@"%@",info.mlat];
                NSString * starLng =  [NSString stringWithFormat:@"%@",info.mlng];;
                CLLocationCoordinate2D starCoor  =  CLLocationCoordinate2DMake([starLat floatValue],[starLng floatValue]) ;
                start = [[BMKPlanNode alloc]init];
                start.pt =  starCoor;
            }else if (i == tempAfters.count - 1) {
                NSString * endLat = [NSString stringWithFormat:@"%@",info.mlat];
                NSString * endLng =  [NSString stringWithFormat:@"%@",info.mlng];;
                CLLocationCoordinate2D endCoor  =  CLLocationCoordinate2DMake([endLat floatValue],[endLng floatValue]) ;
                end = [[BMKPlanNode alloc]init];
                end.pt =  endCoor;
            }else{
                NSString * Lat = [NSString stringWithFormat:@"%@",info.mlat];
                NSString * Lng =  [NSString stringWithFormat:@"%@",info.mlng];;
                BMKPlanNode *tempNode = [[BMKPlanNode alloc]init];
                tempNode.name = info.maname;
                tempNode.pt = CLLocationCoordinate2DMake([Lat floatValue],[Lng floatValue]);
                [wayPointsArray addObject:tempNode];
            }
        }
        
        if (start && end) {
            BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
            drivingRouteSearchOption.from = start;
            drivingRouteSearchOption.to = end;
            drivingRouteSearchOption.wayPointsArray = wayPointsArray;
            BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
            if (flag) {
                LDLOG(@"yes");
            }else{
                LDLOG(@"no");
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.5;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [RGBACOLOR(195, 84, 91, 1) colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }
            
            //添加annotation节点
//            RouteAnnotation* item = [[RouteAnnotation alloc]init];
//            item.coordinate = transitStep.entrace.location;
//            item.title = transitStep.entraceInstruction;
//            item.degree = transitStep.direction * 30;
////            item.type = 5;
//            [_mapView addAnnotation:item];

            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

-(void)cellSetMapDelagete{
    [_mapView viewWillAppear];
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)unCellSetMapDelagete{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)mapViewDelloc{
    if (_routesearch) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
-(void)dealloc{
    if (_routesearch) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
@end
