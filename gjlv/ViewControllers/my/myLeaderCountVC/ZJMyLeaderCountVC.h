//
//  ZJMyLeaderCountVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJMyLeaderCountVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)ZJLeaderDetailModel *mSelectModel;
@end
