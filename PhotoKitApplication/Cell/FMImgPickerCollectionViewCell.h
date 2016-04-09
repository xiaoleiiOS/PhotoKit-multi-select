//
//  FMImgPickerCollectionViewCell.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击事件用到的block
 *  无返回值
 */
typedef void (^ActionBlock)(void);

@interface FMImgPickerCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) IBOutlet UIImageView *   mainImageView;
@property (nonatomic , strong) UIImage *                contentImg;
@property (nonatomic , assign) BOOL                     isChoosen;
@property (nonatomic , assign) BOOL                     isChoosenImgHidden;
@property (weak, nonatomic) IBOutlet UIImageView *      videoCameraImgView;
@property (weak, nonatomic) IBOutlet UILabel *          vidoeDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *         selectBtn;

@property (nonatomic, copy) ActionBlock block;

//图片类型
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@end
