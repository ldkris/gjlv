//
//  ZJGAounrdCarVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGAounrdCarVC.h"
#import "ZJGAounrdCarCell.h"
@interface ZJGAounrdCarVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJGAounrdCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"附近车友";
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    [self getNearbyUsers];
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}

#pragma mark netWorking
-(void)getNearbyUsers{
    NSString *latStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude];
    [[ZJNetWorkingHelper shareNetWork]getNearbyUsers:@{@"userId":ZJ_UserID,@"destId":@"1",@"lat":latStr,@"lng":lngStr,@"pageIndex":@"1",@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJNearUserModel class] fromJSONArray:responseBody[@"users"] error:&error];
        self.mDataSoure = [NSMutableArray arrayWithArray:tempArray];
        
        [self.mInfoTableView reloadData];        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJGAounrdCarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJGAounrdCarCell"];
    ZJGAounrdCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJGAounrdCarCell"];
   
  
    [cell loadDataSoure:self.mDataSoure[indexPath.row]];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
