//
//  ZJMyFootMarkView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyFootMarkVC.h"
#import "RouteAnnotation.h"
@interface ZJMyFootMarkVC ()
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_gl;
@property (weak, nonatomic) IBOutlet UILabel *mlab_ranking;
@property (weak, nonatomic) IBOutlet BMKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_cgcy;
@end

@implementation ZJMyFootMarkVC{

    ZJFootMarkModel *_mFooterMakrModel;
    BMKRouteSearch* _routesearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mContentView.layer.masksToBounds = YES;
    self.mContentView.layer.cornerRadius = 3.0f;
    
    self.title = @"我的足迹";
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = (id)self;
    
    _mMapView.zoomLevel = 4.7;
    
    [self getFootprintList];
    
   

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mMapView viewWillAppear];
    self.mMapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mMapView viewWillDisappear];
    self.mMapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil;
    [self.mMapView removeAnnotations:self.mMapView.annotations];
}
- (void)dealloc {
    if (self.mMapView) {
        self.mMapView = nil;
    }
    if (_routesearch) {
        _routesearch = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark networking
-(void)getFootprintList{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID};
    [HttpApi getFootprintList:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        ZJFootMarkModel *temp = [MTLJSONAdapter modelOfClass:[ZJFootMarkModel class] fromJSONDictionary:responseBody error:&error];
        _mFooterMakrModel = temp;
        
        self.mlab_name.text = _mFooterMakrModel.mnickname;
        self.mlab_gl.text = [_mFooterMakrModel.mtotalMileage stringValue];
        self.mlab_cgcy.text = [[_mFooterMakrModel.mcgcy stringValue] stringByAppendingString:@"位"];
        self.mlab_ranking.text = [NSString stringWithFormat:@"第%@名",_mFooterMakrModel.mranking];
        
        [self drawMyLine];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark private
-(void)drawMyLine{
    if (_mFooterMakrModel == nil) {
        return;
    }
    BMKPlanNode* start;
    BMKPlanNode* end;
    NSMutableArray *wayPointsArray = [NSMutableArray array];
    for (NSDictionary *info in _mFooterMakrModel.mroutes) {
        NSArray *temp = info[@"afters"];
        if (temp && temp.count>=2) {
            NSString * starLat = [NSString stringWithFormat:@"%@",temp[0][@"lat"]];
            NSString * starLng =  [NSString stringWithFormat:@"%@",temp[0][@"lng"]];;
            CLLocationCoordinate2D starCoor  =  CLLocationCoordinate2DMake([starLat floatValue],[starLng floatValue]) ;
            start = [[BMKPlanNode alloc]init];
            start.pt =  starCoor;
            
            NSString * endLat = [NSString stringWithFormat:@"%@",[temp lastObject][@"lat"]];
            NSString * endLng =  [NSString stringWithFormat:@"%@",[temp lastObject][@"lng"]];;
            CLLocationCoordinate2D endCoor  =  CLLocationCoordinate2DMake([endLat floatValue],[endLng floatValue]) ;
            end = [[BMKPlanNode alloc]init];
            end.pt =  endCoor;
            
            for (NSDictionary *tempInfo in temp) {
                if (tempInfo != temp[0] && tempInfo != [temp lastObject]) {
                    NSString * Lat = [NSString stringWithFormat:@"%@",tempInfo[@"lat"]];
                    NSString * Lng =  [NSString stringWithFormat:@"%@",tempInfo[@"lng"]];;
                    BMKPlanNode *tempNode = [[BMKPlanNode alloc]init];
                        tempNode.pt = CLLocationCoordinate2DMake([Lat floatValue],[Lng floatValue]) ;
                    tempNode.cityName =  @"北京市";
                    [wayPointsArray addObject:tempNode];
                }
            }
            
        }
        

    }
    
    if (start && end) {
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        drivingRouteSearchOption.wayPointsArray = wayPointsArray;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    }
}
#pragma mark BMKAnnotationViewDelegate
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
    NSArray* array = [NSArray arrayWithArray:_mMapView.annotations];
    [_mMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mMapView.overlays];
    [_mMapView removeOverlays:array];
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
                [_mMapView addAnnotation:item]; // 添加起点标注
                
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mMapView addAnnotation:item]; // 添加起点标注
                
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
//        if (plan.wayPoints) {
//            for (BMKPlanNode* tempNode in plan.wayPoints) {
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item = [[RouteAnnotation alloc]init];
//                item.coordinate = tempNode.pt;
//                item.type = 5;
//                item.title = tempNode.name;
//                [_mMapView addAnnotation:item];
//            }
//        }
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
        [_mMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

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
//    [_mMapView setVisibleMapRect:rect];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
