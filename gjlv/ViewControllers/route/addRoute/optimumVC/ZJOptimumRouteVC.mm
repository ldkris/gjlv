//
//  ZJOptimumRouteVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJOptimumRouteVC.h"
#import "ZJAMenuBtn.h"
#import "ZJCustomRouteVC.h"
#import "RouteAnnotation.h"
#import "ZJRComfirInfoView.h"
#import "ZJRACollectionViewCell.h"
#import "ZJRACollectionViewCell1.h"
#import "ZJCustomRouteVC.h"
#import "ZJSelectDateView.h"
#import "ZJRComfireViewCell1.h"
#import "ZJDepartVC.h"
#import "ZJGSelectLeaderVC.h"
@interface ZJOptimumRouteVC ()
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfir;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_select;
@property (weak, nonatomic) IBOutlet UIView *mBtnsView;
@end

@implementation ZJOptimumRouteVC{
    
    IBOutlet BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
  
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"重庆 - 丽江";

    [self.mBtn_comfir.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_comfir.layer setBorderWidth:0.5];
    
    [self.mBtn_select.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_select.layer setBorderWidth:0.5];
    
//    [self loadMenuBtns];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    if (self.mSysemRouteLines && self.mSysemRouteLines.count>0 && self.mADDRoutesPoint == nil) {
        ZJMyRoteModel *model = self.mSysemRouteLines[0];
        [self.mADDRoutesPoint addObjectsFromArray:model.mafters];
    }
    
    [self loadMapLine];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mSysemRouteLines{
    if (_mSysemRouteLines == nil) {
        _mSysemRouteLines = @[];
    }
    return _mSysemRouteLines;
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
-(void)loadMenuBtns{
    ZJAMenuBtn *mTJbtn = [[NSBundle mainBundle]loadNibNamed:@"ZJAMenuBtn" owner:nil options:nil][0];
    [mTJbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mTJbtn setTag:0];
    [mTJbtn setBackgroundColor:[UIColor whiteColor]];
    [self.mBtnsView addSubview:mTJbtn];
    [mTJbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(MainScreenFrame_Width/3);
    }];
    
    ZJAMenuBtn *mYTJbtn = [[NSBundle mainBundle]loadNibNamed:@"ZJAMenuBtn" owner:nil options:nil][0];
    [mYTJbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mYTJbtn setTag:1];
    [mYTJbtn setBackgroundColor:[UIColor whiteColor]];
    [self.mBtnsView addSubview:mYTJbtn];
    [mYTJbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(mTJbtn.mas_right).with.offset(1);
        make.width.mas_offset(MainScreenFrame_Width/3);
    }];
    
    UIButton *mZDYbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mZDYbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mZDYbtn setTag:2];
    [mZDYbtn setTitle:@"我要自定义路线" forState:UIControlStateNormal];
    [mZDYbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mZDYbtn setBackgroundColor:[UIColor whiteColor]];
    [mZDYbtn.titleLabel setFont:DEFAULT_FONT(13)];
    [self.mBtnsView addSubview:mZDYbtn];
    [mZDYbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(mYTJbtn.mas_right).with.offset(1);
        make.width.mas_offset(MainScreenFrame_Width/3);
    }];
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
- (IBAction)onclickSelectBtn:(id)sender {
    
     ZJGSelectLeaderVC *tempVC = [[ZJGSelectLeaderVC alloc]init];
    [tempVC BackInfoWithBlock:^(ZJLeaderDetailModel *leadInfo) {
        NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"urId":self.mRid,@"leaderId":[leadInfo.mleaderId stringValue]};
        [HttpApi bindLeaderd:mParamDic SuccessBlock:^(id responseBody) {
            [SVProgressHUD showSuccessWithStatus:@"选择领队成功"];
        } FailureBlock:^(NSError *error) {
            
        }];
    }];
//    ZJDepartVC *tempVC = [[ZJDepartVC alloc]init];
//    tempVC.mADDRoutesPoint = self.mADDRoutesPoint;
//    tempVC.mSysemRouteLines = self.mSysemRouteLines;
//    tempVC.mRid = self.mRid;
    [self.navigationController pushViewController:tempVC animated:YES];
}
-(void)onclickMenuBtn:(UIButton *)sender{
    ZJCustomRouteVC *tempVC = [[ZJCustomRouteVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickComfirBtn:(id)sender {
    
    ZJRComfirInfoView* _comfirView = [[NSBundle mainBundle]loadNibNamed:@"ZJRComfirInfoView" owner:nil options:nil][0];
    [self.navigationController.view addSubview:_comfirView];
    __weak typeof(self) weakself = self;
    [_comfirView onclickselectDateBlock:^(UIButton *sender) {
        ZJSelectDateView *tempView = [[NSBundle mainBundle]loadNibNamed:@"ZJSelectDateView" owner:nil options:nil][0];
        [_comfirView addSubview:tempView];
        [_comfirView bringSubviewToFront:tempView];
        [tempView onclickComfirBlock:^(NSString *sender) {
            [tempView removeFromSuperview];
            _comfirView.dateStr = sender;
            ZJRComfireViewCell1 *cell4 = [_comfirView.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell4.mLab_dateTitle.text = sender;
        }];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
    }];
    
    [_comfirView onclickComfirBlock:^(UIButton *sender) {
        NSMutableDictionary *mParam = [NSMutableDictionary dictionary];
        [mParam setValue:ZJ_UserID forKey:@"userId"];
        [mParam setValue:_comfirView.adultNum forKey:@"adultcount"];
        [mParam setValue:_comfirView.childNum forKey:@"childrencount"];
        [mParam setValue:_comfirView.carNum forKey:@"carcount"];
        [mParam setValue:_comfirView.dateStr forKey:@"beginDate"];
        if (self.mRid) {
             [mParam setValue:self.mRid forKey:@"urId"];
        }
        [HttpApi putTravelInfo:mParam SuccessBlock:^(id responseBody) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } FailureBlock:^(NSError *error) {
            
        }];
    }];
    [_comfirView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark UICollectionViewDataSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return self.mSysemRouteLines.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int CellW = collectionView.frame.size.width /(self.mSysemRouteLines.count + 1);
    
    return CGSizeMake(CellW ,80);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == self.mSysemRouteLines.count){
        static NSString * SLCellIdentifier = @"ZJRACollectionViewCell1";
        
        [collectionView registerNib:[UINib nibWithNibName:@"ZJRACollectionViewCell1" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJRACollectionViewCell1"];
        
        ZJRACollectionViewCell1 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    
    static NSString * SLCellIdentifier = @"ZJRACollectionViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJRACollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJRACollectionViewCell"];
    
    ZJRACollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.mBGView setBackgroundColor:cell.backgroundColor];
    }
    [cell loadCellDataWithModel:self.mSysemRouteLines[indexPath.row]];
    return cell;
}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mSysemRouteLines.count) {
        ZJCustomRouteVC *tempVC = [[ZJCustomRouteVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
        return;
    }
    
    for ( ZJRACollectionViewCell * cell in collectionView.visibleCells) {
        if([cell isKindOfClass:[ZJRACollectionViewCell class]]){
            NSIndexPath *tempPath = [collectionView indexPathForCell:cell];
            if (indexPath.row == tempPath.row) {
                [cell.mBGView setBackgroundColor:cell.backgroundColor];
            }else{
                [cell.mBGView setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
    
    [self.mADDRoutesPoint removeAllObjects];
    ZJMyRoteModel *model = self.mSysemRouteLines[indexPath.row];
    [self.mADDRoutesPoint addObjectsFromArray:model.mafters];
    [self loadMapLine];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
@end
