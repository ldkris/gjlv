//
//  ZJDDCommentCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDDCommentCell.h"
#import "ZJDDCollectionViewCell.h"
@implementation ZJDDCommentCell{
    NSArray *_mDataSoure;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mInfoCollectionView.delegate = (id)self;
    self.mInfoCollectionView.dataSource = (id)self;
    
    _mDataSoure = @[];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellDataWithModel:(ZJSceneDetailModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_count.text = [model.mgoodCount stringValue];
    _mDataSoure = model.mgusers;
    [self.mInfoCollectionView reloadData];
}

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mDataSoure.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     return CGSizeMake(30,  30);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJDDCollectionViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDDCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDDCollectionViewCell"];
    ZJDDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    [cell loadCellDataWithDic:_mDataSoure[indexPath.row]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
