//
//  BMAoutSizeLabel.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMAoutSizeLabel : UILabel

@property(nonatomic,assign)CGSize MaxSize;

/**
 *  计算字符串Size
 *
 *  @param str   字符串
 *  @param fount 字体
 *  @param size  最大Size   0不限制最大最
 *
 *  @return 返回字符串所需最小Size
 */
+(CGSize)sizeWithString:(NSString *)str fount:(UIFont*)fount maxSize:(CGSize)size;
@end
