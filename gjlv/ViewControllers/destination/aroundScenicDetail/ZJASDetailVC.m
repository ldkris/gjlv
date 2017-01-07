//
//  ZJASDetailVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/12/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJASDetailVC.h"
#import "ZJASDCell.h"
#import "ZJASDMLCell.h"
#import "ZJASDMLCell1.h"
@interface ZJASDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mMLView;
@property (weak, nonatomic) IBOutlet UITableView *mInfotableView;
@property (weak, nonatomic) IBOutlet UITableView *mMLTableView;
@property(nonatomic,retain)NSArray *mSections;
@property(nonatomic,retain)NSArray *mRows;
@end

@implementation ZJASDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"景点介绍";
  
    
    self.mInfotableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfotableView.estimatedRowHeight = 100;
    [self.mInfotableView  setBackgroundColor:[UIColor whiteColor]];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoive:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mMLView addGestureRecognizer:gesture];
    
    UISwipeGestureRecognizer *gesture1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoive:)];
    gesture1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mMLView addGestureRecognizer:gesture1];
    
//    self.mMLView.hidden = YES;
    [self getSpotDetail];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.mMLView.hidden = NO;
    [self.mMLView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-MainScreenFrame_Width);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mMLView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mSections{
    if (_mSections == nil) {
        _mSections = @[];
    }
    return _mSections;
}
-(NSArray *)mRows{
    if (_mRows == nil) {
        _mRows = @[];
    }
    return _mRows;
}
#pragma mark networking
-(void)getSpotDetail{
    NSDictionary *mparcDic = @{@"userId":ZJ_UserID,@"spotId":[self.mSelectModel.msid stringValue]};
    [HttpApi getSpotDetail:mparcDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray  = [MTLJSONAdapter modelsOfClass:[ZJCatalogModel class] fromJSONArray:responseBody[@"spots"][0][@"catalogs"] error:&error];
        if (!error) {
            self.mSections = tempArray;
            [self.mInfotableView reloadData];
            [self.mMLTableView reloadData];
        }
    
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)tapMoive:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.mMLView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
    }
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.mMLView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-MainScreenFrame_Width);
        }];
    }
    
}
- (IBAction)onclickMeunBtn:(id)sender {
    [self.mMLView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mSections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_mSections && _mSections.count>0) {
        NSError *error;
        ZJCatalogModel*temp  = _mSections[section];
        NSArray *tempArray  = [MTLJSONAdapter modelsOfClass:[ZJCatalogModel class] fromJSONArray:temp.mcatalogs error:&error];
        if (error == nil) {
            if (tableView == self.mMLTableView) {
                  return tempArray.count + 1;
            }else{
              return tempArray.count;
            }
          
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.mMLTableView) {
        if(section == 0){
            return 40.0f;
        }
        return 0.01f;
    }
    return 40.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.mMLTableView) {
        if(section >0){
            return nil;
        }
        UIView *headView = [[UIView alloc]init];
        [headView setBackgroundColor:[UIColor clearColor]];;
        UILabel *mLabel = [[UILabel alloc]init];
        [mLabel setTextColor:[UIColor whiteColor]];
        [mLabel setText:@"景点介绍目录"];
        [mLabel setFont:DEFAULT_BOLD_FONT(15)];
        [headView addSubview:mLabel];
        [mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(0);
        }];
        
        return headView;
    }
    UIView *headView = [[UIView alloc]init];
       [headView setBackgroundColor:[UIColor whiteColor]];
    ZJCatalogModel*temp  = _mSections[section];
    UILabel *mLabel = [[UILabel alloc]init];
    [mLabel setTextColor:[UIColor blackColor]];
    [mLabel setText:temp.mcname];
    [mLabel setFont:DEFAULT_BOLD_FONT(14)];
    [headView addSubview:mLabel];
    [mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(0);
    }];
    
    return headView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mMLTableView) {
        
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJASDMLCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJASDMLCell1"];
            ZJASDMLCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJASDMLCell1"];
            ZJCatalogModel*temp  = _mSections[indexPath.section];
            [cell.mlab_title setText:temp.mcname];
             cell.img.image = [UIImage imageNamed:@"a_ml_top"];
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"ZJASDMLCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJASDMLCell"];
        ZJASDMLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJASDMLCell"];
        ZJCatalogModel*temp  = _mSections[indexPath.section];
        NSError *error;
        NSArray *tempArray  = [MTLJSONAdapter modelsOfClass:[ZJCatalogModel class] fromJSONArray:temp.mcatalogs error:&error];
        ZJCatalogModel *model = tempArray[indexPath.row - 1];
        [cell.mlab_title setText:model.mcname];
//        if (indexPath.row == 0) {
//            cell.img.image = [UIImage imageNamed:@"a_ml_top"];
//        }
        if (indexPath.row>0 ) {
            cell.img.image = [UIImage imageNamed:@"a_ml"];
        }
//        if (indexPath.row == tempArray.count) {
//            cell.img.image = [UIImage imageNamed:@"a_ml_botton"];
//        }
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJASDCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJASDCell"];
    ZJASDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJASDCell"];
    
    if (_mSections && _mSections.count>0) {
        NSError *error;
        ZJCatalogModel*temp  = _mSections[indexPath.section];
        NSArray *tempArray  = [MTLJSONAdapter modelsOfClass:[ZJCatalogModel class] fromJSONArray:temp.mcatalogs error:&error];
        [cell loadDataWithModel:tempArray[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mMLTableView) {
        [self.mMLView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-MainScreenFrame_Width);
        }];
        [self.mInfotableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
