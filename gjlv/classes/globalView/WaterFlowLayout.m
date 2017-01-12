//
//  WaterFlowLayout.m
//  WaterFlowDemo
//
//  Created by 薛豪东 on 2016/11/21.
//  Copyright © 2016年 NJQY. All rights reserved.
//

#import "WaterFlowLayout.h"


@interface WaterFlowLayout()

@property (nonatomic,strong) NSMutableArray *attrArray;

@property (nonatomic,strong) NSMutableArray *maxArray;
@end

@implementation WaterFlowLayout

- (NSMutableArray *)attrArray{
    if (!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (NSMutableArray *)maxArray{
    if (!_maxArray) {
        _maxArray = [NSMutableArray array];
    }
    return _maxArray;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _defaultColumnCount = 2;
        _defaultColumnSpacing = 5;
        _defaultRowSpacing = 5;
        _itemInsects = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

#pragma mark -
- (void)prepareLayout{
    [super prepareLayout];
    
    [self.attrArray removeAllObjects];
    [self.maxArray removeAllObjects];
    
    
    for (NSInteger i=0; i<_defaultColumnCount; i++) {
        [self.maxArray addObject:@(_itemInsects.top)];
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i=0; i<itemCount; i++) {
        
        if (i == 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                [attributes setFrame:CGRectMake(0, 0, MainScreenFrame_Width, 200)];
            [self.attrArray addObject:attributes];
        }else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.attrArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    NSInteger __block minHeightColumn = 0;
    NSInteger __block minHeight = [self.maxArray[minHeightColumn] floatValue];
    
    [self.maxArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        if (minHeight > columnHeight) {
            minHeight = columnHeight;
            minHeightColumn = idx;
        }
        
    }];

        CGFloat x;
        CGFloat y;
        CGFloat width;
        CGFloat height;
        
        height = 100+arc4random_uniform(100);
        width = (MainScreenFrame_Width - _itemInsects.right - _itemInsects.left - _defaultColumnSpacing *(_defaultColumnCount-1))/2;
        
        x = _itemInsects.left + minHeightColumn * (width + _defaultColumnSpacing);
    
        if (indexPath.row == 1 ||indexPath.row == 2) {
            y = minHeight+197;
        } else {
            y = minHeight;
        }
    
        if (y != _itemInsects.top) {
            y += _defaultRowSpacing;
        }
        
        [attributes setFrame:CGRectMake(x, y, width, height)];
        self.maxArray[minHeightColumn] = @(CGRectGetMaxY(attributes.frame));
        return attributes;
    
   
}

- (CGSize)collectionViewContentSize{
    
    
    NSInteger __block MaxHeight = 0;
    
    [self.maxArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat columnHeight = [(NSNumber *)obj floatValue];
        
        
        if (MaxHeight < columnHeight) {
            MaxHeight = columnHeight;
        }
        
    }];

    return CGSizeMake(0, MaxHeight + _defaultRowSpacing);
}

@end
