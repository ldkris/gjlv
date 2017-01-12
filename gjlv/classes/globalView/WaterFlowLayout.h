//
//  WaterFlowLayout.h
//  WaterFlowDemo
//
//  Created by 薛豪东 on 2016/11/21.
//  Copyright © 2016年 NJQY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) NSInteger defaultColumnCount;

@property (nonatomic,assign) CGFloat defaultColumnSpacing;

@property (nonatomic,assign) CGFloat defaultRowSpacing;

@property (nonatomic,assign) UIEdgeInsets itemInsects;

@end
