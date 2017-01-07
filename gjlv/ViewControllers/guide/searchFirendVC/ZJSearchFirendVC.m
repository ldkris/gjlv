//
//  ZJSearchFirendVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/17.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSearchFirendVC.h"
#import "ZJGAounrdCarCell.h"
@interface ZJSearchFirendVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;

@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJSearchFirendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加车友";
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark geter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJGAounrdCarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJGAounrdCarCell"];
    ZJGAounrdCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJGAounrdCarCell"];
    [cell loadDataSoureWithDic:self.mDataSoure[indexPath.row]];
     __weak typeof(self) weakself = self;
    [cell onclickAddFWithBlock:^(UIButton *sender) {
        NSDictionary *dic = weakself.mDataSoure[indexPath.row];
        NSString *mID;
        int type = [dic[@"type"] intValue];
        if (type == 1) {
            // 用户
            mID = [@"user_"stringByAppendingString:dic[@"mobile"]];
        }else{
            mID = [@"leader_"stringByAppendingString:dic[@"mobile"]];
        }
        [[EMClient sharedClient].contactManager addContact:mID message:@"" completion:^(NSString *aUsername, EMError *aError) {
            if (aError) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSDictionary *mparaDic = @{@"userId":ZJ_UserID,@"text":textField.text,@"pageIndex":@"1",@"pageSize":@"10"};
    [HttpApi searchPeople:mparaDic SuccessBlock:^(id responseBody) {
        
        [self.mDataSoure addObjectsFromArray:responseBody[@"peoples"]];
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    return YES;
}
@end
