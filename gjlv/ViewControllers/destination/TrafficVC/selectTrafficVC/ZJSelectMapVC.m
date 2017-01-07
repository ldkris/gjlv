//
//  ZJSelectMapVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSelectMapVC.h"

#import "ZJTrafficVC.h"
@interface ZJSelectMapVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mlab_city;
@property (weak, nonatomic) IBOutlet UIView *mBarView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_adress;
@property (weak, nonatomic) IBOutlet BMKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJSelectMapVC{
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _geocodesearch;
    BMKReverseGeoCodeResult *_userGeoInfo;
    BMKPoiSearch* _poisearch;
    bool mapCenter;
}
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (![self.title  isEqual: @"发布"]) {
          self.title = @"地图选点";
    }
    
    mapCenter = NO;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [self.mBarView addSubview:mBarBgView];
    [self.mBarView insertSubview:mBarBgView atIndex:0];
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    self.mMapView.delegate = (id)self;
    //设置地图缩放级别
    [ self.mMapView setZoomLevel:15];
    self.mMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mMapView.showsUserLocation = YES;//显示定位图层
    self.mMapView.delegate = (id) self;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    [_locService startUserLocationService];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = (id)self;
    
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = (id)self;
    
    self.mInfoTableView.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mMapView viewWillAppear];
    self.mMapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = (id)self;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mMapView viewWillDisappear];
    self.mMapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)dealloc {
    if (self.mMapView) {
        self.mMapView = nil;
    }
    if (_locService) {
        _locService = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_poisearch != nil) {
        _poisearch = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark public
-(void)backInfo:(void (^)(id))blcok{
    self.backBlock = blcok;
}
#pragma mark event response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)onclickComfirSearchBtn:(id)sender {
    
    if (self.mTF_input.text == nil || self.mTF_input.text.length == 0) {
        ShowMSG(@"请输入搜索关键字");
        return;
    }
    self.mInfoTableView.hidden = NO;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageCapacity = 20;
    citySearchOption.keyword = self.mTF_input.text;
    [_poisearch poiSearchInCity:citySearchOption];
    
}
- (IBAction)onclickComfirBtn:(id)sender {
    if (![self.title  isEqual: @"发布"]) {
        ZJTrafficVC *tempVC = [[ZJTrafficVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        if (self.backBlock && _userGeoInfo) {
            self.backBlock(_userGeoInfo);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.mInfoTableView.hidden = NO;
}
#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        self.mlab_city.text = [result.addressDetail.city stringByAppendingString:result.addressDetail.district];
        self.mlab_adress.text = [result.addressDetail.streetName stringByAppendingString:result.addressDetail.streetNumber];
        _userGeoInfo = result;
    }
}
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.mTF_input resignFirstResponder];
        
        [self.mDataSoure removeAllObjects];
        [self.mDataSoure addObjectsFromArray:result.poiInfoList];
        [self.mInfoTableView reloadData];
    }
}
#pragma mark BMKUserLocationDelegate
//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mMapView updateLocationData:userLocation];
    if (!mapCenter) {
        [_mMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        [ZJSingleHelper shareNetWork].mUeserPt = userLocation.location.coordinate;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = [ZJSingleHelper shareNetWork].mUeserPt;
        [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        mapCenter = YES;
    }
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifiy = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifiy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifiy];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"dd_ad"]];
    BMKPoiInfo *tempInfo = self.mDataSoure[indexPath.row];
    cell.textLabel.text = tempInfo.name;
    cell.detailTextLabel.text = tempInfo.address;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPoiInfo *temp = self.mDataSoure[indexPath.row];
    self.backBlock(temp);
    [self.navigationController popViewControllerAnimated:YES];
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
