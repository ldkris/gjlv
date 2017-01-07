//
//  shareInviteCodeVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "shareInviteCodeVC.h"
#import "ZJShareCell.h"
@interface shareInviteCodeVC ()
@property (weak, nonatomic) IBOutlet UILabel *mlab_inCodel;
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation shareInviteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友邀请";
    if (self.mSelectmodel) {
        self.mlab_inCodel.text = [NSString stringWithFormat:@"邀请码：%@",self.mSelectmodel.minviteCode];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"微信",@"微信朋友圈",@"QQ",@"QQ空间"];
    }
    return _mDataSoure;
}

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/4, 80);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJShareCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJShareCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJShareCell"];
    
    ZJShareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    
    cell.mLab_title.text = self.mDataSoure[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        
    }];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
