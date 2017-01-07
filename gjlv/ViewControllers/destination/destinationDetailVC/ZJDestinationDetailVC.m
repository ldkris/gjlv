//
//  ZJDestinationDetailVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/2.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJDestinationDetailVC.h"
#import "ZJDDestinationCell.h"
#import "ZJDDHeadCell.h"

#import "ZJTrafficVC.h"
#import "ZJAroundCarVC.h"
#import "ZJFoodVC.h"
#import "ZJAroundScenicVC.h"
#import "ZJBoarderVC.h"
#import "ZJDDetailVC.h"
#import "ZJSendPhotoVC.h"

#import <UIKit/UIKit.h>
@interface ZJDestinationDetailVC ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJDestinationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 下拉刷新
    self.mInfoCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mDataSoure removeAllObjects];
        self.pageIndex = 1;
        [self getSceneList];

    }];
    [self.mInfoCollectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.mInfoCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getSceneList];
    }];
    // 默认先隐藏footer
    self.mInfoCollectionView.mj_footer.hidden = YES;
    
   // [self getDestDetail];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.hidden = NO;
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
     self.view.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma makr getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark networking
-(void)getDestDetail{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"destId":self.mSelectModel.mdestId};
    [[ZJNetWorkingHelper shareNetWork]getDestDetail:mParamDic SuccessBlock:^(id responseBody) {
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getSceneList{
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"destId":self.mSelectModel.mdestId,@"lng":[NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude],@"lat":[NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude],@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]};
    [[ZJNetWorkingHelper shareNetWork]getSceneList:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJSceneListModel class] fromJSONArray:responseBody[@"scenes"] error:&error];
        if (temp.count == 0 && self.pageIndex>1) {
            [self.mInfoCollectionView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        if (!error) {
            [self.mDataSoure addObjectsFromArray:temp];
            if (self.pageIndex == 1) {
                [self.mInfoCollectionView.mj_header endRefreshing];
            }else{
                
                [self.mInfoCollectionView.mj_footer endRefreshing];
            }
            self.pageIndex++;
        }else{
            [self.mInfoCollectionView.mj_header endRefreshing];
            [self.mInfoCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.mInfoCollectionView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickCollectBrn:(id)sender {
    
   
}
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickShareBtn:(id)sender {
    NSDictionary *mParamDic = @{@"userId":ZJ_UserID,@"destId":[self.mSelectModel.mdestId stringValue]};
    [[ZJNetWorkingHelper shareNetWork]putDest:mParamDic SuccessBlock:^(id responseBody) {
        ShowMSG(responseBody[@"respMsg"]);
    } FailureBlock:^(NSError *error) {
        
    }];
}
- (IBAction)onclickAddBtn:(id)sender {
    [ZJMenuAlertview showWithTitleS:@[@"住宿",@"美食",@"周边车友",@"目的地景点",@"周边景点"] andImages:@[@"dd_zs",@"dd_ms",@"dd_cy",@"dd_cy",@"dd_jdjs"]  Block:^(NSIndexPath *index) {
        LDLOG(@"选择 ====== %ld",index.row);
        [ZJMenuAlertview dismiss];
        if (index.row == 4) {
            //周边景点
            ZJAroundScenicVC *mTempVC = [[ZJAroundScenicVC alloc]init];
            mTempVC.title = @"周边景点";
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
        
        if (index.row == 2) {
            //周边车友
            ZJAroundCarVC *mTempVC = [[ZJAroundCarVC alloc]init];
            mTempVC.mSelectModel = self.mSelectModel;
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
//        if (index.row == 3) {
//            //实时路况
//            ZJTrafficVC *mTempVC = [[ZJTrafficVC alloc]init];
//             //mTempVC.mSelectModel = self.mSelectModel;
//            [self.navigationController pushViewController:mTempVC animated:YES];
//        }
        if (index.row == 1) {
            //美食
            ZJFoodVC *mTempVC = [[ZJFoodVC alloc]init];
            mTempVC.mSelectModel = self.mSelectModel;
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
        if (index.row == 0) {
            //住宿
            ZJBoarderVC *mTempVC = [[ZJBoarderVC alloc]init];
             mTempVC.mSelectModel = self.mSelectModel;
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
    
        if (index.row == 3) {
            //景点介绍
            ZJAroundScenicVC *mTempVC = [[ZJAroundScenicVC alloc]init];
            mTempVC.mSelectModel = self.mSelectModel;
            mTempVC.title = @"目的地景点";
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
        
    }];
}
- (IBAction)onlcikXJBtn:(id)sender {
    
    UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [mActionSheet showInView:self.view];
    
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            //相册
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                ShowMSG(@"您的设备不支持图库");
            }
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                ShowMSG(@"您的设备不支持相册");
            }
            UIImagePickerController *mImagePickerVC = [[UIImagePickerController alloc]init];
            [mImagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            mImagePickerVC.delegate = (id)self;
//            mImagePickerVC.allowsEditing = YES;
            [self presentViewController:mImagePickerVC animated:YES completion:nil];
            break;}
            
        case 1:{
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                ShowMSG(@"您的设备不支持相机");
                return;
            }
            UIImagePickerController *mImagePickerVC = [[UIImagePickerController alloc]init];
            mImagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            mImagePickerVC.delegate = (id)self;
//            mImagePickerVC.allowsEditing = YES;
            [self presentViewController:mImagePickerVC animated:YES completion:nil];
            //相机
            break;}
            
        default:
            break;
    }
}
#pragma mark UIImagePickerControllerDelegate
//成功获得相片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if (([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) | UIImagePickerControllerSourceTypeSavedPhotosAlbum ) {
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* edit1 = [MyFounctions imageCompressForWidth:edit targetWidth:MainScreenFrame_Width];
        NSData *imageData = UIImagePNGRepresentation(edit1);
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            ZJSendPhotoVC *TempVC = [[ZJSendPhotoVC alloc]init];
            TempVC.mPhotoData = imageData;
            TempVC.mSelectModel = self.mSelectModel;
            [self.navigationController pushViewController:TempVC animated:NO];
        }];
    }else{
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        NSData *imageData = UIImagePNGRepresentation(edit);
        UIImage* edit1 = [MyFounctions imageCompressForWidth:edit targetWidth:MainScreenFrame_Width];
        NSData *imageData = UIImagePNGRepresentation(edit1);
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            self.view.hidden = YES;
            ZJSendPhotoVC *TempVC = [[ZJSendPhotoVC alloc]init];
            TempVC.mPhotoData = imageData;
            TempVC.mSelectModel = self.mSelectModel;
            [self.navigationController pushViewController:TempVC animated:NO];
           
        }];
    }
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //模态方式退出uiimagepickercontroller
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    NSLog(@"saved..");
}
#pragma mark UICollectionViewDataSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     collectionView.mj_footer.hidden = self.self.mDataSoure.count == 0;
    return self.mDataSoure.count + 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        int CellW = collectionView.frame.size.width;
        
        return CGSizeMake(CellW,  200);
    }
    int CellW = collectionView.frame.size.width /2 - 0.5;
    
    return CGSizeMake(CellW , CellW + 20);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        static NSString * SLCellIdentifier = @"ZJDDHeadCell";
        
        [collectionView registerNib:[UINib nibWithNibName:@"ZJDDHeadCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDDHeadCell"];
        
        ZJDDHeadCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
        
        [cell loadCellWithModel:self.mSelectModel];
        
        //    [cell setBackgroundColor:[UIColor redColor]];
        
        return cell;
    }
    
    static NSString * SLCellIdentifier = @"ZJDDestinationCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJDDestinationCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJDDestinationCell"];
    
    ZJDDestinationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    if (  self.mDataSoure.count > 0) {
        [cell loadCellWithModel:self.mDataSoure[indexPath.row - 1 ]];
    }
    return cell;
}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    ZJDDetailVC *tempVC =[[ZJDDetailVC alloc]init];
    tempVC.mSelectModel = self.mDataSoure[indexPath.row - 1];
    tempVC.mSelectDesModel = self.mSelectModel;
    [self.navigationController pushViewController:tempVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = BG_Yellow;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((64 - offsetY) / 64);
        self.mNavView.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        self.mNavView.backgroundColor = [color colorWithAlphaComponent:0];
    }
}
@end
