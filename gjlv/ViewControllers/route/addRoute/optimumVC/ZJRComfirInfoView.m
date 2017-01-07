//
//  ZJRComfirInfoView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/21.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRComfirInfoView.h"
#import "ZJRComfireViewCell.h"
#import "ZJRComfireViewCell1.h"
@interface ZJRComfirInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btn_comfire;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIView *mContentView;

@end

@implementation ZJRComfirInfoView{
    NSArray *_mDataSoure;
    NSArray *_mSubDataSoure;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _mDataSoure = @[@"出行人数：",@"",@"出行车辆：",@"出行时间："];
    _mSubDataSoure = @[@"成人",@"小孩",@"",@""];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fixString = [dateFormatter stringFromDate:[NSDate date]];
    self.dateStr = fixString;
    
    self.mInfoTableView.backgroundColor = [UIColor clearColor];
    self.mInfoTableView.dataSource = (id)self;
    self.mInfoTableView.delegate = (id)self;
    self.mInfoTableView.scrollEnabled = NO;
    
    [self.mContentView.layer setMasksToBounds:YES];
    [self.mContentView.layer setCornerRadius:10.0f];
    
    self.btn_cancel.layer.borderColor = SL_GRAY.CGColor;
    self.btn_cancel.layer.borderWidth = 0.5f;
    
    self.btn_comfire.layer.borderColor = SL_GRAY.CGColor;
    self.btn_comfire.layer.borderWidth = 0.5f;
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 磨砂视图
    UIView *mBarBgView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [mBarBgView.layer setMasksToBounds:YES];
    [mBarBgView.layer setCornerRadius:5.0f];
    [self.mContentView insertSubview:mBarBgView atIndex:0];
    [mBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark public
-(void)onclickComfirBlock:(void (^)(UIButton *))block{
    self.comfirBlock = block;
}
-(void)onclickselectDateBlock:(void (^)(UIButton *))block{
    self.selectDate = block;
}
#pragma mark event response
- (IBAction)onclickComfirBtn:(id)sender {
   
    ZJRComfireViewCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
   self.adultNum = cell.mlab_num.text;
    ZJRComfireViewCell *cell2 = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
     self.childNum = cell2.mlab_num.text;
    ZJRComfireViewCell *cell3 = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
     self.carNum = cell3.mlab_num.text;
    
    ZJRComfireViewCell1 *cell4 = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    self.dateStr = cell4.mLab_dateTitle.text;
    
    
    if ( self.adultNum ==nil ||  self.adultNum.length==0) {
        ShowMSG(@"请选择成人数量");
        return;
    }
    if ( self.childNum ==nil ||  self.childNum.length==0) {
        ShowMSG(@"请选择儿童数量");
        return;
    }
    if ( self.carNum ==nil ||  self.carNum.length==0) {
        ShowMSG(@"请选择车辆数量");
        return;
    }
    if ( self.dateStr ==nil ||  self.dateStr.length==0) {
        ShowMSG(@"请选择出发日期");
        return;
    }
    
    
    if (self.comfirBlock) {
        [self removeFromSuperview];
        self.comfirBlock(sender);
    }
}
- (IBAction)onclickCancelBtn:(id)sender {
     [self removeFromSuperview];
}
- (IBAction)onclickCloseBtn:(id)sender {
     [self removeFromSuperview];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _mDataSoure.count - 1) {
        [tableView registerNib:[UINib nibWithNibName:@"ZJRComfireViewCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRComfireViewCell1"];
        ZJRComfireViewCell1*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRComfireViewCell1"];
        cell.mLab_dateTitle.text = self.dateStr;
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"ZJRComfireViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRComfireViewCell"];
    ZJRComfireViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRComfireViewCell"];
    cell.mlab_subTitle.text = _mSubDataSoure[indexPath.row];
    cell.mLab_title.text = _mDataSoure[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectDate) {
        self.selectDate(nil);
    }
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self removeFromSuperview];
//}
@end
