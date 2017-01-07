//
//  ZJCustomRouteVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCustomRouteVC.h"
#import "RouteAnnotation.h"
#import "ZJCustomRouteCell.h"
#import "ZJCustomRouteCell1.h"
#import "ZJCustomRouteView.h"
#import "GuideView.h"
#import "ZJSelectPointVC.h"
#import "YTAnimation.h"
#import "ZJCheckRouteVC.h"
#import "ZJOptimumRouteVC.h"
@interface ZJCustomRouteVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property (weak, nonatomic) IBOutlet UIView *mBarView;
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;
@property (nonatomic, assign) CGPoint lastPressPoint;

@property(nonatomic,assign)int dis;
@end

@implementation ZJCustomRouteVC{

    IBOutlet BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
    ZJCustomRouteView *_mPointInfoView;
    GuideView *markView;
    
    NSMutableArray *_mTypeArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"自定义线路";
    _mTypeArrays = [NSMutableArray array];
    
    _lastPressPoint = CGPointZero;
    self.dis = 0;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [mBarBgView setFrame:CGRectMake(0, 0, MainScreenFrame_Width, 100)];

    [self.mInfoCollectionView setBackgroundView:mBarBgView];
    [self.mInfoCollectionView setBackgroundColor:[UIColor clearColor]];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
    [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
    [mRightBtn addTarget:self action:@selector(onclickRight:) forControlEvents:UIControlEventTouchUpInside];
    [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mRightBtn setTitle:@"确定" forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:mRightBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    if (self.mSysemRouteLines && self.mSysemRouteLines.count>0) {
        [self.mADDRoutesPoint removeAllObjects];
        ZJMyRoteModel *model = self.mSysemRouteLines[0];
        [self.mADDRoutesPoint addObjectsFromArray:model.mafters];
        [_mTypeArrays addObject:@"1"];
        [self.mInfoCollectionView reloadData];
    }
    
    [self loadMapLine];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        markView = [[GuideView alloc]initWithFrame:self.navigationController.view.bounds];
        markView.fullShow = YES;
        markView.markText = @"长按卡牌可移动排序";
        markView.model = GuideViewCleanModeRoundRect;
        markView.showRect = CGRectMake(13,MainScreenFrame_Height - 50 - 10, 90, 50);
        [self.navigationController.view addSubview:markView];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate =(id)self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    if (_routesearch) {
        _routesearch = nil;
    }
}
#pragma mark  getter
-(NSMutableArray *)mADDRoutesPoint{
    if (_mADDRoutesPoint == nil) {
        _mADDRoutesPoint = [NSMutableArray array];
    }
    return _mADDRoutesPoint;
}
-(NSArray *)mSysemRouteLines{
    if (_mSysemRouteLines == nil) {
        _mSysemRouteLines = @[];
    }
    return _mSysemRouteLines;
}

- (NSMutableArray *)cellAttributesArray{
    if (!_cellAttributesArray) {
        _cellAttributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellAttributesArray;
}
#pragma mark private
-(void)loadMapLine{
    BMKPlanNode* start;
    BMKPlanNode* end;
    NSMutableArray *wayPointsArray = [NSMutableArray array];
    for (int i = 0; i < self.mADDRoutesPoint.count; i++) {
        BMKPoiInfo *model = self.mADDRoutesPoint[i];
        if ([model isKindOfClass:[BMKPoiInfo class]]) {
            if (i == 0) {
                start = [[BMKPlanNode alloc]init];
                start.pt =  model.pt;
            }else if (i == self.mADDRoutesPoint.count - 1) {
                end = [[BMKPlanNode alloc]init];
                end.pt =  model.pt;
            }else{
                BMKPlanNode *tempNode = [[BMKPlanNode alloc]init];
                tempNode.name = model.city;
                tempNode.pt = model.pt;
                [wayPointsArray addObject:tempNode];
            }
        }else{
            NSDictionary *info = (NSDictionary *)model;
            NSError *error;
            ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:info error:&error];
            if (!error) {
                if (i == 0) {
                    start = [[BMKPlanNode alloc]init];
                    NSString * starLat = [NSString stringWithFormat:@"%@",model.mlat];
                    NSString * starLng =  [NSString stringWithFormat:@"%@",model.mlng];;
                    CLLocationCoordinate2D starCoor  =  CLLocationCoordinate2DMake([starLat floatValue],[starLng floatValue]) ;
                    start.pt = starCoor;
                }else if (i == self.mADDRoutesPoint.count - 1) {
                    end = [[BMKPlanNode alloc]init];
                    NSString * endLat = [NSString stringWithFormat:@"%@",model.mlat];
                    NSString * endLng =  [NSString stringWithFormat:@"%@",model.mlng];;
                    CLLocationCoordinate2D endCoor  =  CLLocationCoordinate2DMake([endLat floatValue],[endLng floatValue]) ;
                    end.pt = endCoor;
                }else{
                    NSString * Lat = [NSString stringWithFormat:@"%@",model.mlat];
                    NSString * Lng =  [NSString stringWithFormat:@"%@",model.mlng];;
                    BMKPlanNode *tempNode = [[BMKPlanNode alloc]init];
                    tempNode.name = model.maname;
                    tempNode.pt = CLLocationCoordinate2DMake([Lat floatValue],[Lng floatValue]);
                    [wayPointsArray addObject:tempNode];
                }
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
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{
    NSMutableDictionary *mParam = [NSMutableDictionary dictionary];
    [mParam setValue:ZJ_UserID forKey:@"userId"];
    
    NSMutableDictionary *routeDic = [NSMutableDictionary dictionary];
    [routeDic setValue:[self.title stringByReplacingOccurrencesOfString:@"-" withString:@"到"] forKey:@"rname"];
    
    NSMutableArray *afters = [NSMutableArray array];
    for (int i = 0; i < self.mADDRoutesPoint.count; i++) {
        NSMutableDictionary *afterDic = [NSMutableDictionary dictionary];
        
        BMKPoiInfo *model = self.mADDRoutesPoint[i];
        if ([model isKindOfClass:[BMKPoiInfo class]]) {
            [afterDic setObject:model.city forKey:@"aname"];
            [afterDic setObject:[NSString stringWithFormat:@"%f",model.pt.latitude] forKey:@"lat"];
            [afterDic setObject:[NSString stringWithFormat:@"%f",model.pt.longitude] forKey:@"lng"];
            [afterDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"sortNo"];
            if (_mTypeArrays && _mTypeArrays.count>0) {
                 [afterDic setObject:_mTypeArrays[i] forKey:@"type"];
            }
           
        }else{
            NSDictionary *model1 = (NSDictionary *)model;
            [afterDic setObject:model1[@"aname"] forKey:@"aname"];
            NSString * Lat = [NSString stringWithFormat:@"%@",model1[@"lat"]];
            NSString * Lng =  [NSString stringWithFormat:@"%@",model1[@"lng"]];;
            [afterDic setObject:Lat forKey:@"lat"];
            [afterDic setObject:Lng forKey:@"lng"];
            [afterDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"sortNo"];
            [afterDic setObject:model1[@"type"] forKey:@"type"];
           
        }
        
        [afters addObject:afterDic];
        
    }
    [routeDic setObject:afters forKey:@"afters"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:routeDic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [mParam setObject:jsonString forKey:@"route"];
    
    
    [HttpApi putRoute:mParam SuccessBlock:^(id responseBody) {
        
        NSString *mRid = [NSString stringWithFormat:@"%@",responseBody[@"urId"]];
        if (mRid && mRid.length>0 ) {
            ZJOptimumRouteVC *tempVC = [[ZJOptimumRouteVC alloc]init];
            tempVC.mADDRoutesPoint = self.mADDRoutesPoint;
            tempVC.mSysemRouteLines = self.mSysemRouteLines;
            tempVC.mRid = mRid;
            tempVC.title = self.title;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    } FailureBlock:^(NSError *error) {
        
    }];

}
-(void)onclickMenuBtn:(UIButton *)sender{
    ZJCustomRouteVC *tempVC = [[ZJCustomRouteVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (void)longPressGesture:(UILongPressGestureRecognizer *)sender{
    
    for (id tempCell in [self.mInfoCollectionView visibleCells]) {
        if ([tempCell isKindOfClass:[ ZJCustomRouteCell1 class]]) {
            [YTAnimation vibrateAnimation:(ZJCustomRouteCell1 *)tempCell];
        }
    }
    
    ZJCustomRouteCell1 *cell = (ZJCustomRouteCell1 *)sender.view;
    NSIndexPath *cellIndexPath = [self.mInfoCollectionView indexPathForCell:cell];
    [self.mInfoCollectionView bringSubviewToFront:cell];
    BOOL isChanged = NO;
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.cellAttributesArray removeAllObjects];
        for (int i = 0;i< self.mADDRoutesPoint.count; i++) {
            [self.cellAttributesArray addObject:[self.mInfoCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
        }
        self.lastPressPoint = [sender locationInView:self.mInfoCollectionView];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        cell.center = [sender locationInView:self.mInfoCollectionView];
        for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
            if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexPath != attributes.indexPath) {
                isChanged = YES;
                //对数组中存放的元素重新排序
                NSString *imageStr = self.mADDRoutesPoint[cellIndexPath.row];
                [self.mADDRoutesPoint removeObjectAtIndex:cellIndexPath.row];
                [self.mADDRoutesPoint insertObject:imageStr atIndex:attributes.indexPath.row];
                [self.mInfoCollectionView moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
            }
        }
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (!isChanged) {
            cell.center = [self.mInfoCollectionView layoutAttributesForItemAtIndexPath:cellIndexPath].center;
        }
        for (id tempCell in [self.mInfoCollectionView visibleCells]) {
            if ([tempCell isKindOfClass:[ ZJCustomRouteCell1 class]]) {
                ZJCustomRouteCell1 *cell = (ZJCustomRouteCell1*)tempCell;
                [cell.layer removeAnimationForKey:@"shake"];
            }
        }
        
        NSLog(@"排序后---%@",self.mADDRoutesPoint);
        
        [self loadMapLine];
    }
}
#pragma mark BMKAnnotationViewSearchDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}
#pragma mark BMKOverlayViewSearchDelegate
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
#pragma mark BMKOverlayView BMKRouteSearchDelegate
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
            //            item.type = 4;
            //            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
            self.dis += transitStep.distance;
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
#pragma mark UICollectionViewDataSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mADDRoutesPoint.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return CGSizeMake(95, 50);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mADDRoutesPoint.count) {
        static NSString * SLCellIdentifier = @"ZJCustomRouteCell";
        
        [collectionView registerNib:[UINib nibWithNibName:@"ZJCustomRouteCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJCustomRouteCell"];
        
        ZJCustomRouteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
        
        
        return cell;
    }
    
    static NSString * SLCellIdentifier = @"ZJCustomRouteCell1";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJCustomRouteCell1" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJCustomRouteCell1"];
    
    ZJCustomRouteCell1 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    id tempModel  = self.mADDRoutesPoint[indexPath.row];
    if ([tempModel isKindOfClass:[BMKPoiInfo class]]) {
        BMKPoiInfo *model = tempModel;
        cell.mlab_title.text =model.city;
    }else{
        NSError *error;
        ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:tempModel error:&error];
        if (!error) {
            cell.mlab_title.text =model.maname;
            
            if ([model.mtype integerValue] == 2) {
                cell.mlab_mark.text = @"返";
                cell.mIMG_mark.image = [UIImage imageNamed:@"c_cf"];
            }else{
                cell.mlab_mark.text = @"去";
                cell.mIMG_mark.image = [UIImage imageNamed:@"c_ff.png"];
            }
        }
    }


    
    if (indexPath.row !=0 || indexPath.row != self.mADDRoutesPoint.count-2) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [cell addGestureRecognizer:longPress];
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mADDRoutesPoint.count) {
        ZJSelectPointVC *mtempVC = [[ZJSelectPointVC alloc]init];
        [mtempVC backInfoBlock:^(id info) {
            [self.mADDRoutesPoint insertObject:info atIndex:indexPath.row];
            [self.mInfoCollectionView reloadData];
            [self loadMapLine];
        }];
        [self.navigationController pushViewController:mtempVC animated:YES];
        return;
    }
    
    
    if (_mPointInfoView ==nil) {
        _mPointInfoView = [[NSBundle mainBundle]loadNibNamed:@"ZJCustomRouteView" owner:nil options:nil][0];
    }
    
    id temp = self.mADDRoutesPoint[indexPath.row];
    if ([temp isKindOfClass:[BMKPoiInfo class]]) {
        BMKPoiInfo *model = temp;
        _mPointInfoView.mLab_title.text =model.city;
    }else{
        NSError *error;
        ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:temp error:&error];
        if (!error) {
            _mPointInfoView.mLab_title.text = model.maname;
           _mPointInfoView.mtype = [model.mtype integerValue];
            if ( _mPointInfoView.mtype == 0) {
                _mPointInfoView.mtype = 1;
            }
            if (_mPointInfoView.mtype == 2) {
                 [_mPointInfoView.btn_gb setImage:[UIImage imageNamed:@"r_gbb.png"] forState:UIControlStateNormal];
            }else{
                 [_mPointInfoView.btn_gb setImage:[UIImage imageNamed:@"r_gb.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    [_mPointInfoView onclickChangeBlock:^(UIButton *sender) {
        [_mPointInfoView removeFromSuperview];
        ZJCustomRouteCell1 * cell = (ZJCustomRouteCell1 *)[self.mInfoCollectionView cellForItemAtIndexPath:indexPath];
        if (sender.tag == 2) {
            cell.mlab_mark.text = @"返";
            cell.mIMG_mark.image = [UIImage imageNamed:@"c_cf"];
        }else{
            cell.mlab_mark.text = @"去";
            cell.mIMG_mark.image = [UIImage imageNamed:@"c_ff.png"];
        }
        id temp = self.mADDRoutesPoint[indexPath.row];
        if ([temp isKindOfClass:[BMKPoiInfo class]]) {
            [_mTypeArrays replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        }else{
            NSError *error;
            ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:temp error:&error];
            if (!error) {
                model.mtype = [NSNumber numberWithInteger:sender.tag];
            }
        }
       
    }];
    [_mPointInfoView onclickCheckBlock:^{
        [_mPointInfoView removeFromSuperview];
    }];
    [_mPointInfoView onclickDeleBlock:^{
        [_mPointInfoView removeFromSuperview];
        [self.mADDRoutesPoint removeObjectAtIndex:indexPath.row];
        [self.mInfoCollectionView reloadData];
        [self loadMapLine];
    }];
    [self.navigationController.view addSubview:_mPointInfoView];
    [_mPointInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
