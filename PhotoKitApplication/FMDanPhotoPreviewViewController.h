//
//  FMDanPhotoPreviewViewController.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMblackBaseViewController.h"

//按钮的点击事件block
typedef void (^BackDataBlock)(NSMutableArray *, NSMutableDictionary *, NSInteger);

@interface FMDanPhotoPreviewViewController : FMblackBaseViewController

@property (nonatomic, strong) NSArray *collectionDataArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
//选中的图片数组
@property (nonatomic, strong) NSMutableArray *choosenArray;
@property (nonatomic, assign) NSInteger choosenCount;
@property (nonatomic, strong) NSMutableDictionary *chooseImageDict;

@property (nonatomic, strong) BackDataBlock backBlock;


/**
 *  来源 来自个人相册预览为0  商家为1
 */
@property (nonatomic,assign)NSInteger source;
@end
