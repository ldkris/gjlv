//
//  BaseLayout.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseLayout.h"

@implementation BaseLayout
//自定义布局必须YES
- (void)prepareLayout
{
    [super prepareLayout];
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置内边距
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
    
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds

{
    
    return YES;
    
}

//返回所有cell的布局属性
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect

{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray* attributes = [NSMutableArray array];
    
    for (NSInteger i=0 ; i < [array count]; i++) {
        if (i == 1) {
            
            NSIndexPath* indexPath1 = [NSIndexPath indexPathForItem:0 inSection:0];
            UICollectionViewLayoutAttributes *temp1 = [self layoutAttributesForItemAtIndexPath:indexPath1];
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *temp = [self layoutAttributesForItemAtIndexPath:indexPath];
            temp.frame = CGRectMake(0, temp1.frame.size.height +1, temp.frame.size.width, temp.frame.size.height);
            [attributes addObject:temp];
        }else{
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
        
    }
    
    return attributes;
    
}


@end
