//
//  FMPhotoAlbumListViewController.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMblackBaseViewController.h"

//返回tableView列表的Block
typedef void(^LocationBlock)(NSInteger);

@interface FMPhotoAlbumListViewController : FMblackBaseViewController

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *listNameArray;

@property (nonatomic, copy) LocationBlock block;

@end
