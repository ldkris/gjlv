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

#import "EMRemarkImageView.h"

//#import "UIImageView+HeadImage.h"

@implementation EMRemarkImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _editing = NO;
        
//        self.backgroundColor = [UIColor redColor];
        
        CGFloat vMargin = frame.size.height / 6;
        CGFloat hMargin = vMargin / 2;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(hMargin, 0, frame.size.width - vMargin - 10, frame.size.height - vMargin - 10)];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = (frame.size.width - vMargin - 10)/2;
        [self addSubview:_imageView];
        
        CGFloat rHeight = _imageView.frame.size.height / 3;
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height, _imageView.frame.size.width, rHeight)];
        _remarkLabel.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin;
        _remarkLabel.clipsToBounds = YES;
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        _remarkLabel.font = [UIFont systemFontOfSize:13.0];
//        _remarkLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _remarkLabel.textColor = [UIColor blackColor];
        [self addSubview:_remarkLabel];
    }
    return self;
}

- (void)setRemark:(NSString *)remark
{
    _remark = remark;
    NSDictionary *mParamDic = @{@"chatusers":remark,@"userId":ZJ_UserID};
    [HttpApi getUserChatList:mParamDic SuccessBlock:^(id responseBody) {
        NSArray *tempArray = responseBody[@"users"];
        if (tempArray && tempArray.count>0) {
            NSDictionary *info = tempArray[0];
            NSString *Url =info[@"headImgUrl"];
            if (![Url isKindOfClass:[NSNull class]] && Url ) {
                [ _imageView sd_setImageWithURL:[NSURL URLWithString:Url] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"]];
            }
            _remarkLabel.text = info[@"nickname"];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

@end
