//
//  FMDanPhotoPreviewViewController.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMDanPhotoPreviewViewController.h"
#import "FMDanPhotoPreviewCollectionViewCell.h"
#import "FMVideoPreviewCollectionViewCell.h"
#import "UILabel+FMJJKAlertActionFont.h"
#import "FMImageManager.h"
#import "SweetConfig.h"

typedef NS_ENUM (NSInteger , SourceType)
{
    normalType,
    bussinessSourceType,
};

#define rightItemText [NSString stringWithFormat:@"%ld/%ld",(long)_choosenCount,(long)danPhotoCount]
/**
 *  商家的标题
 */
#define bussinessRightItemText [NSString stringWithFormat:@"%ld",(long)_choosenCount]
const NSInteger danPhotoCount = 8;

@interface FMDanPhotoPreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    UIButton *_rightBarItem;
    NSInteger _pag;
    
    UIButton *_nextBtn;
    
    //记录视频的页面
    NSInteger _videoPag;
    
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *  layout;

@property (nonatomic, strong) FMImageManager * imageManager;
@end

//static CGSize AssetGridThumbnailSize;

@implementation FMDanPhotoPreviewViewController

#pragma mark - UI

- (void)markCollectionView{
    
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _layout.itemSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64);
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64) collectionViewLayout:_layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"FMDanPhotoPreviewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FMDanPhotoPreviewCollectionViewCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"FMVideoPreviewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FMVideoPreviewCollectionViewCell class])];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation设置
    [self markNavigation];
    
    [self markCollectionView];
    
    self.imageManager = [FMImageManager imageManager];
    [self.imageManager stopCachingImagesForAllAssets];
    
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePag" object:nil];
    
    if (_backBlock) {
        _backBlock(self.choosenArray, self.chooseImageDict, self.choosenCount);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)markNavigation{
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    self.title = _source == 0? rightItemText:bussinessRightItemText;
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    //选择按钮
    _rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBarItem.frame = CGRectMake(2, 3, 23, 23);
    [_rightBarItem setImage:[UIImage imageNamed:@"FMImgPickerCollectionViewCell_img_noselect"] forState:UIControlStateNormal];
    [_rightBarItem setImage:[UIImage imageNamed:@"FMImgPickerCollectionViewCell_img_select"] forState:UIControlStateSelected];
    [_rightBarItem addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:_rightBarItem];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(40, 0, 50, 30);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:_nextBtn];
    [self nextBtnIsSelect];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PHAsset *asset = self.collectionDataArray[indexPath.item];
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        FMVideoPreviewCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMVideoPreviewCollectionViewCell class]) forIndexPath:indexPath];
        
        [self.imageManager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
            videoCell.avAsset = asset;
            
        }];
        return videoCell;
        
    }else{
        FMDanPhotoPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMDanPhotoPreviewCollectionViewCell class]) forIndexPath:indexPath];
        
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        // 在资源的集合中获取每个集合，并获取其中的图片
        [self.imageManager requestImageForAsset: asset
                                     targetSize: PHImageManagerMaximumSize
                                    contentMode: PHImageContentModeAspectFill
                                        options: phImageRequestOptions
                                  resultHandler: ^(UIImage *result, NSDictionary *info) {
                                      
                                      // 得到一张 UIImage，展示到界面上
                                      cell.photoImage = result;
                                  }];
        return cell;
    }
    
    return nil;
}


#pragma mark - action Click

- (void)nextAction:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePag" object:nil];
    
    NSLog(@"下一步");
    
    PHAsset *asset = self.collectionDataArray[_pag];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        if (_choosenCount != 0 || self.chooseImageDict.count != 0) {
            [self popupView:asset];
            return;
        }
        [self videoFabu:asset];
        
    }else{
        
        NSLog(@"图片处理和图片界面一样");
        if (_choosenCount == 0 || self.chooseImageDict.count == 0) {
            return;
        }
        
        NSMutableArray * resuletData = [NSMutableArray arrayWithArray:[self.chooseImageDict allValues]];
        //resuletData 里存放着选中的图片资源，PhAsset类对象
        NSLog(@"%@", resuletData);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 视频发布

- (void)videoFabu:(PHAsset *)asset{
    
    FMImageManager *imageManager = [FMImageManager imageManager];
    [imageManager requestImageDataForAsset: asset
                                   options: nil
                             resultHandler: ^(NSData *imageData, NSString *dataUTI,
                                              UIImageOrientation orientation,
                                              NSDictionary *info)
     {
         NSLog(@"info = %@", info);
         
         //这里做了一个限制，可以根据自己的情况设定
         if (imageData.length >= 10 * 1024 * 1024) {
             
             NSLog(@"视频为：%.2fM", imageData.length / 1024.0 / 1024.0);
             [self showMessage:@"选中的视频不能超过10M！"];
             return ;
         }else{
             
             NSLog(@"视频的处理");
         }
     }];
}

- (void)selectAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    
    PHAsset *asset = self.collectionDataArray[_pag];
    
    if (sender.selected) {
        //上传个人图片 要限制在八张以内
        if (_choosenCount >= danPhotoCount && _source == 0) {
            sender.selected = NO;
            self.title = _source == 0? rightItemText:bussinessRightItemText;;
            return;
        }
        _choosenCount += 1;
        [self.chooseImageDict setObject:asset forKey:[NSIndexPath indexPathForRow:_pag inSection:0]];
    }else {
        _choosenCount -= 1;
        [self.chooseImageDict removeObjectForKey:[NSIndexPath indexPathForRow:_pag inSection:0]];
    }
    
    self.title = _source == 0? rightItemText:bussinessRightItemText;;
    
    [self.choosenArray replaceObjectAtIndex:_pag withObject:[NSNumber numberWithBool:sender.selected]];
    
    [self nextBtnIsSelect];
}

#pragma mark - 弹窗

- (void)popupView:(PHAsset *)asset{
    
    NSLog(@"弹出提示框");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否替换之前所选图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction *againAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        for (int i = 0; i < self.choosenArray.count; i++) {
            [self.choosenArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
        _choosenCount = 0;
        [self.chooseImageDict removeAllObjects];

        self.title = rightItemText;
        
        [self videoFabu:asset];
        
    }];
    
    [alertController addAction:againAction];
    [alertController addAction:cancelAction];
    [alertController.view setTintColor:[UIColor blackColor]];
    
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:16];
    [appearanceLabel setAppearanceFont:font];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)nextBtnIsSelect{
    
    if (_choosenCount == 0 || self.chooseImageDict.count == 0) {
        
        _nextBtn.enabled = NO;
    }else {
        _nextBtn.enabled = YES;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _pag = lround(self.collectionView.contentOffset.x / DEF_SCREEN_WIDTH);
    
    NSLog(@"%ld", _pag);
    
    if ([self.choosenArray[_pag] boolValue]) {
        _rightBarItem.selected = YES;
    }else{
        _rightBarItem.selected = NO;
    }
    
    PHAsset *asset = self.collectionDataArray[_pag];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        _videoPag = _pag;
        _nextBtn.enabled = YES;
        _rightBarItem.hidden = YES;
    }else {
        _rightBarItem.hidden = NO;
        if (_choosenCount == 0 || self.chooseImageDict.count == 0) {
            _nextBtn.enabled = NO;
        }else{
            _nextBtn.enabled = YES;
        }
        if (_videoPag != _pag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changePag" object:nil];
        }
    }
    _videoPag = _pag;
}

@end
