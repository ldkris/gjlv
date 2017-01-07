//
//  ZJMyInfoVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyInfoVC.h"
#import "ZJMHeadCell.h"
#import "ZJMyinfoCell.h"

#import "ZJInPutVC.h"
@interface ZJMyInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mInfoTbaleView;
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation ZJMyInfoVC{

    NSString *_headImageStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的信息";
    
    self.mInfoTbaleView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTbaleView.estimatedRowHeight = 100;
    self.mInfoTbaleView.tableFooterView = [UIView new];
    [self.mInfoTbaleView setBackgroundColor:[UIColor whiteColor]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"",@"姓名",@"呢称",@"手机号码",@"性别",@"车型",@"车牌号",@"车龄",@"累计驾驶里程",@"最长驾驶里程",@"现有通讯设备",@"自驾经历"];
    }
    return _mDataSoure;
}
#pragma mark networking
-(void)getInfo{
    [[ZJNetWorkingHelper shareNetWork]mGetMyInfo:@{@"userId":ZJ_UserID} SuccessBlock:^(id responseBody) {
        NSError *error;
        ZJUserInfoModel *userModel = [MTLJSONAdapter modelOfClass:[ZJUserInfoModel class] fromJSONDictionary:responseBody error:&error];
        [ZJSingleHelper shareNetWork].mUserInfo = userModel;
        [self.mInfoTbaleView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma  mark event respnose
- (IBAction)onlcikXJBtn:(id)sender {
    
    UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [mActionSheet showInView:self.view];
    
}
#pragma mark private
//上传
-(void)upHeadImage:(NSData *)imageData{
    [HttpApi getUptoken:@{@"type":@"1",@"userId":ZJ_UserID} SuccessBlock:^(id responseBody) {
        _headImageStr= responseBody[@"fname"];
        NSString *uptokenStr = responseBody[@"uptoken"];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        QNUploadOption *upoPtion = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showProgress:percent maskType:SVProgressHUDMaskTypeGradient];
        }];
        [upManager putData:imageData key:_headImageStr token:uptokenStr complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (resp) {
                LDLOG(@"%@", info);
                LDLOG(@"%@", resp);
//                [SVProgressHUD dismiss];
                [self saveInfoWithNetWorkingHeadUrl:_headImageStr];
            }else{
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
            }
            
        } option:upoPtion];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)saveInfoWithNetWorkingHeadUrl:(NSString *)url{
    [[ZJNetWorkingHelper shareNetWork]mPutMyInfo:@{@"userId":ZJ_UserID,@"headImgUrl":url} SuccessBlock:^(id responseBody) {
//        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"成功"];
        [self getInfo];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJMHeadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJMHeadCell"];
        ZJMHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJMHeadCell"];
        [cell.mIMG sd_setImageWithURL:[NSURL URLWithString:[ZJSingleHelper shareNetWork].mUserInfo.mHeadImgUrl] placeholderImage:[UIImage imageNamed:@"dd_def.png"] options:EMSDWebImageRefreshCached];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJMyinfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJMyinfoCell"];
    ZJMyinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJMyinfoCell"];
    cell.mLab_Title.text = self.mDataSoure[indexPath.row];
//    cell.mLab_subTitle.text = self.mDataSoure[indexPath.row];
    [cell loadDataIndexpath:indexPath model:[ZJSingleHelper shareNetWork].mUserInfo];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [mActionSheet showInView:self.view];
        return;
    }
    ZJMyinfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ZJInPutVC *mTempVC = [[ZJInPutVC alloc]init];
    mTempVC.title = cell.mLab_Title.text;
    mTempVC.indexPath = indexPath;
    [self.navigationController pushViewController:mTempVC animated:YES];
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
        NSData *imageData = UIImagePNGRepresentation(edit);
        ZJMHeadCell *cell = [self.mInfoTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            cell.mIMG.image = [UIImage imageWithData:imageData];
             [self upHeadImage:imageData];
        }];
    }else{
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        NSData *imageData = UIImagePNGRepresentation(edit);
        ZJMHeadCell *cell = [self.mInfoTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            cell.mIMG.image = [UIImage imageWithData:imageData];
             [self upHeadImage:imageData];
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

@end
