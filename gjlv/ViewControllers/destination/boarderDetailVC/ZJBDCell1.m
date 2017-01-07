//
//  ZJBDCell1.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJBDCell1.h"
#import "ZJBCollectionCell.h"
@implementation ZJBDCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mInfoCollectionView.delegate = (id)self;
    self.mInfoCollectionView.dataSource = (id)self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[]; //@[@"免费WIFI",@"免费停车场",@"接送机",@"免费WIFI",@"电梯",@"餐厅",@"行李寄存",@"24小时服务",@"热水壶"];
    }
    return _mDataSoure;
}
-(void)loadDataWithModel:(ZJHotelDetialModel *)model{
    if (model && model.mHfacilities) {
        self.mDataSoure = model.mHfacilities;
        [self.mInfoCollectionView reloadData];
        int i = self.mDataSoure.count/2;
        [self.mInfoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35*i);
        }];
    }
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
    return CGSizeMake(collectionView.frame.size.width/2,  35);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJBCollectionCell";
    [collectionView registerNib:[UINib nibWithNibName:@"ZJBCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJBCollectionCell"];
    
    ZJBCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    NSDictionary *info = self.mDataSoure[indexPath.row];
    [cell.mTitle setText:info[@"fname"]];
    NSString *str =  info[@"icon"];
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    [cell.mIMG sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];

    
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
