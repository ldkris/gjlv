//
//  ZJGSelectLeaderVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/16.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJGSelectLeaderVC.h"
#import "RFLayout.h"
#import "ZJGSelectLenderCell.h"
#import "ZJGLeaderDetailVC.h"
#import "ZJChatVC.h"
@interface ZJGSelectLeaderVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJGSelectLeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    RFLayout * layout = [[RFLayout alloc]init];
    [self.mInfoTableView  setCollectionViewLayout:layout];
//    self.mInfoTableView.pagingEnabled = YES
    
    self.title = @"选择领队";
    
    [self getLeaderList];
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
#pragma mark networking
-(void)getLeaderList{
    NSDictionary *paraDic = @{@"userId":ZJ_UserID,@"pageIndex":@"1",@"pageSize":@"10"};
    [HttpApi getAllLeaders:paraDic SuccessBlock:^(id responseBody) {
        
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJLeaderDetailModel class] fromJSONArray:responseBody[@"leaders"] error:&error];
        if (!error) {
            [self.mDataSoure addObjectsFromArray:temp];
            [self.mInfoTableView reloadData];
             self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@/%lu",@"1",(unsigned long)self.mDataSoure.count] style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark public
-(void)BackInfoWithBlock:(void (^)(ZJLeaderDetailModel *))block{
    self.backInfo = block;
}
#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, MainScreenFrame_Height - 200);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJGSelectLenderCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJGSelectLenderCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJGSelectLenderCell"];
    
    ZJGSelectLenderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    [cell loadDataWithModel:self.mDataSoure[indexPath.row]];
    [cell onclickSelectBn:^(UIButton *sender) {
        [[ZJAlertView shareSheet]showTitle:@"确认选择该领队？" cancelTitle:@"取消" comfirTitle:@"确定" cancelBlock:^(UIButton *sender) {
        
            
        } comfirBlock:^(UIButton *sender) {
            ZJLeaderDetailModel *temp = self.mDataSoure[indexPath.row];
            if (self.backInfo) {
                self.backInfo(temp);
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            if (temp.mmobile) {
                NSString *chatter = [@"leader_"stringByAppendingString:temp.mmobile];
                if (chatter) {
                    ZJChatVC *viewController = [[ZJChatVC alloc] initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
                    viewController.title = temp.mnickname;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
         
        }];
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{


}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJGLeaderDetailVC *tempVC = [[ZJGLeaderDetailVC alloc]init];
    tempVC.mSeleModel = self.mDataSoure[indexPath.row];
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / 300 + 1;
    if (page >0) {
         self.navigationItem.rightBarButtonItem.title =[NSString stringWithFormat:@"%d/%lu",page,(unsigned long)self.mDataSoure.count];
    }
}
@end
