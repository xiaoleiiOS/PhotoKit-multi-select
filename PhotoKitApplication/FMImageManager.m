//
//  FMImageManager.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMImageManager.h"

@implementation FMImageManager

+ (instancetype)imageManager
{
    static FMImageManager *imageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        imageManager = [[FMImageManager alloc] init];
    });
    return imageManager;
}

@end
