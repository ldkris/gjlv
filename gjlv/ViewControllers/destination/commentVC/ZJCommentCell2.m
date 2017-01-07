//
//  ZJCommentCell2.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCommentCell2.h"
#import "ZJCollectionViewCell.h"
@implementation ZJCommentCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mInfoCollectionView.dataSource = self;
    self.mInfoCollectionView.delegate = self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SelectBlock:(void (^)(NSIndexPath *))SelectBlock{
    self.SelectBlock = SelectBlock;
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray arrayWithObjects:@"", nil];
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJCollectionViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJCollectionViewCell"];
    
    ZJCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    id temp = self.mDataSoure[indexPath.row];
    if ([temp isKindOfClass:[UIImage class]]) {
        cell.mImageView.image = temp;
    }
    
    //    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.SelectBlock) {
        self.SelectBlock(indexPath);
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
