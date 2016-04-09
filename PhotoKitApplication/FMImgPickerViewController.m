//
//  FMImgPickerViewController.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMImgPickerViewController.h"
#import "FMPhotoAlbumListViewController.h"
#import "FMImgPickerCollectionViewCell.h"
#import "FMDanPhotoPreviewViewController.h"
#import "FMImageManager.h"
#import "SweetConfig.h"
#import "BMAoutSizeLabel.h"
#import  <AssetsLibrary/AssetsLibrary.h>

#define empty_width 3
#define maxnum_of_one_line 4
#define rightItemTitle [NSString stringWithFormat:@"%ld/%ld下一步",(long)_choosenCount,(long)photoCount]
static const NSInteger photoCount = 8;

@interface FMImgPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger _choosenCount;
    UILabel *_navTitleLabel;
    UIImageView *_navTitleImageView;
    UIButton *_rightBarItem;
    //保存相册名
    NSString *_photoAlbumName;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FMImageManager * imageManager;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
//展示界面的图片数据
@property (nonatomic, strong) NSArray *collectionDataArray;
//保存相册列表，其中包含全部的图片数据
@property (nonatomic, strong) NSMutableArray *tableDataArray;
//存放相册名的数组
@property (nonatomic, strong) NSMutableArray *tableListNameArray;
//记录图片的选择状态
@property (nonatomic, strong) NSMutableDictionary *isChoosenDic;
//将选择的图片保存
@property (nonatomic, strong) NSMutableDictionary *choosenImgDict;

@end

@implementation FMImgPickerViewController

static CGSize AssetGridThumbnailSize;

#pragma mark - init

- (NSMutableArray *)tableDataArray{
    if (!_tableDataArray) {
        _tableDataArray = [[NSMutableArray alloc] init];
    }
    return _tableDataArray;
}

-(NSMutableArray *)tableListNameArray{
    if (!_tableListNameArray) {
        _tableListNameArray = [[NSMutableArray alloc] init];
    }
    return _tableListNameArray;
}

- (NSMutableDictionary *)isChoosenDic{
    if (!_isChoosenDic) {
        _isChoosenDic = [[NSMutableDictionary alloc] init];
    }
    return _isChoosenDic;
}

-(NSMutableDictionary *)choosenImgDict{
    if (!_choosenImgDict) {
        _choosenImgDict = [[NSMutableDictionary alloc] init];
    }
    return _choosenImgDict;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self markNavigation];
    
    [self markCollectionView];
    
    self.imageManager = [FMImageManager imageManager];
    [self.imageManager stopCachingImagesForAllAssets];
   
    //获取图片资源
    [self.tableDataArray removeAllObjects];
    [self.tableListNameArray removeAllObjects];
    [self.isChoosenDic removeAllObjects];
    [self.choosenImgDict removeAllObjects];
    _choosenCount = 0;
    //数据
    [self markData];
    [self getCollectionData:0];
    [_rightBarItem setTitle:rightItemTitle forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)_layout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - customeMethods

-(void)markCollectionView{
    
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumInteritemSpacing = empty_width;
    _layout.minimumLineSpacing = empty_width;
    CGFloat itemHeight = (DEF_SCREEN_WIDTH - (maxnum_of_one_line - 1) * empty_width ) / maxnum_of_one_line;
    _layout.itemSize = CGSizeMake(itemHeight, itemHeight);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.sectionInset = UIEdgeInsetsMake(empty_width, 0 , empty_width, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64) collectionViewLayout:_layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FMImgPickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FMImgPickerCollectionViewCell class])];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - navigation设置

- (void)markNavigation{
    
    //naviegationBar
    self.view.frame = [UIScreen mainScreen].bounds;
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 145, 44)];
    
    NSLog(@"%@", NSStringFromCGRect(self.navigationItem.titleView.frame));
    
    UIButton *kongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kongBtn.frame = self.navigationItem.titleView.bounds;
    [kongBtn addTarget:self action:@selector(showTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:kongBtn];
    
    _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 145, 20)];
    _navTitleLabel.text = @"相机胶卷";
    _navTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    _navTitleLabel.textColor = [UIColor whiteColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navTitleLabel.contentMode = UIViewContentModeCenter;
    [self.navigationItem.titleView addSubview:_navTitleLabel];
    
    _navTitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_navTitleLabel.frame), 7, 25, 30)];
    _navTitleImageView.image = [UIImage imageNamed:@"FMImgPickerViewController_Image_triangle"];
    _navTitleImageView.contentMode = UIViewContentModeCenter;
    [self.navigationItem.titleView addSubview:_navTitleImageView];
    
    [self settitleLabelFrame];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_X"] style:UIBarButtonItemStyleDone target:self action:@selector(hide)];
    
    _rightBarItem = [[UIButton alloc] init];
    _rightBarItem.frame = CGRectMake(0, 0, 80, 30);
    [_rightBarItem setTitle:rightItemTitle forState:UIControlStateNormal];
    [_rightBarItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBarItem setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _rightBarItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightBarItem addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - 重置navigation的title的位置

- (void)settitleLabelFrame{
    
    CGSize titleSize = [BMAoutSizeLabel sizeWithString:_navTitleLabel.text fount:_navTitleLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, 20)];
    
    if (titleSize.width > 145) {
        titleSize.width = 145;
    }
    
    _navTitleLabel.frame = CGRectMake((145 - titleSize.width) / 2, 12, titleSize.width, 20);
    _navTitleImageView.frame = CGRectMake(CGRectGetMaxX(_navTitleLabel.frame), 7, 25, 30);
}

#pragma mark - 数据
- (void)markData{
//     Create a PHFetchResult object for each section in the table view.
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    [self allPhotoSave:allPhotos];
    //设置选择
    NSMutableArray * isChoosenArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<allPhotos.count; i++) {
        [isChoosenArray addObject:[NSNumber numberWithBool:NO]];
    }
    [self.isChoosenDic setObject:isChoosenArray forKey:@"相机胶卷"];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [self getFetchResultData:smartAlbums];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [self getFetchResultData:topLevelUserCollections];
    
}

- (void)allPhotoSave:(PHFetchResult *)allPhotos{
    //放入数组中
    [self.tableDataArray addObject:allPhotos];
    [self.tableListNameArray addObject:@"相机胶卷"];
}

//得到原数据，并将空相册去除
- (void)getFetchResultData:(PHFetchResult *)fetchResult{
    
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < fetchResult.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = fetchResult[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *newFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            if ([collection.localizedTitle isEqualToString:@"相机胶卷"] || [collection.localizedTitle isEqualToString:@"Camera Roll"]) {
                
                continue;
            }else if (!newFetchResult.count == 0) { //如果不为空，加入到tableView列表的数组中
            
                [self.tableDataArray addObject:newFetchResult];
                [self.tableListNameArray addObject:collection.localizedTitle];
                
                //设置选择
                NSMutableArray * isChoosenArray = [[NSMutableArray alloc]init];
                for (int i = 0; i<newFetchResult.count; i++) {
                    [isChoosenArray addObject:[NSNumber numberWithBool:NO]];
                }
                [self.isChoosenDic setObject:isChoosenArray forKey:collection.localizedTitle];
            }
        }
        else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
}

- (void)getCollectionData:(NSInteger)tag {
    
    self.collectionDataArray = self.tableDataArray[tag];
    _photoAlbumName = self.tableListNameArray[tag];
    [self.collectionView reloadData];

    //进入界面跳转到最新的照片
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.collectionDataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    
    _navTitleLabel.text = self.tableListNameArray[tag];
    
    [self settitleLabelFrame];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FMImgPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMImgPickerCollectionViewCell class]) forIndexPath:indexPath];
    
    PHAsset *asset = self.collectionDataArray[indexPath.item];
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.videoCameraImgView.hidden = NO;
        cell.isChoosenImgHidden = YES;
        cell.selectBtn.hidden = YES;
        
        NSTimeInterval time = asset.duration;
        NSInteger hours = lround(floor(time / 3600.)) % 100;
        NSInteger points = lround(floor(time / 60.)) % 60;
        NSInteger seconds = lround(floor(time)) % 60;
        //转换时间
        NSString *string = [NSString stringWithFormat:@"%@%@%@",
                            [self timeConversion:hours],
                            [NSString stringWithFormat:@"%ld:", points],
                            [NSString stringWithFormat:@"%02ld", seconds]];
        
        cell.vidoeDateLabel.text = string;
        
    }else{
        cell.videoCameraImgView.hidden = YES;
        cell.vidoeDateLabel.text = @"";
        cell.isChoosenImgHidden = NO;
        cell.selectBtn.hidden = NO;
    }
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    // 在资源的集合中获取每个集合，并获取其中的图片
    [self.imageManager requestImageForAsset:asset
                                 targetSize: AssetGridThumbnailSize
                                contentMode: PHImageContentModeAspectFill
                                    options: phImageRequestOptions
                              resultHandler: ^(UIImage *result, NSDictionary *info) {
         
         // 得到一张 UIImage，展示到界面上
         cell.contentImg = result;
     }];
    
    NSArray * isChoosenArray = [self.isChoosenDic objectForKey:_photoAlbumName];
    cell.isChoosen = [[isChoosenArray objectAtIndex:indexPath.item] boolValue];
    cell.block = ^(){
        //图片多选
        [self selectActionWithCollectionView:collectionView indexPath:indexPath];
    };
    return cell;
}

//判断小时的时间
- (NSString *)timeConversion:(NSInteger)time{
    
    NSString *string;
    if (time == 0) {
        string = @"";
    }else{
        string = [NSString stringWithFormat:@"%ld:", time];
    }
    return string;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"单张预览");
    
    FMDanPhotoPreviewViewController *danPhotoVC = [[FMDanPhotoPreviewViewController alloc] init];
    
    danPhotoVC.collectionDataArray = self.collectionDataArray;
    danPhotoVC.indexPath = indexPath;
    danPhotoVC.choosenArray = [self.isChoosenDic objectForKey:_photoAlbumName];
    danPhotoVC.choosenCount = _choosenCount;
    danPhotoVC.chooseImageDict = self.choosenImgDict;
    danPhotoVC.backBlock = ^(NSMutableArray *choosArr, NSMutableDictionary *choosDict, NSInteger choosCount){
        [self.isChoosenDic setObject:choosArr forKey:_navTitleLabel.text];
        self.choosenImgDict = choosDict;
        _choosenCount = choosCount;
        [self.collectionView reloadData];
        [_rightBarItem setTitle:rightItemTitle forState:UIControlStateNormal];
        if (self.choosenImgDict.count) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    };
    [self.navigationController pushViewController:danPhotoVC animated:YES];
}

#pragma mark - cellBlock Action

- (void)selectActionWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{

    NSInteger  tag = indexPath.item;
    PHAsset *asset = self.collectionDataArray[indexPath.item];

    NSMutableArray * isChoosenArray = [self.isChoosenDic objectForKey:_photoAlbumName];
    BOOL isChoosen = [[isChoosenArray objectAtIndex:tag]boolValue];
        
    if (!isChoosen) {
        if (_choosenCount >= photoCount) {
            return;
        }
        _choosenCount += 1;
        [self.choosenImgDict setObject:asset forKey:indexPath];
    }else {
        _choosenCount -= 1;
        [self.choosenImgDict removeObjectForKey:indexPath];
    }
    
    if (self.choosenImgDict.count) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [_rightBarItem setTitle:rightItemTitle forState:UIControlStateNormal];
    
    [isChoosenArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:!isChoosen]];
    [self.isChoosenDic setObject:isChoosenArray forKey:_navTitleLabel.text];
    
    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

#pragma mark - actionClick

- (void)showTableView {
    
    FMPhotoAlbumListViewController *phtotAlbumListVC = [[FMPhotoAlbumListViewController alloc]init];
    phtotAlbumListVC.dataArray = self.tableDataArray;
    phtotAlbumListVC.listNameArray = self.tableListNameArray;
    phtotAlbumListVC.block = ^(NSInteger tag){
        
        [self.tableDataArray removeAllObjects];
        [self.tableListNameArray removeAllObjects];
        [self.isChoosenDic removeAllObjects];
        [self.choosenImgDict removeAllObjects];
        [self markData];
        _choosenCount = 0;
        [_rightBarItem setTitle:rightItemTitle forState:UIControlStateNormal];
        [self getCollectionData:tag];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:phtotAlbumListVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)hide{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save{
    
    if (_choosenCount == 0 || self.choosenImgDict.count == 0) {
        return;
    }
    
    NSMutableArray * resuletData = [NSMutableArray arrayWithArray:[self.choosenImgDict allValues]];
    
    //resuletData 里存放着选中的图片资源，PhAsset类对象
    //但是这是的图片是无序的，因为是存放在字典里的
    NSLog(@"%@", resuletData);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
