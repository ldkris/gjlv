//
//  ViewController.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJBDetailVC.h"
#import "ZJFoodCell1.h"
#import "ZJFoodCell5.h"
#import "ZJFoodCell3Cell.h"
#import "ZJFoodCell4.h"
#import "ZJFoodCell6.h"
#import "ZJBDCell.h"
#import "ZJBDCell1.h"
#import "ZJCommentVC.h"
@interface ZJBDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain) NSMutableArray *mAllComments;
@end

@implementation ZJBDetailVC{

    ZJHotelDetialModel *_hotelDetailModel;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    [self getHotelDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJFoodCell3Cell class]]) {
            ZJFoodCell3Cell *cell = tempCell;
            [cell unCellSetMapDelagete];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJFoodCell3Cell class]]) {
            ZJFoodCell3Cell *cell = tempCell;
            [cell cellSetMapDelagete];
        }
    }
}
-(void)dealloc{
    for (id tempCell in [self.mInfoTableView visibleCells]) {
        if ([tempCell isKindOfClass:[ZJFoodCell3Cell class]]) {
            ZJFoodCell3Cell *cell = tempCell;
            [cell mapViewDelloc];
        }
    }
}
#pragma mark getter
-(NSMutableArray *)mAllComments{
    if (_mAllComments == nil) {
        _mAllComments = [NSMutableArray array];
    }
    return _mAllComments;
}
#pragma mark private
#pragma mark networking
-(void)getHotelDetail{
    [SVProgressHUD show];
    [HttpApi getHotelDetail:@{@"userId":ZJ_UserID,@"hid":[self.mSelectHotelModel.mHid stringValue]} SuccessBlock:^(id responseBody) {
        
        NSError *error;
        ZJHotelDetialModel *hotelDetailModel = [MTLJSONAdapter modelOfClass:[ZJHotelDetialModel class] fromJSONDictionary:responseBody error:&error];
        _hotelDetailModel = hotelDetailModel;
        [self getHotelAllComments];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getHotelAllComments{
    [HttpApi getHotelCommentList:@{@"userId":ZJ_UserID,@"hid":[self.mSelectHotelModel.mHid stringValue],@"pageIndex":@"1",@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJHotelCommentModel class] fromJSONArray:responseBody[@"comments"] error:&error];
        [self.mAllComments addObjectsFromArray:tempArray];
        [self.mInfoTableView reloadData];
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickShareBtn:(id)sender {
}
- (IBAction)onclickCommentBtn:(id)sender {
    ZJCommentVC *tempVC = [[ZJCommentVC alloc]init];
    tempVC.model = self.mSelectHotelModel;
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = BG_Yellow;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((64 - offsetY) / 64);
        self.mNavView.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        self.mNavView.backgroundColor = [color colorWithAlphaComponent:0];
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",APPName,@"GJLV001",[_mSelectHotelModel.mHlat floatValue], [_mSelectHotelModel.mHlng floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];}
            
            break;
        case 0:{
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", [_mSelectHotelModel.mHlat floatValue],[_mSelectHotelModel.mHlng floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];}
            
            break;
            
        default:
            
            break;
    }
}
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4.0f;
    }
    return 2+self.mAllComments.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }
    return 0.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell1"];
            ZJFoodCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell1"];
            [cell.mImgeView sd_setImageWithURL:[NSURL URLWithString:_hotelDetailModel.mHphoto] placeholderImage:[UIImage imageNamed:@"dd_def"]];
            cell.mlab_name.text = _hotelDetailModel.mHname;
            cell.mlab_count.text = [_hotelDetailModel.mHcommentCount stringValue];
            return cell;
        }
        
        if (indexPath.row == 1) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJBDCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJBDCell"];
            ZJBDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJBDCell"];
            [cell loadDataWithModel:_hotelDetailModel];
            return cell;
        }
        
        if (indexPath.row == 2) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell3Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell3Cell"];
            ZJFoodCell3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell3Cell"];
            if (_hotelDetailModel && _hotelDetailModel.mHlat && _hotelDetailModel.mHlng) {
                CLLocationCoordinate2D coor;
                coor.latitude = [_hotelDetailModel.mHlat floatValue];
                coor.longitude = [_hotelDetailModel.mHlng floatValue];
                [cell loadlocWithlonlat:coor];
                [cell onclickNavigationgBlock:^(UIButton *sender) {
                    UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择导航" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度导航",@"高德导航", nil];
                    [mActionSheet showInView:self.view];
                }];
            }
            
            return cell;
        }
        
        if(indexPath.row ==3){
            [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell4" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell4"];
            ZJFoodCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell4"];
            [cell loadDataWithModel:_hotelDetailModel];
            return cell;
        }
    }
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJBDCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJBDCell1"];
        ZJBDCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJBDCell1"];
        [cell loadDataWithModel:_hotelDetailModel];
        return cell;
    }
    
    if (indexPath.row == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell5"];
        ZJFoodCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell5"];
        cell.mlab_title.text = [NSString stringWithFormat:@"来自%@位用户的评价",_hotelDetailModel.mHcommentCount];
        return cell;
    }

    [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell6" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell6"];
    ZJFoodCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell6"];
    [cell loadHotelDataWithModel:self.mAllComments[indexPath.row - 2]];
//    if(self.mAllComments && self.mAllComments.count >0){
//          [cell loadHotelDataWithModel:self.mAllComments[0]];
//    }

    return cell;
    
}
@end
