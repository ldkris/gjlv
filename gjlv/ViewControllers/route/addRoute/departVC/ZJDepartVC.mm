//
//  ZJDepartVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/11.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDepartVC.h"
#import "RouteAnnotation.h"
#import "ZJPointAnnotation.h"
#import "ZJCalloutMapAnnotation.h"
#import "ZJCallOutAnnotationView.h"
#import "ZJPointCell.h"
#import "ZJDepartHeaderCell.h"
#import "ZJDepartCell.h"
#import "ZJDepartCell1.h"
#import "ZJChatVC.h"
#import "ZJLeaderDtialVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ZJPutInfoView.h"
#import "ZJGSelectLeaderVC.h"
#import "ZJSelectCarFirendView.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKAnnotation.h>
#import "trafficReportView.h"
#import "ZJSelectMapVC.h"
#import "ZJPutInfoView.h"
#import "ZJPutNeedInfoView.h"
#import "ZJASDetailVC.h"
#import "ZJTrafficDeatilVC.h"
@interface ZJDepartVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_head;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UIButton *mlab_status;
@property(nonatomic,retain)NSArray *mNearUsers;
@property (weak, nonatomic) IBOutlet UIButton *mbtn_res;

@property(nonatomic,retain)NSMutableArray *mNearLineCar;
@property(nonatomic,retain)NSMutableArray *mNearLineSec;
@property(nonatomic,retain)NSMutableArray *mNearLineTr;
@end

@implementation ZJDepartVC{
    IBOutlet BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKRouteSearch* _routesearch;
    __weak IBOutlet UIView *mNavView;
    bool mapCenter;
    bool _isSelectLeader;//是否选择了领队
    ZJLeaderDetailModel *_model;

    BMKGeoCodeSearch* _geocodesearch;

    NSString *userLoc;
    CLLocationCoordinate2D _location;
    
    NSMutableArray *_mNearAnn;
    NSMutableArray *_mLineAnn;
    NSMutableArray *_mLineSec;
    NSMutableArray *_mLineTr;
    
    trafficReportView *mTrView;
    NSString *photoName;
  // NSString *content;

}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mapCenter = NO;

    userLoc = @"";

   // [SVProgressHUD show];
    
    _mNearAnn = [NSMutableArray array];
    _mLineAnn = [NSMutableArray array];
    _mLineSec = [NSMutableArray array];
    _mLineTr = [NSMutableArray array];
    
    self.mimg_head.layer.masksToBounds = YES;
    self.mimg_head.layer.cornerRadius = 25.0f;
    
    _mapView.delegate = (id)self;
    //设置地图缩放级别
    [_mapView setZoomLevel:15];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = (id)self;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    _locService.distanceFilter = 1000;
    [_locService startUserLocationService];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor clearColor]];
    self.mInfoTableView.bounces = NO;
    
    [self loadNavBarViews];
    
    if (self.mMyRouteModel1)
    {
        //首页精选路线
        [self loadMapline:self.mMyRouteModel1.mafters];
        self.mInfoTableView.hidden = YES;
        return;
    }
    else
    {
        if (self.mMyRouteModel)
        {
            if ([self.mMyRouteModel.mstatus integerValue] ==1 ||[self.mMyRouteModel.mstatus integerValue] ==2) {
                self.mbtn_res.hidden = NO;
            }else{
                self.mbtn_res.hidden = YES;
            }
            
            if (self.mMyRouteModel.mleaderId)
            {
                _isSelectLeader = YES;
                [self getLeaderDetail];
            }
            else
            {
                _isSelectLeader = NO;
                [self getRecommendLeader];
            }
            
            if (self.mADDRoutesPoint == nil)
            {
                self.mADDRoutesPoint  = [NSMutableArray  arrayWithArray:self.mMyRouteModel.mafters];
            }
            [self loadMapline:self.mADDRoutesPoint];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    if (mTrView) {
        mTrView.hidden = NO;
        [mTrView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    
    if (self.mMyRouteModel1) {
        self.title = @"精选路线";
        self.navigationController.navigationBar.hidden = NO;
        mNavView.hidden = YES;
        self.mInfoTableView.hidden = YES;
        self.mbtn_res.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = YES;
        mNavView.hidden = NO;
        self.mInfoTableView.hidden = NO;
//        self.mbtn_res.hidden = NO;
    }
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = (id)self;
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = (id)self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
     self.navigationController.navigationBar.hidden = NO;
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _routesearch.delegate = nil;
    _geocodesearch.delegate= nil;
    if (mTrView) {
        mTrView.hidden = YES;
    }
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    if (_locService) {
        _locService = nil;
    }
    if (_routesearch) {
        _routesearch = nil;
    }
    if (_geocodesearch) {
        _geocodesearch = nil;
    }
}
#pragma mark getter
-(NSMutableArray *)mNearLineCar{
    if (_mNearLineCar == nil) {
        _mNearLineCar = [NSMutableArray array];
    }
    return _mNearLineCar;
}
-(NSArray *)mNearUsers{
    if (_mNearUsers == nil) {
        _mNearUsers = @[];
    }
    return _mNearUsers;
}
-(NSMutableArray *)mNearLineSec{
    if (_mNearLineSec==nil) {
        _mNearLineSec  = [NSMutableArray array];
    }
    return _mNearLineSec;
}
-(NSMutableArray *)mNearLineTr{
    if (_mNearLineTr==nil) {
        _mNearLineTr  = [NSMutableArray array];
    }
    return _mNearLineTr;
}
#pragma mark netWoring
-(void)getRecommendLeader{
    if (self.mMyRouteModel.mleaderId) {
        return;
    }
    NSString *URID = @"";
    if (self.mMyRouteModel) {
        URID =[self.mMyRouteModel.mrid stringValue];
    }
    if (self.mRid) {
        URID =self.mRid;
    }
    
    NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"urId":URID};
    [HttpApi getRecommendLeader:mParaDic SuccessBlock:^(id responseBody) {
        NSError *error;
        ZJLeaderDetailModel *temp = [MTLJSONAdapter modelOfClass:[ZJLeaderDetailModel class] fromJSONDictionary:responseBody error:&error];
        if (!error) {
            _model = temp;
            [self.mInfoTableView reloadData];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
   
}
-(void)getLeaderDetail{
    [HttpApi getLeaderDetail:@{@"userId":ZJ_UserID,@"leaderId":[self.mMyRouteModel.mleaderId stringValue]}SuccessBlock:^(id responseBody) {
        NSError *error;
        ZJLeaderDetailModel *temp = [MTLJSONAdapter modelOfClass:[ZJLeaderDetailModel class] fromJSONDictionary:responseBody error:&error];
        if (!error) {
            _model = temp;
            [self loadLeaderInfo];
            [self.mInfoTableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getNearbyUsers{
    
    NSString *latStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude];
    [[ZJNetWorkingHelper shareNetWork]getNearbyUsers:@{@"userId":ZJ_UserID,@"destId":@"1",@"lat":latStr,@"lng":lngStr,@"pageIndex":@"1",@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJNearUserModel class] fromJSONArray:responseBody[@"users"] error:&error];
        self.mNearUsers = tempArray;
        if (!error) {
            [self addPointAnnotation:self.mNearUsers];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getNearbyRouteUsers:(CLLocationCoordinate2D )coor{
    NSString *latStr = [NSString stringWithFormat:@"%f",coor.latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%f",coor.longitude];
    [[ZJNetWorkingHelper shareNetWork]getNearbyUsers:@{@"userId":ZJ_UserID,@"destId":@"1",@"lat":latStr,@"lng":lngStr,@"pageIndex":@"1",@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJNearUserModel class] fromJSONArray:responseBody[@"users"] error:&error];
        
        if (!error && tempArray.count>0) {
            [self.mNearLineCar addObjectsFromArray:tempArray];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (ZJNearUserModel *model in self.mNearLineCar) {
                [dict setObject:model forKey:model.muserId];
            }
            
            [self.mNearLineCar removeAllObjects];
            [self.mNearLineCar addObjectsFromArray:[dict allValues]];
            [self addPointAnnotation:self.mNearLineCar];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(void)getScences:(CLLocationCoordinate2D )coor{
    NSDictionary *mparcDic;
    NSString *latStr = [NSString stringWithFormat:@"%f",coor.latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%f",coor.longitude];
    mparcDic = @{@"userId":ZJ_UserID,@"destId":@"1",@"lat":latStr,@"lng":lngStr,@"pageIndex":@"1",@"pageSize":@"10"};
    
    [HttpApi getSpotList:mparcDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJSpotModel class] fromJSONArray:responseBody[@"spots"] error:&error];
        if (!error && tempArray.count>0) {
            [self.mNearLineSec addObjectsFromArray:tempArray];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (ZJSpotModel *model in self.mNearLineSec) {
                [dict setObject:model forKey:model.msid];
            }
            [self.mNearLineSec removeAllObjects];
            [self.mNearLineSec addObjectsFromArray:[dict allValues]];
            [self addPointAnnotation:self.mNearLineSec];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getTrafficList:(CLLocationCoordinate2D )coor{
    NSDictionary *mparcDic;
    NSString *latStr = [NSString stringWithFormat:@"%f",coor.latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%f",coor.longitude];
    mparcDic = @{@"userId":ZJ_UserID,@"destId":@"1",@"lat":latStr,@"lng":lngStr,@"pageIndex":@"1",@"pageSize":@"100"};
    
    [HttpApi getTrafficList:mparcDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJTrafficListModel class] fromJSONArray:responseBody[@"traffics"] error:&error];
        if (!error && tempArray.count>0) {
            
            [self.mNearLineTr addObjectsFromArray:tempArray];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (ZJTrafficListModel *model in self.mNearLineTr) {
                [dict setObject:model forKey:model.mtrafficId];
            }
            [self.mNearLineTr removeAllObjects];
            [self.mNearLineTr addObjectsFromArray:[dict allValues]];
            [self addPointAnnotation:self.mNearLineTr];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickUpTableView:(id)sender {
     self.mInfoTableView.hidden = NO;
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.y"]; ///.y 的话就向下移动。
    animation. fromValue = [NSNumber numberWithInteger:(-MainScreenFrame_Width)];
    animation. toValue = [NSNumber numberWithInteger:0];
    animation. duration = 0.2;
    animation. removedOnCompletion = NO ; //yes 的话，又返回原位置了。
    animation. repeatCount = 1 ;
    animation. fillMode = kCAFillModeForwards ;
    [self.mInfoTableView.layer addAnimation:animation forKey:@"transform.translation.y" ];
    
}
- (IBAction)onclickAddBtn:(id)sender {
    [ZJMenuAlertview showWithTitleS:@[@"选择领队",@"上报",@"路况",@"查看路线",@"途经景点"] andImages:@[@"ds_gh",@"ds_sb",@"ds_lk",@"ds_lx",@"ds_jd"]  Block:^(NSIndexPath *index) {
        switch (index.row) {
            case 0:
                //选择领队
                if (self.mMyRouteModel && self.mMyRouteModel.mleaderId !=nil) {
                    ShowMSG(@"你已经选择了领队");
                }else{
                    ZJGSelectLeaderVC *tempVC = [[ZJGSelectLeaderVC alloc]init];
                    [tempVC BackInfoWithBlock:^(ZJLeaderDetailModel *leadInfo) {
                        NSString *URID = @"";
                        if (self.mMyRouteModel) {
                            URID =[self.mMyRouteModel.mrid stringValue];
                        }
                        if (self.mRid) {
                            URID =self.mRid;
                        }
                        NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"urId":URID,@"leaderId":[leadInfo.mleaderId stringValue]};
                        [HttpApi bindLeaderd:mParamDic SuccessBlock:^(id responseBody) {
                            
                            _isSelectLeader = YES;
                            
                            CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.y"]; ///.y 的话就向下移动。
                            animation. toValue = [NSNumber numberWithInteger:(-MainScreenFrame_Width)];
                            animation. fromValue = [NSNumber numberWithInteger:0];
                            animation. duration = 0.2;
                            animation. removedOnCompletion = NO ; //yes 的话，又返回原位置了。
                            animation. repeatCount = 1 ;
                            animation. fillMode = kCAFillModeForwards ;
                            [self.mInfoTableView.layer addAnimation:animation forKey:@"transform.translation.y" ];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                self.mInfoTableView.hidden = YES;
                                [self.mInfoTableView reloadData];
                                [self loadLeaderInfo];
                            });
                        } FailureBlock:^(NSError *error) {
                            
                        }];
                    }];
                    [self.navigationController pushViewController:tempVC animated:YES];
                }
                break;
                
            case 1:{
              
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZJMenuAlertview showWithTitleS:@[@"拥堵",@"车祸",@"封路",@"施工",@"积水",@"故障"] andImages:@[@"t_yd",@"t_ch",@"t_fl",@"t_sg",@"t_js",@"t_gz"]  Block:^(NSIndexPath *index) {
                        [ZJMenuAlertview dismiss];
                        NSString *mtype = [NSString stringWithFormat:@"%ld",(long)index.row+1];
                        //上报
                        if (mTrView == nil) {
                            mTrView = [[NSBundle mainBundle]loadNibNamed:@"trafficReportView" owner:nil options:nil][0];
                        }
                        
                        __weak typeof(mTrView) weakTrView = mTrView;
                        __weak typeof(self) weakSelf = self;
                        __block __weak typeof(_location) weakLoction = _location;
                        
                        [mTrView setSelectMapPoint:^(UIButton *) {
                            weakTrView.hidden = YES;
                            ZJSelectMapVC *tempVC = [[ZJSelectMapVC alloc]init];
                            [tempVC backInfo:^(id temp) {
                                if ([temp isKindOfClass:[BMKReverseGeoCodeResult class]]) {
                                    BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult *)temp;
                                    weakTrView.mlab_ad.text = result.address;
                                    weakLoction = result.location;
                                    return;
                                }
                                BMKPoiInfo *result = (BMKPoiInfo *)temp;
                                if (result.address) {
                                     weakTrView.mlab_ad.text = result.address;
                                }else{
                                    weakTrView.mlab_ad.text = result.city;
                                }
                                weakLoction = result.pt;
                                
                            }];
                            [weakSelf.navigationController pushViewController:tempVC animated:YES];
                        }];
                        [mTrView setSelectPhoto:^(UIButton *) {
                            UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:(id)weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
                            [mActionSheet showInView:weakSelf.view];
                        }];
                        
                        [mTrView setPutBtn:^(UIButton *) {
                            if (photoName == nil) {
                                //photoName = @"";
                                ShowMSG(@"请上传照片");
                                return;
                            }
                            NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"type":mtype,@"photo":photoName,@"content":weakTrView.mtf_content.text,@"lat":[NSString stringWithFormat:@"%f",weakLoction.latitude],@"lng":[NSString stringWithFormat:@"%f",weakLoction.longitude]};
                            [[ZJNetWorkingHelper shareNetWork]putTraffic:mParamDic SuccessBlock:^(id responseBody) {
                                [mTrView removeFromSuperview];
                            } FailureBlock:^(NSError *error) {
                                
                            }];
                        }];
                        mTrView.mlab_ad.text = userLoc;
                        [self.tabBarController.view addSubview:mTrView];
                        [mTrView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.right.top.bottom.mas_equalTo(0);
                        }];
                    }];
                });
                
                break;}
            case 2:
                //路况
                if(_mLineSec.count>0){
                    [_mapView removeAnnotations:_mLineSec];
                }
                if (_mNearAnn.count>0) {
                    [_mapView removeAnnotations:_mNearAnn];
                    [_mNearAnn removeAllObjects];
                }
                if (_mLineAnn.count>0) {
                    [_mapView removeAnnotations:_mLineAnn];
                }
                if (_mLineTr.count>0) {
                    [_mapView addAnnotations:_mLineTr];
                }
                break;

            case 3:
                //查看路线
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 4:
                //途经景点
                if (_mNearAnn.count>0) {
                    [_mapView removeAnnotations:_mNearAnn];
                    [_mNearAnn removeAllObjects];
                }
                if (_mLineAnn.count>0) {
                   [_mapView removeAnnotations:_mNearAnn];
                }
                if ((_mLineTr.count>0)) {
                    [_mapView removeAnnotations:_mLineTr];
                }
                if (_mLineSec.count>0) {
                    [_mapView addAnnotations:_mLineSec];
                }
                break;
            default:
                break;
        }
        [ZJMenuAlertview dismiss];
    }];
}
- (IBAction)onclickAroundCF:(id)sender {
    if(_mLineSec.count>0){
        [_mapView removeAnnotations:_mLineSec];
    }
    if (_mNearAnn.count>0) {
        [_mapView removeAnnotations:_mNearAnn];
    }
    if ((_mLineTr.count>0)) {
         [_mapView removeAnnotations:_mLineTr];
    }
    
    [self getNearbyUsers];
}
- (IBAction)onlcickRF:(id)sender {
    if(_mLineSec.count>0){
        [_mapView removeAnnotations:_mLineSec];
    }
    if (_mNearAnn.count>0) {
        [_mapView removeAnnotations:_mNearAnn];
    }
    if ((_mLineTr.count>0)) {
        [_mapView removeAnnotations:_mLineTr];
    }
    
    if (_mLineAnn.count>0) {
        [_mapView addAnnotations:_mLineAnn];
    }
}
- (IBAction)onclickRescueBtn:(id)sender {
    //[_mapView setCenterCoordinate:_mapView.centerCoordinate animated:YES];
    
    ZJPutInfoView *temp = [[NSBundle mainBundle]loadNibNamed:@"ZJPutInfoView" owner:nil options:nil][0];
    temp.mlab_time.text = [MyFounctions getCurrentDate];
    temp.mlab_adress.text = userLoc;
    [temp onclickSendBtnWithBlock:^(UIButton *sender) {
        [temp removeFromSuperview];
        NSString *ad= [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude ];
        NSString *lng= [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude];
        NSDictionary *param = @{@"userId":ZJ_UserID,@"address":userLoc,@"lat":ad,@"lng":lng};
        [HttpApi putRescue:param SuccessBlock:^(id responseBody) {
            [SVProgressHUD showSuccessWithStatus:@"成功"];
        } FailureBlock:^(NSError *error) {
            
        }];
    }];
    [self.navigationController.view addSubview:temp];
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
- (IBAction)onclickPutNeedBtn:(id)sender {
    ZJPutNeedInfoView *mNeedView = [[NSBundle mainBundle]loadNibNamed:@"ZJPutNeedInfoView" owner:nil options:nil][0];
    [self.navigationController.view addSubview:mNeedView];
   __weak typeof(mNeedView) weakNeedView = mNeedView;
    [mNeedView setPutBtnBlock:^(UIButton *) {
        NSString *ad= [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude ];
        NSString *lng= [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude];
#ifdef DEBUG_FLAG
        if (userLoc.length==0) {
            userLoc = @"重庆狮子坪轻轨站";
        }
        
#endif
        NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"type":weakNeedView.mTypeStr,@"remarks":weakNeedView.tf.text,@"mobile":[MyFounctions getUserInfo][@"phoneNum"],@"lat":ad,@"lng":lng,@"address":userLoc};
        [[ZJNetWorkingHelper shareNetWork]putDemand:mParamDic SuccessBlock:^(id responseBody) {
            [weakNeedView removeFromSuperview];
        } FailureBlock:^(NSError *error) {
            
        }];
    }];
    [mNeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark private
-(void)loadLeaderInfo{
    if (_model) {
        if (self.mMyRouteModel.mleaderId == nil) {
            [self.mlab_status setTitle:@"为您推荐领队" forState:UIControlStateNormal];
            return;
        }else{
            switch ([self.mMyRouteModel.mstatus integerValue]) {
                case 2:{
                    [self.mlab_status setTitle:@"服务中" forState:UIControlStateNormal];
                    break;}
                case 1:
                    [self.mlab_status setTitle:@"待服务" forState:UIControlStateNormal];
                    break;
                case 3:
                    if (self.mMyRouteModel.mcreater == nil) {
                        [self.mlab_status setTitle:@"已结束" forState:UIControlStateNormal];
                        
                    }else{
                        [self.mlab_status setTitle:@"待评价" forState:UIControlStateNormal];
                    }
                    break;
                case 4:
                    [self.mlab_status setTitle:@"已评价" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
        }
       
        self.mlab_name.text = _model.mnickname;
        [self.mimg_head sd_setImageWithURL:[NSURL URLWithString:_model.mheadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
    }
}
-(void)loadMapline:(NSArray *)mafters{
    
    if (mafters && mafters.count>0) {
        BMKPlanNode* start;
        BMKPlanNode* end;
        NSMutableArray *wayPointsArray = [NSMutableArray array];
        for (int i = 0; i < mafters.count; i++) {
            BMKPoiInfo *model = mafters[i];
            if ([model isKindOfClass:[BMKPoiInfo class]]) {
                if (i == 0) {
                    start = [[BMKPlanNode alloc]init];
                    start.pt =  model.pt;
                }else if (i == mafters.count - 1) {
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
                    }else if (i == mafters.count - 1) {
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
}
-(void)loadNavBarViews{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [mNavView insertSubview:mBarBgView atIndex:0];
    
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
}

//添加标注
- (void)addPointAnnotation:(NSArray *)array
{
    if (array && array.count>0) {
        
        for (ZJNearUserModel *model in array) {
            if (model) {
                ZJPointAnnotation *pointAnnotation = [[ZJPointAnnotation alloc]init];
                ZJCalloutMapAnnotation *_calloutMapAnnotation;
                
                if ([model isKindOfClass:[ZJNearUserModel class]]) {
                    CLLocationCoordinate2D coor;
                    coor.latitude = [model.mlat floatValue];
                    coor.longitude = [model.mlng floatValue];
    
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.title = model.mnickname;
                    pointAnnotation.subtitle = [[model.mjl stringValue] stringByAppendingString:@"m"];
                    
                    //创建搭载自定义calloutview的annotation
                    _calloutMapAnnotation= [[ZJCalloutMapAnnotation alloc] initWithLatitude:pointAnnotation.coordinate.latitude andLongitude:pointAnnotation.coordinate.longitude] ;
                    //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
                    NSString *imgeurl = model.mheadImgUrl;
                    NSString *dis = [NSString stringWithFormat:@"%ld",[model.mjl integerValue]/1000];
                    if (imgeurl == nil) {
                        imgeurl = @"";
                    }
                    if (dis == nil) {
                        dis = @"";
                    }
                    
                    _calloutMapAnnotation.locationInfo = @{@"name":model.mnickname,@"dis":[dis stringByAppendingString:@"m"],@"img":imgeurl,@"userId":[model.muserId stringValue],@"moblie":model.mobile};
                    
                    if (array !=self.mNearUsers) {
                        [_mLineAnn addObject:pointAnnotation];
                        [_mLineAnn addObject:_calloutMapAnnotation];
                    }
                 
                }else if([model isKindOfClass:[ZJSpotModel class]]){
                    
                    ZJSpotModel *tempModel = (ZJSpotModel *)model;
                    
                    CLLocationCoordinate2D coor;
                    coor.latitude = [tempModel.mlat floatValue];
                    coor.longitude = [tempModel.mlng floatValue];
                    
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.title = tempModel.msname;
                    pointAnnotation.subtitle = [[model.mjl stringValue] stringByAppendingString:@"km"];
                    
                    //创建搭载自定义calloutview的annotation
                    _calloutMapAnnotation= [[ZJCalloutMapAnnotation alloc] initWithLatitude:pointAnnotation.coordinate.latitude andLongitude:pointAnnotation.coordinate.longitude] ;
                    //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
                    NSString *imgeurl = tempModel.mphotos;
                    NSString *dis = [NSString stringWithFormat:@"%ld",[tempModel.mjl integerValue]/1000];
                    if (imgeurl == nil) {
                        imgeurl = @"";
                    }
                    if (dis == nil) {
                        dis = @"";
                    }
                    _calloutMapAnnotation.locationInfo = @{@"name":tempModel.msname,@"dis":[dis stringByAppendingString:@"m"],@"img":imgeurl};
                    _calloutMapAnnotation.temp = tempModel;
                    
                    [_mLineSec addObject:pointAnnotation];
                    [_mLineSec addObject:_calloutMapAnnotation];
                    
                }else if ([model isKindOfClass:[ZJTrafficListModel class]]){
                    
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    ZJTrafficListModel *tempModel = (ZJTrafficListModel *)model;
                    
                    CLLocationCoordinate2D coor;
                    coor.latitude = [tempModel.mlat floatValue];
                    coor.longitude = [tempModel.mlng floatValue];
                    item.coordinate = coor;
                    item.type = [tempModel.mtype integerValue]+6;
                    item.tempModel = tempModel;
                    pointAnnotation.coordinate = coor;
                    NSString *title = @"";
                    //1拥堵 2车祸 3封路 4施工 5积水 6故障
                    switch ([tempModel.mtype integerValue]) {
                        case 1:
                            title= @"拥堵";
                            break;
                        case 2:
                             title= @"车祸";
                            break;
                        case 3:
                             title= @"封路";
                            break;
                        case 4:
                             title= @"施工";
                            break;
                        case 5:
                            title= @"积水";
                            break;
                        case 6:
                            title= @"故障";
                            break;
                            
                        default:
                            break;
                    }
                    
                    [_mLineTr addObject:item];
                }
                
                if (array == self.mNearUsers) {
                    [_mNearAnn addObject:pointAnnotation];
                    [_mNearAnn addObject:_calloutMapAnnotation];
                    [_mapView addAnnotation:pointAnnotation];
                    [_mapView addAnnotation:_calloutMapAnnotation];
//                }else if([self.mNearLineCar containsObject:array]){
//                   
//                }else if([self.mNearLineSec containsObject:array]){
//                   
//                }
//                else if([self.mNearLineTr containsObject:array]){
//                    
                }
            }
        }
    }
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    [mTrView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}
-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    [mTrView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardRect.size.height);
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model == nil) {
        return 1;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row>=1){
        
        if (_isSelectLeader == NO) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJDepartCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDepartCell"];
            ZJDepartCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDepartCell"];
            [cell onclickSelectBlcokBtnBlock:^(UIButton *sender) {
                NSString *URID = @"";
                if (self.mMyRouteModel) {
                    URID =[self.mMyRouteModel.mrid stringValue];
                }
                if (self.mRid) {
                    URID =self.mRid;
                }
                NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"urId":URID,@"leaderId":[_model.mleaderId stringValue]};
                [HttpApi bindLeaderd:mParamDic SuccessBlock:^(id responseBody) {
                    _isSelectLeader = YES;
                    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.y"]; ///.y 的话就向下移动。
                    animation. toValue = [NSNumber numberWithInteger:(-MainScreenFrame_Width)];
                    animation. fromValue = [NSNumber numberWithInteger:0];
                    animation. duration = 0.2;
                    animation. removedOnCompletion = NO ; //yes 的话，又返回原位置了。
                    animation. repeatCount = 1 ;
                    animation. fillMode = kCAFillModeForwards ;
                    [self.mInfoTableView.layer addAnimation:animation forKey:@"transform.translation.y" ];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        self.mInfoTableView.hidden = YES;
                    
                        [tableView reloadData];
                        
                        self.mMyRouteModel.mleaderId = _model.mleaderId;
                        
                        [self loadLeaderInfo];
                    });
                } FailureBlock:^(NSError *error) {
                    
                }];
                
            }];
            if (_model) {
                [cell loadDataSoureWithModel:_model];
            }
            
            [cell onclickDeletailBtnBlock:^(UIButton *sender) {
               
                if (_model) {
                    ZJLeaderDtialVC *temp = [[ZJLeaderDtialVC alloc]init];
                    ZJLenderListModel *model = [ZJLenderListModel new];
                    model.mleaderId =_model.mleaderId;
                    model.msrvCount = _model.msrvCount;
                    model.mnickname = _model.mnickname;
                    model.mheadImgUrl = _model.mheadImgUrl;
                    model.mgoodArea = _model.mgoodArea;
                    temp.mSelectModel = model;
                    [self.navigationController pushViewController:temp animated:YES];
                }
            
            }];
            
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"ZJDepartCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDepartCell1"];
        ZJDepartCell1*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDepartCell1"];
        [cell loadDataSoureWithModel:_model];
        [cell onclickCallBtnBlock:^(UIButton *sender) {
            if (_model.mmobile) {
                [MyFounctions callPhone:_model.mmobile];
            }
        }];
        [cell onclickChatBlcokBtnBlock:^(UIButton *sender) {
            if (_model.mmobile) {
                NSString *chatter = [@"leader_"stringByAppendingString:_model.mmobile];
                if (chatter) {
                    ZJChatVC *viewController = [[ZJChatVC alloc] initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
                    viewController.title = _model.mnickname;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
        }];
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJDepartHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDepartHeaderCell"];
    ZJDepartHeaderCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDepartHeaderCell"];
    [cell loadDataSoureWithModel:self.mMyRouteModel];
    [cell onclickBackBtnBlock:^(UIButton *sender) {
        [self onclickBackBtn:sender];
    }];
    [cell onclickAddBtnBlock:^(UIButton *sender) {
        [self onclickAddBtn:sender];
    }];
    [cell onclickDownOrUpBtnBlock:^(UIButton *sender) {
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.y"]; ///.y 的话就向下移动。
        animation. toValue = [NSNumber numberWithInteger:(-MainScreenFrame_Width)];
        animation. fromValue = [NSNumber numberWithInteger:0];
        animation. duration = 0.2;
        animation. removedOnCompletion = NO ; //yes 的话，又返回原位置了。
        animation. repeatCount = 1 ;
        animation. fillMode = kCAFillModeForwards ;
        [self.mInfoTableView.layer addAnimation:animation forKey:@"transform.translation.y" ];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.mInfoTableView.hidden = YES;
        });
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            //相册
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                ShowMSG(@"您的设备不支持图库");
            }
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                ShowMSG(@"您的设备不支持相册");
            }
            UIImagePickerController *mImagePickerVC = [[UIImagePickerController alloc]init];
            [mImagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            mImagePickerVC.delegate = (id)self;
            //            mImagePickerVC.allowsEditing = YES;
            [self presentViewController:mImagePickerVC animated:YES completion:nil];
            break;}
            
        case 1:{
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                ShowMSG(@"您的设备不支持相机");
                return;
            }
            UIImagePickerController *mImagePickerVC = [[UIImagePickerController alloc]init];
            mImagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            mImagePickerVC.delegate = (id)self;
            //            mImagePickerVC.allowsEditing = YES;
            [self presentViewController:mImagePickerVC animated:YES completion:nil];
            //相机
            break;}
            
        default:
            break;
    }
}
#pragma mark UIImagePickerControllerDelegate
//成功获得相片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if (([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) | UIImagePickerControllerSourceTypeSavedPhotosAlbum ) {
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* edit1 = [MyFounctions imageCompressForWidth:edit targetWidth:MainScreenFrame_Width];
        NSData *imageData = UIImagePNGRepresentation(edit1);
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            [self upHeadImage:imageData teype:@"7" comple:^(bool reslut, NSString *fname) {
                photoName = fname;
                LDLOG(@"%@",photoName);
            }];
        }];
    }else{
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        //        NSData *imageData = UIImagePNGRepresentation(edit);
        UIImage* edit1 = [MyFounctions imageCompressForWidth:edit targetWidth:MainScreenFrame_Width];
        NSData *imageData = UIImagePNGRepresentation(edit1);
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            [self upHeadImage:imageData teype:@"7" comple:^(bool reslut, NSString *fname) {
                 photoName = fname;
                 LDLOG(@"%@",photoName);
            }];
        }];
    }
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //模态方式退出uiimagepickercontroller
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    NSLog(@"saved..");
}
#pragma mark implement BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ZJCalloutMapAnnotation class]]){
        //此时annotation就是我们calloutview的annotation
        ZJCalloutMapAnnotation *ann = (ZJCalloutMapAnnotation*)annotation;  //如果可以重用
        ZJCallOutAnnotationView *calloutannotationview = (ZJCallOutAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        //否则创建新的calloutView
        if (!calloutannotationview) {
            calloutannotationview = [[ZJCallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
            ZJPointCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ZJPointCell" owner:self options:nil] objectAtIndex:0];
            [calloutannotationview.contentView addSubview:cell];
            calloutannotationview.busInfoView = cell;
            [cell setOnclickBtn:^(UIButton *) {
                NSString *phone = ann.locationInfo[@"moblie"];
                if(phone){
                    ZJChatVC *viewController = [[ZJChatVC alloc] initWithConversationChatter:[@"user_" stringByAppendingString:phone] conversationType:EMConversationTypeChat];
                    viewController.title = ann.locationInfo[@"name"];
                    [self.navigationController pushViewController:viewController animated:YES];
                }else{
                    ZJASDetailVC *tempVC = [[ZJASDetailVC alloc]init];
                    ZJSpotModel *tempModel = (ZJSpotModel *)ann.temp;
                    tempVC.mSelectModel = tempModel;
                    [self.navigationController pushViewController:tempVC animated:YES];
                }
            }];
        }
        calloutannotationview.busInfoView.mName.text = ann.locationInfo[@"name"];
        calloutannotationview.busInfoView.mDistance.text = ann.locationInfo[@"dis"];
        [calloutannotationview.busInfoView.mHeadView sd_setImageWithURL:[NSURL URLWithString:ann.locationInfo[@"img"]] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];
        return calloutannotationview;
    }else  if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }else{
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"r_carFrid.png"];
            [annotationView setSelected:YES];
        }
         return annotationView;
    }
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{

}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
//CustomPointAnnotation 是自定义的marker标注点，通过这个来得到添加marker时设置的pointCalloutInfo属性
    id ann = view.annotation;
    if ([ann isKindOfClass:[ZJCalloutMapAnnotation class]]) {
        if ([_mNearAnn containsObject:ann]|| [_mLineAnn containsObject:ann]) {
          
        }
    }else if([ann isKindOfClass:[RouteAnnotation class]]){
        LDLOG(@"哈哈哈");
        RouteAnnotation * tempAnn = (RouteAnnotation *)ann;
        if (tempAnn.tempModel) {
             [view setSelected:NO];
            ZJTrafficDeatilVC *tempVC= [[ZJTrafficDeatilVC alloc]init];
            tempVC.mSelectModel = tempAnn.tempModel;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }
}

//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    [ZJSingleHelper shareNetWork].mUeserPt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = [ZJSingleHelper shareNetWork].mUeserPt;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
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
            
            BMKDrivingStep* transitStep1;
            BMKDrivingStep* transitStep2;
            if (i >=1) {
                if (transitStep1 == nil) {
                    transitStep1 = [plan.steps objectAtIndex:i];
                }
                if (transitStep2 == nil) {
                    transitStep2=  [plan.steps objectAtIndex:i -1];
                }
                CLLocationCoordinate2D  coor1 = transitStep1.entrace.location;
                CLLocationCoordinate2D  coor2 =  transitStep2.entrace.location;
                BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
                BMKMapPoint point2 = BMKMapPointForCoordinate(coor2);
                CLLocationDistance juli = BMKMetersBetweenMapPoints(pt1, point2);
                if (juli/1000 > 10) {
                    [self getNearbyRouteUsers:coor2];
                    [self getScences:coor2];
                    [self getTrafficList:coor2];
                    transitStep2 =nil;
                }else{
                    transitStep1 = nil;
                }
            }
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
#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        userLoc = [result.addressDetail.streetName stringByAppendingString:result.addressDetail.streetNumber];
    }
}
//上传
-(void)upHeadImage:(NSData *)imageData teype:(NSString *)type comple:(void (^)(bool reslut ,NSString *fname))block{
    [HttpApi getUptoken:@{@"type":type,@"userId":ZJ_UserID} SuccessBlock:^(id responseBody) {
        NSString *_headImageStr= responseBody[@"fname"];
        NSString *uptokenStr = responseBody[@"uptoken"];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        QNUploadOption *upoPtion = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showProgress:percent maskType:SVProgressHUDMaskTypeGradient];
        }];
        [upManager putData:imageData key:_headImageStr token:uptokenStr complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (resp) {
                LDLOG(@"%@", info);
                LDLOG(@"%@", resp);
                [SVProgressHUD dismiss];
                block(YES,key);
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                 block(NO,@"");
            }
            
        } option:upoPtion];
    } FailureBlock:^(NSError *error) {
        block(@NO,@"");
    }];
}
@end
