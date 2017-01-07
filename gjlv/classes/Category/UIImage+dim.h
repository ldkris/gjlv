//
//  UIImage+dim.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (dim)
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
