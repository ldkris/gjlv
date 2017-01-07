//
//  ZJRAddSecVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRAddSecVC.h"
#import "ZJAMenuBtn.h"
#import "ZJRSecCell.h"
#import "ZJRHeadCell.h"
#import "ZJRBottmCell.h"
#import "ZJSearchPointVC.h"
#import "ZJDepartVC.h"
#import "ZJOptimumRouteVC.h"
#import "ZJRACollectionViewCell.h"
#import "ZJRACollectionViewCell1.h"
#import "ZJCustomRouteVC.h"
@interface ZJRAddSecVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mBtnsView;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfir;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_select;

@property (weak, nonatomic) IBOutlet UICollectionView *infoCollectView;
@end

@implementation ZJRAddSecVC{

    NSArray * _BtnsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.mBtn_comfir.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_comfir.layer setBorderWidth:0.5];
    
    [self.mBtn_select.layer setBorderColor:SL_GRAY.CGColor];
    [self.mBtn_select.layer setBorderWidth:0.5];
    
    if (self.mSysemRouteLines && self.mSysemRouteLines.count>0) {
        ZJMyRoteModel *model = self.mSysemRouteLines[0];
        [self.mADDRoutesPoint addObjectsFromArray:model.mafters];
        [self.mInfoTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  getter
-(NSMutableArray *)mADDRoutesPoint{
    if (_mADDRoutesPoint == nil) {
        _mADDRoutesPoint = [NSMutableArray array];
    }
    return _mADDRoutesPoint;
}
-(NSArray *)mSysemRouteLines{
    if (_mSysemRouteLines == nil) {
        _mSysemRouteLines = @[];
    }
    return _mSysemRouteLines;
}

#pragma mark event response
-(void)onclickMenuBtn:(UIButton *)sender{
    
    for (ZJAMenuBtn *btn in _BtnsArray) {
        if (sender == btn) {
            [btn setBackgroundColor:[UIColor clearColor]];
        }else{
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }

}
- (IBAction)onclickSelectBtn:(id)sender {
    ZJDepartVC *tempVC = [[ZJDepartVC alloc]init];
//    tempVC.mMyRouteModel = 
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickComfirBtn:(id)sender {
    
    NSMutableDictionary *mParam = [NSMutableDictionary dictionary];
    [mParam setValue:ZJ_UserID forKey:@"userId"];
    
    NSMutableDictionary *routeDic = [NSMutableDictionary dictionary];
    [routeDic setValue:[self.title stringByReplacingOccurrencesOfString:@"-" withString:@"到"] forKey:@"rname"];
    
    NSMutableArray *afters = [NSMutableArray array];
    for (int i = 0; i < self.mADDRoutesPoint.count; i++) {
        NSMutableDictionary *afterDic = [NSMutableDictionary dictionary];
        
        BMKPoiInfo *model = self.mADDRoutesPoint[i];
        if ([model isKindOfClass:[BMKPoiInfo class]]) {
            [afterDic setObject:model.city forKey:@"aname"];
            [afterDic setObject:[NSString stringWithFormat:@"%f",model.pt.latitude] forKey:@"lat"];
            [afterDic setObject:[NSString stringWithFormat:@"%f",model.pt.longitude] forKey:@"lng"];
            [afterDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"sortNo"];
            if (i != 0 && i != self.mADDRoutesPoint.count-1) {
                ZJRSecCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [afterDic setObject:[NSString stringWithFormat:@"%ld",(long)cell.mtype] forKey:@"type"];
            }else{
                if (i == 0) {
                    ZJRHeadCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [afterDic setObject:[NSString stringWithFormat:@"%ld",(long)cell.mtype] forKey:@"type"];
                    
                }else{
                    ZJRBottmCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [afterDic setObject:[NSString stringWithFormat:@"%ld",(long)cell.mtype] forKey:@"type"];
                }
            }
          
        }else{
            NSDictionary *model1 = (NSDictionary *)model;
            [afterDic setObject:model1[@"aname"] forKey:@"aname"];
            NSString * Lat = [NSString stringWithFormat:@"%@",model1[@"lat"]];
            NSString * Lng =  [NSString stringWithFormat:@"%@",model1[@"lng"]];;
            [afterDic setObject:Lat forKey:@"lat"];
            [afterDic setObject:Lng forKey:@"lng"];
            [afterDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"sortNo"];
            if (i != 0 && i != self.mADDRoutesPoint.count-1) {
                ZJRSecCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [afterDic setObject:[NSString stringWithFormat:@"%ld",(long)cell.mtype] forKey:@"type"];
            }else{
                if (i == 0) {
                    ZJRHeadCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [afterDic setObject:[NSString stringWithFormat:@"%ld",(long)cell.mtype] forKey:@"type"];

                }else{
                    ZJRBottmCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [afterDic setObject:[NSString stringWithFormat:@"%ld",(long)cell.mtype] forKey:@"type"];
                }
            }
        }
        
        [afters addObject:afterDic];
        
    }
    [routeDic setObject:afters forKey:@"afters"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:routeDic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [mParam setObject:jsonString forKey:@"route"];
    
    
    [HttpApi putRoute:mParam SuccessBlock:^(id responseBody) {
        
        NSString *mRid = [NSString stringWithFormat:@"%@",responseBody[@"urId"]];
        if (mRid && mRid.length>0 ) {
            ZJOptimumRouteVC *tempVC = [[ZJOptimumRouteVC alloc]init];
            tempVC.mADDRoutesPoint = self.mADDRoutesPoint;
            tempVC.mSysemRouteLines = self.mSysemRouteLines;
            tempVC.mRid = mRid;
            tempVC.title = self.title;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark private
-(void)loadMenuBtns{
    ZJAMenuBtn *mTJbtn = [[NSBundle mainBundle]loadNibNamed:@"ZJAMenuBtn" owner:nil options:nil][0];
    [mTJbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mTJbtn setTag:0];
    [mTJbtn setBackgroundColor:[UIColor clearColor]];
    [self.mBtnsView addSubview:mTJbtn];
    [mTJbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(MainScreenFrame_Width/3);
    }];
    
    ZJAMenuBtn *mYTJbtn = [[NSBundle mainBundle]loadNibNamed:@"ZJAMenuBtn" owner:nil options:nil][0];
    [mYTJbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mYTJbtn setTag:1];
    [mYTJbtn setBackgroundColor:[UIColor whiteColor]];
    [self.mBtnsView addSubview:mYTJbtn];
    [mYTJbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(mTJbtn.mas_right).with.offset(1);
        make.width.mas_offset(MainScreenFrame_Width/3);
    }];
    
    UIButton *mZDYbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mZDYbtn addTarget:self action:@selector(onclickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mZDYbtn setTag:2];
    [mZDYbtn setTitle:@"我要自定义路线" forState:UIControlStateNormal];
    [mZDYbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mZDYbtn setBackgroundColor:[UIColor whiteColor]];
    [mZDYbtn.titleLabel setFont:DEFAULT_FONT(13)];
    [self.mBtnsView addSubview:mZDYbtn];
    [mZDYbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(mYTJbtn.mas_right).with.offset(1);
        make.width.mas_offset(MainScreenFrame_Width/3);
    }];
    
    if (_BtnsArray ==nil) {
        _BtnsArray = @[mTJbtn,mYTJbtn,mZDYbtn];
    }
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mADDRoutesPoint.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJRHeadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRHeadCell"];
        ZJRHeadCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRHeadCell"];
        __weak typeof(cell) weakcell = cell;
        id tempModel  = self.mADDRoutesPoint[indexPath.row];
        if ([tempModel isKindOfClass:[BMKPoiInfo class]]) {
            BMKPoiInfo *model = tempModel;
            weakcell.mLab_title.text =model.city;
        }else{
            NSError *error;
            ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:tempModel error:&error];
            if (!error) {
                weakcell.mLab_title.text =model.maname;
            }
        }
        __weak typeof(self) weakself = self;
        [cell onclickMoreMenuBtnBlock:^(UIButton *sender) {
            ZJSearchPointVC *tempVC = [[ZJSearchPointVC alloc]init];
            [tempVC backInfoBlock:^(BMKPoiInfo *info) {
                [weakself.mADDRoutesPoint insertObject:info atIndex:indexPath.row+1];
                [weakself.mInfoTableView reloadData];
            }];
            [weakself.navigationController pushViewController:tempVC animated:YES];
        }];
        
        [cell onclickDeleBtnBlokcBlock:^(UIButton *sender) {
            [weakcell annBack];
            ShowMSG(@"不能删除起点");
            
        }];
        return cell;
    }
    
  if (indexPath.row == self.mADDRoutesPoint.count - 1) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJRBottmCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRBottmCell"];
      ZJRBottmCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRBottmCell"];
      __weak typeof(cell) weakcell = cell;
      id tempModel  = self.mADDRoutesPoint[indexPath.row];
      if ([tempModel isKindOfClass:[BMKPoiInfo class]]) {
          BMKPoiInfo *model = tempModel;
          weakcell.mLab_title.text =model.city;
      }else{
          NSError *error;
          ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:tempModel error:&error];
          if (!error) {
              weakcell.mLab_title.text =model.maname;
          }
      }
      __weak typeof(self) weakself = self;
      [cell onclickMoreMenuBtnBlock:^(UIButton *sender) {
          ZJSearchPointVC *tempVC = [[ZJSearchPointVC alloc]init];
          [tempVC backInfoBlock:^(BMKPoiInfo *info) {
              [weakself.mADDRoutesPoint insertObject:info atIndex:indexPath.row];
              [weakself.mInfoTableView reloadData];
          }];
          [weakself.navigationController pushViewController:tempVC animated:YES];
      }];
      
      [cell onclickDeleBtnBlokcBlock:^(UIButton *sender) {
          [weakcell annBack];
          ShowMSG(@"不能删除终点");
          
      }];
      return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJRSecCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRSecCell"];
    ZJRSecCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRSecCell"];
    id tempModel  = self.mADDRoutesPoint[indexPath.row];
    __weak typeof(self) weakself = self;
    __weak typeof(cell) weakcell = cell;
    if ([tempModel isKindOfClass:[BMKPoiInfo class]]) {
        BMKPoiInfo *model = tempModel;
        weakcell.mLab_title.text =model.city;
    }else{
        NSError *error;
        ZJAfterModel *model = [MTLJSONAdapter modelOfClass:[ZJAfterModel class] fromJSONDictionary:tempModel error:&error];
        if (!error) {
            weakcell.mLab_title.text =model.maname;
        }
    }
    [cell onclickMoreMenuBtnBlock:^(UIButton *sender) {
        ZJSearchPointVC *tempVC = [[ZJSearchPointVC alloc]init];
        [tempVC backInfoBlock:^(BMKPoiInfo *info) {
            [weakself.mADDRoutesPoint insertObject:info atIndex:indexPath.row + 1];
            [weakself.mInfoTableView reloadData];
        }];
        [weakself.navigationController pushViewController:tempVC animated:YES];
    }];
    [cell onclickDeleBtnBlokcBlock:^(UIButton *sender) {
        [weakself.mADDRoutesPoint removeObjectAtIndex:indexPath.row];
        [weakself.mInfoTableView reloadData];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark UICollectionViewDataSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mSysemRouteLines.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int CellW = collectionView.frame.size.width /(self.mSysemRouteLines.count + 1);
    
    return CGSizeMake(CellW ,60);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == self.mSysemRouteLines.count){
        static NSString * SLCellIdentifier = @"ZJRACollectionViewCell1";
        
        [collectionView registerNib:[UINib nibWithNibName:@"ZJRACollectionViewCell1" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJRACollectionViewCell1"];
        
        ZJRACollectionViewCell1 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    
    static NSString * SLCellIdentifier = @"ZJRACollectionViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJRACollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJRACollectionViewCell"];
    
    ZJRACollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.mBGView setBackgroundColor:cell.backgroundColor];
    }

    if (self.mSysemRouteLines.count>= indexPath.row) {
         [cell loadCellDataWithModel:self.mSysemRouteLines[indexPath.row]];
    }
    return cell;
}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mSysemRouteLines.count) {
        ZJCustomRouteVC *tempVC = [[ZJCustomRouteVC alloc]init];
        tempVC.mADDRoutesPoint = self.mADDRoutesPoint;
        tempVC.mSysemRouteLines = self.mSysemRouteLines;
        [self.navigationController pushViewController:tempVC animated:YES];
        return;
    }
    
    for ( ZJRACollectionViewCell * cell in collectionView.visibleCells) {
        if([cell isKindOfClass:[ZJRACollectionViewCell class]]){
            NSIndexPath *tempPath = [collectionView indexPathForCell:cell];
            if (indexPath.row == tempPath.row) {
                [cell.mBGView setBackgroundColor:cell.backgroundColor];
            }else{
                [cell.mBGView setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
    
    [self.mADDRoutesPoint removeAllObjects];
    ZJMyRoteModel *model = self.mSysemRouteLines[indexPath.row];
    [self.mADDRoutesPoint addObjectsFromArray:model.mafters];
    [self.mInfoTableView reloadData];
    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
