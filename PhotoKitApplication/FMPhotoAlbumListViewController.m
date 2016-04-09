//
//  FMPhotoAlbumListViewController.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMPhotoAlbumListViewController.h"
#import "FMPhtotAlbumListTableViewCell.h"
#import <Photos/Photos.h>

@interface FMPhotoAlbumListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FMPhotoAlbumListViewController

#pragma mark - init

-(void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 55;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"FMPhtotAlbumListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([FMPhtotAlbumListTableViewCell class])];
}


#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统相册";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_X"] style:UIBarButtonItemStyleDone target:self action:@selector(hide)];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMPhtotAlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FMPhtotAlbumListTableViewCell class]) forIndexPath:indexPath];
    
    PHFetchResult *assetsFetchResult = self.dataArray[indexPath.row];
    PHAsset *asset = [assetsFetchResult lastObject];
    
    // 在资源的集合中获取第一个集合，并获取其中的图片
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:asset
                            targetSize:CGSizeMake(55, 55)
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             // 得到一张 UIImage，展示到界面上
                             cell.coverImageView.image = result;
                         }];
    cell.photoAlbumNameLabel.text = [NSString stringWithFormat:@"%@  （%ld）", self.listNameArray[indexPath.row], assetsFetchResult.count];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_block) {
        _block(indexPath.row);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

- (void)hide{
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
