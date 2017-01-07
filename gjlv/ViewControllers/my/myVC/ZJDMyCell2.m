//
//  ZJDMyCell2.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDMyCell2.h"
#import "ZJDMyCollectViewCell.h"
@interface ZJDMyCell2()
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)NSArray *mIMGDataSoure;
@property(nonatomic,retain)NSArray *mSubTitles;
@end
@implementation ZJDMyCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mInfoCollectionView.delegate = (id)self;
    self.mInfoCollectionView.dataSource = (id)self;
    self.mInfoCollectionView.scrollEnabled = NO;
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"我的收藏",@"我的足迹",@"我的领队",@"设置"];
    }
    return _mDataSoure;
}
-(NSArray *)mIMGDataSoure{
    if (_mIMGDataSoure == nil) {
        _mIMGDataSoure = @[@"my_sc",@"my_zj",@"my_ld",@"my_setting"];
    }
    return _mIMGDataSoure;
}
-(NSArray *)mSubTitles{
    if (_mSubTitles == nil) {
        _mSubTitles = @[@"目的地",@"123123公里",@"",@""];
    }
    return _mSubTitles;
}
#pragma mark UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = collectionView.frame.size.width /2;
    
    return CGSizeMake(CellW-5, 100);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SLCellIdentifier = @"ZJDMyCollectViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDMyCollectViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDMyCollectViewCell"];
    
    ZJDMyCollectViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    cell.mLab_title.text = self.mDataSoure[indexPath.row];
    [cell.mImageView setImage:[UIImage imageNamed:self.mIMGDataSoure[indexPath.row]]];
    cell.mSub_title.text = self.mSubTitles[indexPath.row];
    
    //    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex(indexPath);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)onclickSelectIdex:(void (^)(NSIndexPath *))balock{
    self.selectIndex= balock;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
