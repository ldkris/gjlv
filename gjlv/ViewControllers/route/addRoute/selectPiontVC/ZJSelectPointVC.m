//
//  ZJSelectPointVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/10.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSelectPointVC.h"
#import "ZJDSearchCell.h"
#import "ZJSearchPointVC.h"

@interface ZJSelectPointVC ()
@property (weak, nonatomic) IBOutlet UIButton *mSearchBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCllectionView;

@end

@implementation ZJSelectPointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mSearchBtn.layer setMasksToBounds:YES];
    [self.mSearchBtn.layer setCornerRadius:5.0f];
    [self.mSearchBtn.layer setBorderColor:[SL_GRAY_Hard CGColor]];
    [self.mSearchBtn.layer setBorderWidth:0.5f];
    
    self.title = @"自定义路线规划";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark public
-(void)backInfoBlock:(void (^)(id))block{
    self.backBlock = block;
}
#pragma mark event response
- (IBAction)onclickSearchBtn:(id)sender {
    
    ZJSearchPointVC *tempVC = [[ZJSearchPointVC alloc]init];
    [tempVC backInfoBlock:^(BMKPoiInfo *info) {
        [sender setTitle:info.name forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
        self.backBlock(info);
    }];
    [self.navigationController pushViewController:tempVC animated:YES];
}

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = collectionView.frame.size.width /3;
    
    return CGSizeMake(CellW, 60);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SLCellIdentifier = @"ZJDSearchCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDSearchCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDSearchCell"];
    
    ZJDSearchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    //    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.backBlock) {
        self.backBlock(indexPath);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
