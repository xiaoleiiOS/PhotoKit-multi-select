//
//  FMVideoPreviewCollectionViewCell.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
/**
 *  这部分是直接用网上的例子，稍微改动的，以后有时间再研究这一块😁
 */
@interface FMVideoPreviewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AVAsset *avAsset;

@end
