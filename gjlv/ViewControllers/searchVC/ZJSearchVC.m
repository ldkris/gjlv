//
//  ZJSearchVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJSearchVC.h"
#import "ZJDSearchCell.h"
#import "ZJDestinationDetailVC.h"
#import "ZJSHeaderView.h"
#import "ZJSFoottView.h"
@interface ZJSearchVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectView;
@property(nonatomic,retain)NSArray *mHotList;
@property(nonatomic,retain)NSMutableArray *mHistoryList;
@property(nonatomic,retain)NSArray *mSearchReslut;
@end

@implementation ZJSearchVC{
    UITapGestureRecognizer*   mTap ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideZJTbar];
    [self.mNavView setBackgroundColor:BG_Yellow];
    //[self.mTF_input addTarget:self action:@selector(textField) forControlEvents:<#(UIControlEvents)#>]
    [self.mTF_input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self getHotSearchDestList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mHotList{
    if (_mHotList == nil) {
        _mHotList = [NSArray array];
    }
    return _mHotList;
}
-(NSArray *)mSearchReslut{
    if (_mSearchReslut == nil) {
        _mSearchReslut = [NSArray array];
    }
    return _mSearchReslut;
}
-(NSMutableArray *)mHistoryList{
    if (_mHistoryList == nil) {
        NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
        if (defalutData && defalutData.length>0) {
            NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
            NSMutableArray *mtempHis = [NSMutableArray arrayWithArray:ary];
            _mHistoryList = mtempHis;
            
        }else{
            _mHistoryList = [NSMutableArray array];
        }
    }
    
    return _mHistoryList;
}
#pragma mark networking
-(void)getHotSearchDestList{
    NSDictionary *paramDic = @{@"userId":ZJ_UserID};
    [[ZJNetWorkingHelper shareNetWork]getHotSearchDestList:paramDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJDestModel class] fromJSONArray:responseBody[@"dests"] error:&error];
        if (temp && temp.count>0) {
            self.mHotList  = temp;
            [self.mInfoCollectView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getDestList{
     NSDictionary *paramDic = @{@"userId":ZJ_UserID,@"dname":self.mTF_input.text,@"pageIndex":@"1",@"pageSize":@"10"};
    [[ZJNetWorkingHelper shareNetWork]getDestList:paramDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJDestModel class] fromJSONArray:responseBody[@"dests"] error:&error];
        if (!error) {
            self.mSearchReslut  = temp;
            [self.mInfoCollectView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
- (void)keyboardWillShow:(NSNotification *) notification{
//    [super keyboardWillShow:notification];
    
    if(mTap == nil){
        mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aResignFirstResponder)];
        mTap.delegate = (id)self;
        [self.view addGestureRecognizer:mTap];
    }
   
}
- (void)keyboardWillHide:(NSNotification *) notification{
//    [super keyboardWillHide:notification];
    [self.view removeGestureRecognizer:mTap];
    mTap = nil;
    
}

#pragma mark event response
-(void)aResignFirstResponder{

    [self.mTF_input resignFirstResponder];
}
- (void) textFieldDidChange:(UITextField *) sender {
    if ([sender.text isEqualToString:@""]||sender.text.length == 0) {
        self.mSearchReslut  = nil;
        [self.mInfoCollectView reloadData];
    }
}
- (IBAction)onclickBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.text.length ==0 || textField.text == nil) {
        ShowMSG(@"请输入关键字");
        return YES;
    }

    [self getDestList];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.mHistoryList = nil;
    [self.mInfoCollectView reloadData];
    return YES;
}
#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.mSearchReslut.count>0) {
        return 1;
    }
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.mSearchReslut.count>0) {
        return self.mSearchReslut.count;
    }
    
    if (section == 0) {
        return  self.mHotList.count;
    }
    return  self.mHistoryList.count;;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = collectionView.frame.size.width /3;

    return CGSizeMake(CellW, 60);
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.mSearchReslut.count>0) {
        CGSize size = {0, 0};
        return size;
    }
    CGSize size = {MainScreenFrame_Width, 50};
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.mSearchReslut.count>0) {
        CGSize size = {0, 0};
        return size;
    }
    CGSize size = {MainScreenFrame_Width, 10};
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.mSearchReslut.count>0) {
        return nil;
    }
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        [collectionView registerNib:[UINib nibWithNibName:@"ZJSHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:@"ZJSHeaderView"];
        
        ZJSHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZJSHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 1) {
            headerView.mlab_title.text = @"搜索历史";
            [headerView onclickDeleBtnWithBlock:^(UIButton *sender) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"history"];
                self.mHistoryList = nil;
                [self.mInfoCollectView reloadData];
            }];
            
        }else{
            headerView.mlab_title.text = @"热门搜索";
        }
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        [collectionView registerNib:[UINib nibWithNibName:@"ZJSFoottView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:@"ZJSFoottView"];
        
        ZJSFoottView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZJSFoottView" forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            [headerView setBackgroundColor:[UIColor clearColor]];
        }
        
        reusableview = headerView;
    }
    
    return reusableview;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SLCellIdentifier = @"ZJDSearchCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDSearchCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDSearchCell"];
    
    ZJDSearchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    if (self.mSearchReslut.count>0) {
        [cell loadDataSoureWith:self.mSearchReslut[indexPath.row]];
    }else{
        if (indexPath.section == 0) {
               [cell loadDataSoureWith:self.mHotList[indexPath.row]];
        }else{
            [cell loadDataSoureWith:self.mHistoryList[indexPath.row]];
        }
    }
//    [cell setBackgroundColor:[UIColor redColor]];
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mSearchReslut.count>0) {
        NSMutableArray *mtempHis;
        ZJDestModel*model = [self.mSearchReslut objectAtIndex:indexPath.row];
        NSData *defalutData = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
        if (defalutData && defalutData.length>0) {
            NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
            mtempHis = [NSMutableArray arrayWithArray:ary];
            if (mtempHis.count>=6) {
                [mtempHis replaceObjectAtIndex:0 withObject:model];
            }else{
                [mtempHis addObject:model];
            }
        }else{
             mtempHis = [NSMutableArray arrayWithObject:model];
        }

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mtempHis];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"history"];
        
        ZJDestinationDetailVC *tempVC = [[ZJDestinationDetailVC alloc]init];
        tempVC.mSelectModel = model;
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        if (indexPath.section == 0) {
            ZJDestModel*model = [self.mHotList objectAtIndex:indexPath.row];
            model.mdestId = model.mDid;
            ZJDestinationDetailVC *tempVC = [[ZJDestinationDetailVC alloc]init];
            tempVC.mSelectModel = model;
            [self.navigationController pushViewController:tempVC animated:YES];
        }else{
            ZJDestModel*model = [self.mHistoryList objectAtIndex:indexPath.row];
            ZJDestinationDetailVC *tempVC = [[ZJDestinationDetailVC alloc]init];
            tempVC.mSelectModel = model;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
