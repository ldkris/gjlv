//
//  ZJSearchPointVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSearchPointVC.h"

@interface ZJSearchPointVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mSearchTF;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJSearchPointVC{
    BMKPoiSearch* _poisearch;
    BMKLocationService* _locService;
    bool isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = (id)self;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    
    [_locService startUserLocationService];
  
    
    [self.mNavView setBackgroundColor:BG_Yellow];
    
    [self.mSearchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _poisearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = (id)self;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
     _poisearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_locService) {
        _locService = nil;
    }

}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark public
-(void)backInfoBlock:(void (^)(BMKPoiInfo *))block{
    self.BackInfoBlock = block;
}
#pragma mark event response
- (IBAction)onclickBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)keyboardWillShow:(NSNotification *) notification{
    [super keyboardWillShow:notification];
}
- (void)keyboardWillHide:(NSNotification *) notification{
    [super keyboardWillHide:notification];

}
#pragma mark BMKUserLocationDelegare
//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
   
    BMKNearbySearchOption *citySearchOption = [[BMKNearbySearchOption alloc]init];
    citySearchOption.radius = 1000;
    citySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;
    citySearchOption.pageCapacity = 20;
    citySearchOption.keyword = @"街道";
    citySearchOption.pageIndex = 1;
    citySearchOption.location = userLocation.location.coordinate;
    [_poisearch poiSearchNearBy:citySearchOption];
    
    [_locService stopUserLocationService];

}
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.poiInfoList.count == 0 && result.cityList.count>0) {
            BMKCityListInfo *info = result.cityList[0];
            
            BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
            citySearchOption.pageCapacity = 20;
            citySearchOption.city = info.city;
            citySearchOption.keyword = self.mSearchTF.text;
            [_poisearch poiSearchInCity:citySearchOption];
        }
        
        [self.mDataSoure removeAllObjects];
        [self.mDataSoure addObjectsFromArray:result.poiInfoList];
        [self.mInfoTableView reloadData];
    }
}

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    [textField resignFirstResponder];
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageCapacity = 20;
    citySearchOption.city = @"  ";
    citySearchOption.keyword = textField.text;
    [_poisearch poiSearchInCity:citySearchOption];
    
    return YES;
}
-(void)textFieldDidChange:(UITextField *)textField{
//    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
//    citySearchOption.keyword =  textField.text;
//    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
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
    [self.navigationController popViewControllerAnimated:YES];
    
    BMKPoiInfo *temp = self.mDataSoure[indexPath.row];
    self.BackInfoBlock(temp);
}

@end
