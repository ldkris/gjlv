//
//  ZJDTableviewCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDTableviewCell.h"
#import "ZJDCollectCell.h"
@implementation ZJDTableviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mCollectionView.delegate = (id)self;
    self.mCollectionView.dataSource = (id)self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)selecIndex:(void (^)(NSIndexPath *))block{
    self.selectIndex = block;
}
-(void)loadDataWithModel:(ZJDestModel *)model{
    
}
#pragma mark UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = collectionView.frame.size.width /2;
    
    return CGSizeMake(CellW-5, 90);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SLCellIdentifier = @"ZJDCollectCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDCollectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDCollectCell"];
    
    ZJDCollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    
//    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex) {
        self.selectIndex(indexPath);
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
