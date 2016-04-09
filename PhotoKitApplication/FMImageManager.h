//
//  FMImageManager.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface FMImageManager : PHCachingImageManager

+ (instancetype)imageManager;

@end
