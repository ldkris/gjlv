//
//  ZJFoodCell6.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJFoodCell6.h"
#import "ZJDDCollectionViewCell.h"
@implementation ZJFoodCell6{
    NSArray *_imgs;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mInfoCollectionView.delegate = (id)self;
    self.mInfoCollectionView.dataSource = (id)self;
    
    self.mimg_head.layer.masksToBounds = YES;
    self.mimg_head.layer.cornerRadius = self.mimg_head.frame.size.height/2;
    
    _imgs = @[];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadHotelDataWithModel:(ZJHotelCommentModel *)model{
    if(model == nil){
        return;
    }
    [self.mimg_head sd_setImageWithURL:[NSURL URLWithString:model.mheadPhoto] placeholderImage:nil];
    self.mlab_name.text = model.muname;
    self.mlab_time.text = model.mcreateTime;
    self.mlab_content.text = model.mcontent;

    if (model.mphotos && model.mphotos.length>0) {
        NSArray *temp = [model.mphotos componentsSeparatedByString:NSLocalizedString(@",", nil)];
        _imgs  = temp;
    }else{
        [self.mInfoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imgs.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80,  collectionView.frame.size.height - 10);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJDDCollectionViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDDCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDDCollectionViewCell"];
    
    ZJDDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:_imgs[indexPath.row]] placeholderImage:nil];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
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
