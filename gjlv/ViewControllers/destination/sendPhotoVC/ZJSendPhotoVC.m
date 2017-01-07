//
//  ZJSendPhotoView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSendPhotoVC.h"
#import "ZJSelectMapVC.h"
@interface ZJSendPhotoVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mIMG_photo;
@property (weak, nonatomic) IBOutlet UIView *MTFView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_ts;

@property (weak, nonatomic) IBOutlet UILabel *mlab_city;
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;
@property (weak, nonatomic) IBOutlet UITextView *mTF_content;

@end

@implementation ZJSendPhotoVC{
    NSMutableString *_mPhotos;
    bool isBestPhoto;
    CLLocationCoordinate2D _location;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    NSString *userLoc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mPhotos = [NSMutableString string];
    isBestPhoto= NO;
    
    self.mIMG_photo.image = [UIImage imageWithData:self.mPhotoData];
    self.mIMG_photo.clipsToBounds = YES;
    
    self.MTFView.hidden = YES;
    
    self.mlab_city.text = @"";
    NSString *timeStr = [MyFounctions stringFromDate:[NSDate date]];
    self.mlab_time.text = [NSString stringWithFormat:@"拍摄于%@",timeStr];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = (id)self;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    _locService.distanceFilter = 1000;
    [_locService startUserLocationService];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _locService.delegate = (id)self;
    _geocodesearch.delegate = (id)self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _locService.delegate = nil;
     _geocodesearch.delegate = nil;
}
-(void)dealloc{
    if (_locService) {
        _locService = nil;
    }
    if (_geocodesearch) {
        _geocodesearch = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"分享你拍下这张照片的心情和故事！"]) {
        textView.text = @"";
    }
    return YES;
}
#pragma mark private
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
                NSString *mContet = @"";
                if (self.mTF_content.text && self.mTF_content.text.length>0) {
                    mContet = self.mTF_content.text;
                }
                NSString *isOptimum = @"2";
                if (isBestPhoto) {
                    isOptimum = @"1";
                }
                NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"title":@"",@"address":self.mlab_city.text,@"content":mContet,@"lng":[NSString stringWithFormat:@"%f",_location.longitude],@"lat":[NSString stringWithFormat:@"%f",_location.latitude],@"destId":self.mSelectModel.mdestId,@"photos":_headImageStr,@"isOptimum":isOptimum};
                
                [[ZJNetWorkingHelper shareNetWork]putScene:mParaDic SuccessBlock:^(id responseBody) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
        
            }
           
        } option:upoPtion];
    } FailureBlock:^(NSError *error) {
          block(@NO,@"");
    }];
}
#pragma mark event response
- (IBAction)onclikcBestPlaceBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    isBestPhoto = sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"s_selected"] forState:UIControlStateNormal];
        [sender setTitleColor:BG_Yellow forState:UIControlStateNormal];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"s_unselected"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (IBAction)onclickTakePhotoPacleBtn:(id)sender {
    ZJSelectMapVC *tempVC = [[ZJSelectMapVC alloc]init];
    tempVC.title = @"发布";
    __weak typeof(self) weakSelf = self;
    [tempVC backInfo:^(id temp) {
        if ([temp isKindOfClass:[BMKReverseGeoCodeResult class]]) {
            BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult *)temp;
            weakSelf.mlab_city.text =  result.address;
            _location = result.location;
            return;
        }
        BMKPoiInfo *result = (BMKPoiInfo *)temp;
        weakSelf.mlab_city.text =  result.address;
        _location = result.pt;
    }];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickTSBtn:(id)sender {
    self.MTFView.hidden = NO;
    
}

- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickSendBtn:(id)sender {
    if (self.mlab_city.text == nil || self.mlab_city.text.length == 0) {
        ShowMSG(@"请选择拍摄地");
        return;
    }
    [self upHeadImage:self.mPhotoData teype:@"6" comple:nil];
}
#pragma mark BMKUserLocationDelegate
//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [ZJSingleHelper shareNetWork].mUeserPt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = [ZJSingleHelper shareNetWork].mUeserPt;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}
#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        userLoc = [result.addressDetail.streetName stringByAppendingString:result.addressDetail.streetNumber];
        self.mlab_city.text = userLoc;
    }
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
