/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "BaseTableViewCell.h"

//#import "UIImageView+HeadImage.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessibilityIdentifier = @"table_cell";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 /255.0 blue:213 / 255.0 alpha:0.7];
        [self.contentView addSubview:_bottomLineView];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _selectImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_unselected"]];
        [self.contentView addSubview:_selectImgView];
        
        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:_headerLongPress];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 8, 34, 34);
    [self.imageView.layer setMasksToBounds:YES];
    [self.imageView.layer setCornerRadius:17];
    
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.textLabel.frame = rect;
    
    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
   
    [_selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-8);
        make.centerY.mas_offset(0);
        make.height.width.mas_offset(20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)])
        {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    NSDictionary *mParamDic = @{@"chatusers":username,@"userId":ZJ_UserID};
    
    [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
        NSArray *tempArray = responseBody[@"users"];
        if (tempArray && tempArray.count>0) {
            NSDictionary *info = tempArray[0];
            NSString *Url =info[@"headImgUrl"];
            if (![Url isKindOfClass:[NSNull class]] && Url ) {
                  [self.imageView  sd_setImageWithURL:[NSURL URLWithString:Url] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"]];
            }
            self.textLabel.text = info[@"nickname"];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}


@end
