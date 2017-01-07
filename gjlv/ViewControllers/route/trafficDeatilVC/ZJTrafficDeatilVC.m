//
//  ZJTrafficDeatilVC.m
//  gjlv
//
//  Created by 刘冬 on 2017/1/6.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import "ZJTrafficDeatilVC.h"
#import "ZJTrafficeCellTableViewCell.h"
@interface ZJTrafficDeatilVC ()

@end

@implementation ZJTrafficDeatilVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self getTrafficDetail];
    
    self.mInfoTablView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTablView.estimatedRowHeight = 100;
    self.mInfoTablView.tableFooterView = [UIView new];
    [self.mInfoTablView  setBackgroundColor:[UIColor whiteColor]];
    
    [self.mInfoTablView registerNib:[UINib nibWithNibName:@"ZJTrafficeCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJTrafficeCellTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getTrafficDetail{

    if (self.mSelectModel) {
        NSString *latStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude];
        NSString *lngStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude];
        NSDictionary *mParaDic = @{@"userId":ZJ_UserID,@"trafficId":[self.mSelectModel.mtrafficId stringValue],@"lat":latStr,@"lng":lngStr};
        [[ZJNetWorkingHelper shareNetWork]getTrafficDetail:mParaDic SuccessBlock:^(id responseBody) {
            
        } FailureBlock:^(NSError *error) {
            
        }];
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
#pragma mark UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJTrafficeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJTrafficeCellTableViewCell"];
    [cell loadCellDataWith:self.mSelectModel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
@end
