//
//  ZJTrafficDeatilVC.h
//  gjlv
//
//  Created by 刘冬 on 2017/1/6.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJTrafficDeatilVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mInfoTablView;
@property(nonatomic,retain) ZJTrafficListModel *mSelectModel;
@end
