//
//  ZJMenuAlertview.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMenuAlertview.h"
#import "ZJGlobalCell.h"
#import "ZJCycleLayout.h"
@interface ZJMenuAlertview()
@property(nonatomic,retain)NSArray *mTitleArray;
@property(nonatomic,retain)NSArray *mImgArray;
@end
@implementation ZJMenuAlertview
+ (instancetype)shareSheet{
    static id shareSheet;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareSheet = [[[self class] alloc] init];
        
    });
    return shareSheet;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSheetWindow];
    }
    return self;
}

- (void)initSheetWindow{
    _sheetWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, MainScreenFrame_Height)];
    _sheetWindow.windowLevel = UIWindowLevelStatusBar;
//    _sheetWindow.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    _sheetWindow.hidden = NO;
    
    _bgView = [[UIView alloc]init];
    [_bgView setBackgroundColor:[UIColor clearColor]];
    [_bgView setFrame:_sheetWindow.frame];
    [_sheetWindow addSubview:_bgView];

    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.delegate = (id)self;
    [_bgView addGestureRecognizer:_tapGesture];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // 磨砂效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        // 磨砂视图
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [_blurEffectView.layer setMasksToBounds:YES];
        [_blurEffectView.layer setCornerRadius:5.0f];
        [_blurEffectView setFrame:CGRectMake(0, 0, 300, 300) ];
        [_blurEffectView setCenter:_sheetWindow.center];
        [_sheetWindow addSubview:_blurEffectView];
        
    } else {
        // 屏幕截图 - 调用苹果官方框架实现磨砂效果
        _blurEffectView = [[UIView alloc] init];
        [_blurEffectView.layer setMasksToBounds:YES];
        [_blurEffectView.layer setCornerRadius:5.0f];
        [_blurEffectView setFrame:CGRectMake(0, 0, 300, 300) ];
        [_blurEffectView setCenter:_sheetWindow.center];
        [_sheetWindow addSubview:_blurEffectView];
    }
   
    //创建一个layout布局类
    ZJCycleLayout * layout = [[ZJCycleLayout alloc]init];
    layout.itemCount = self.mTitleArray.count;
    _mInfoCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 8, 280, 300) collectionViewLayout:layout];
    [_mInfoCollectView setBackgroundColor:[UIColor clearColor]];
    _mInfoCollectView.delegate = (id)self;
    _mInfoCollectView.dataSource = (id)self;
    [_blurEffectView addSubview:_mInfoCollectView];
}
#pragma mark getter
-(NSArray *)mTitleArray{
    if (_mTitleArray == nil) {
        _mTitleArray = [NSArray array];
    }
    return _mTitleArray;
}
-(NSArray *)mImgArray{
    if (_mImgArray == nil) {
        _mImgArray = [NSArray array];
    }
    return _mImgArray;
}
#pragma mark event response
-(void)SingleTap:(UITapGestureRecognizer *)sender{
    [self tempDismiss];
}
#pragma mark privtae
-(void)tempshow{
    if (_sheetWindow == nil) {
        [self initSheetWindow];
    }
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.2; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.1]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率
    
    // 添加动画
    [_blurEffectView.layer addAnimation:animation forKey:@"scale-layer"];
    
    _sheetWindow.hidden = NO;
}
-(void)tempshowTitleS:(NSArray *)titleArray andImages:(NSArray *)imgArray Block:(void(^)(NSIndexPath *index))block{
    if (_sheetWindow == nil) {
        [self initSheetWindow];
    }
        
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.2; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.1]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率
    
    // 添加动画
    [_blurEffectView.layer addAnimation:animation forKey:@"scale-layer"];
    
    self.selectIndex = block;
    self.mTitleArray = titleArray;
    self.mImgArray = imgArray;
    [self.mInfoCollectView reloadData];
    _sheetWindow.hidden = NO;
}
-(void)tempDismiss{
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.2; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.1]; // 结束时的倍率
    
    // 添加动画
    [_blurEffectView.layer addAnimation:animation forKey:@"scale-layer"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _sheetWindow.hidden = YES;
        _sheetWindow = nil;
    });
    
}
#pragma mark public
+(void)showWithTitleS:(NSArray *)titleArray andImages:(NSArray *)imgArray Block:(void (^)(NSIndexPath *))block{

    [[self shareSheet] tempshowTitleS:titleArray andImages:imgArray Block:block];
}
+(void)show{
    [[self shareSheet] tempshow];
}
+(void)dismiss{
    [[self shareSheet] tempDismiss];
}
#pragma mark UICollectionViewDatasoure

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mTitleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerNib:[UINib nibWithNibName:@"ZJGlobalCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJGlobalCell"];
    ZJGlobalCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJGlobalCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    [cell.mTitle  setText:self.mTitleArray[indexPath.row]];
    if (indexPath.row < self.mImgArray.count) {
        [cell.mImageView setImage:[UIImage imageNamed:self.mImgArray[indexPath.row]]];
    }
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
