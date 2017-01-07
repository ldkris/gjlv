//
//  ZJCommentVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCommentVC.h"
#import "ZJCommentCell.h"
#import "ZJCommentCell1.h"
#import "ZJCommentCell2.h"
@interface ZJCommentVC ()
@property (weak, nonatomic) IBOutlet UITableView *minfoTableView;

@end

@implementation ZJCommentVC{
    NSString *_mMark;
    NSString *_mKWmark;
    NSString *_mHJMark;
    NSString *_mFWmark;
    NSString *_mContent;
    
    NSMutableString *_mPhotos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"写点评";
    
    UIButton *mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"t_btn_bg"] forState:UIControlStateNormal];
    [mRightBtn setFrame:CGRectMake(0, 0, 60, 25)];
    [mRightBtn addTarget:self action:@selector(onclickRight:) forControlEvents:UIControlEventTouchUpInside];
    [mRightBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:mRightBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.minfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.minfoTableView.estimatedRowHeight = 100;
    self.minfoTableView.tableFooterView = [UIView new];
    [self.minfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    _mPhotos = [NSMutableString string];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark event response
-(void)onclickRight:(UIButton *)sender{
    
    if (_mMark == nil) {
        ShowMSG(@"请评价！");
        return;
    }
    if (_mKWmark == nil) {
        ShowMSG(@"请评价口味！");
        return;
    }
    if (_mHJMark == nil) {
        ShowMSG(@"请评价环境！");
        return;
    }
    if (_mFWmark == nil) {
        ShowMSG(@"请评价服务！");
        return;
    }
    
    ZJCommentCell1 *cell = [self.minfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _mContent = cell.TF_input.text;
    if (_mContent == nil || _mContent.length == 0) {
        ShowMSG(@"请输入评价！");
        return;
    }
    
    if ([self.model isKindOfClass:[ZJDelicacyListModel class]]) {
        //美食评价
        ZJDelicacyListModel *tempModel = self.model;
        
        NSMutableDictionary *mparam = [NSMutableDictionary dictionary];
        [mparam setObject:ZJ_UserID forKey:@"userId"];
        [mparam setObject:tempModel.mdid forKey:@"did"];
        [mparam setObject:_mContent forKey:@"content"];
        [mparam setObject:_mMark forKey:@"score"];
        [mparam setObject:_mFWmark forKey:@"sscore"];
        [mparam setObject:_mHJMark forKey:@"escore"];
        if (_mPhotos && _mPhotos.length>0) {
            [mparam setObject:_mPhotos forKey:@"photos"];
        }
        [HttpApi  putDelicacyComment:mparam SuccessBlock:^(id responseBody) {
            [self.navigationController popViewControllerAnimated:YES];
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    
    if ([self.model isKindOfClass:[ZJHotelListModel class]]) {
        //住宿评价
        ZJHotelListModel *tempModel = self.model;
        
        NSMutableDictionary *mparam = [NSMutableDictionary dictionary];
        [mparam setObject:ZJ_UserID forKey:@"userId"];
        [mparam setObject:tempModel.mHid forKey:@"hid"];
        [mparam setObject:_mContent forKey:@"content"];
        [mparam setObject:_mMark forKey:@"score"];
        [mparam setObject:_mFWmark forKey:@"sscore"];
        [mparam setObject:_mHJMark forKey:@"escore"];
        if (_mPhotos && _mPhotos.length>0) {
            [mparam setObject:_mPhotos forKey:@"photos"];
        }
        [HttpApi  putHotelComment:mparam SuccessBlock:^(id responseBody) {
            [self.navigationController popViewControllerAnimated:YES];
        } FailureBlock:^(NSError *error) {
            
        }];
        
    }
}
#pragma mark private
//上传
-(void)upHeadImage:(NSData *)imageData teype:(NSString *)type{
    [HttpApi getUptoken:@{@"type":type,@"userId":ZJ_UserID} SuccessBlock:^(id responseBody) {
        NSString *_headImageStr= responseBody[@"fname"];
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
                [SVProgressHUD dismiss];
                if (_mPhotos.length == 0) {
                    [_mPhotos appendFormat:@"%@", _headImageStr];
                }else{
                    [_mPhotos appendFormat:@",%@", _headImageStr];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
            }
        } option:upoPtion];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJCommentCell"];
        ZJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJCommentCell"];
        [cell backMarkBlock:^(NSString *mark) {
            //星级评分
            _mMark = mark;
        }];
        [cell backKWMarkBlock:^(NSString *mark) {
            //口味
            _mKWmark = mark;
        }];
        [cell backHJMarkBlock:^(NSString *mark) {
            //环境评分
            _mHJMark = mark;
        }];
        [cell backFWMarkBlock:^(NSString *mark) {
            //服务评分
            _mFWmark = mark;
        }];
        return cell;
    }
    
    if (indexPath.row == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJCommentCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJCommentCell1"];
        ZJCommentCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJCommentCell1"];
        return cell;
    }
    
   
    [tableView registerNib:[UINib nibWithNibName:@"ZJCommentCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJCommentCell2"];
    ZJCommentCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJCommentCell2"];
    [cell SelectBlock:^(NSIndexPath * indexPath) {
        UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [mActionSheet showInView:self.view];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        NSData *imageData = UIImageJPEGRepresentation(edit,1.0);
        while (imageData.length > 1000000) {
            imageData = UIImageJPEGRepresentation(edit, 0.5);
           // edit = [UIImage imageWithData:imageData];
        }
        ZJCommentCell2 *cell = [self.minfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            [cell.mDataSoure insertObject:edit atIndex:0];
            [cell.mInfoCollectionView reloadData];
            NSString *type = @"";
            if ([self.model isKindOfClass:[ZJHotelListModel class] ]) {
                type = @"4";
            }
            if ([self.model isKindOfClass:[ZJDelicacyListModel class] ]) {
                type = @"5";
            }
            [self upHeadImage:imageData teype:type];
        }];
    }else{
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        NSData *imageData = UIImageJPEGRepresentation(edit,1.0);
        while (imageData.length > 1000000) {
            imageData = UIImageJPEGRepresentation(edit, 0.5);
          //  edit = [UIImage imageWithData:imageData];
        }

        ZJCommentCell2 *cell = [self.minfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        //        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:NO completion:^{
            [cell.mDataSoure insertObject:edit atIndex:0];
            [cell.mInfoCollectionView reloadData];
            NSString *type = @"";
            if ([self.model isKindOfClass:[ZJHotelListModel class] ]) {
                type = @"4";
            }
            if ([self.model isKindOfClass:[ZJDelicacyListModel class] ]) {
                type = @"5";
            }
            [self upHeadImage:imageData teype:type];
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
