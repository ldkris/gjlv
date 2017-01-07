//
//  ZJCommDetailVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCommDetailVC.h"
#import "ZJFoodCell1.h"
#import "ZJFoodCell2.h"
#import "ZJFoodCell3Cell.h"
#import "ZJFoodCell4.h"
#import "ZJFoodCell5.h"
#import "ZJFoodCell6.h"

#import "ZJCommentVC.h"
@interface ZJCommDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain) NSMutableArray *mAllComments;
@end

@implementation ZJCommDetailVC{
    ZJDelicacyDetailModel *_mDelicacyModel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    [self getDelicacyDetail];
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
#pragma mark networking
-(void)getDelicacyDetail{
    [SVProgressHUD show];
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"did":[self.mSelectModel.mdid stringValue]};
    [HttpApi getDelicacyDetail:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        ZJDelicacyDetailModel *model = [MTLJSONAdapter modelOfClass:[ZJDelicacyDetailModel class] fromJSONDictionary:responseBody error:&error];
        _mDelicacyModel = model;
        [self getDelicacyAllComments];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getDelicacyAllComments{
    [HttpApi getDelicacyCommentList:@{@"userId":ZJ_UserID,@"did":[self.mSelectModel.mdid stringValue],@"pageIndex":@"1",@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJHotelCommentModel class] fromJSONArray:responseBody[@"comments"] error:&error];
        [self.mAllComments addObjectsFromArray:tempArray];
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
    tempVC.model = self.mSelectModel;
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",APPName,@"GJLV001",[_mSelectModel.mlat floatValue], [_mSelectModel.mlng floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];}

            break;
        case 0:{
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", [_mSelectModel.mlng floatValue],[_mSelectModel.mlng floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        return 6.0f;
    }
    return 1+self.mAllComments.count;
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
            [cell loadDataSoureWithModel:_mDelicacyModel];
            return cell;
        }
        
        if (indexPath.row == 1) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell2"];
            ZJFoodCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell2"];
            [cell loadDataSoureWithModel:_mDelicacyModel];
            [cell onlickCallPhoneBlock:^(UIButton *sender) {
                [MyFounctions callPhone:_mDelicacyModel.mphone];
            }];
            return cell;
        }
        
        if (indexPath.row == 2) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell3Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell3Cell"];
            ZJFoodCell3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell3Cell"];
            if (_mDelicacyModel) {
                CLLocationCoordinate2D coor;
                coor.latitude = [_mDelicacyModel.mlat floatValue];
                coor.longitude = [_mDelicacyModel.mlng floatValue];
                [cell loadlocWithlonlat:coor];
            }
            [cell onclickNavigationgBlock:^(UIButton *sender) {
                UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择导航" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度导航",@"高德导航", nil];
                [mActionSheet showInView:self.view];
            }];
            return cell;
        }
        
        if(indexPath.row>=3 && indexPath.row<=5){
            
            [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell4" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell4"];
            ZJFoodCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell4"];
            [cell loadDelDataWithMdel:_mDelicacyModel indexPath:indexPath];
            return cell;
        }
    }
    
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell5" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell5"];
        ZJFoodCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell5"];
        cell.mlab_title.text = [NSString stringWithFormat:@"来自%@位用户的评价",_mDelicacyModel.mtotalNum];
         return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJFoodCell6" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJFoodCell6"];
    ZJFoodCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJFoodCell6"];
    [cell loadHotelDataWithModel:self.mAllComments[indexPath.row - 1]];
    return cell;
    
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
@end
