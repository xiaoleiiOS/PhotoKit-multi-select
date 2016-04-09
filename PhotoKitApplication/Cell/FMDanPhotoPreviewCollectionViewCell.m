//
//  FMDanPhotoPreviewCollectionViewCell.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMDanPhotoPreviewCollectionViewCell.h"

@interface FMDanPhotoPreviewCollectionViewCell () <UIScrollViewDelegate>
{
    UIImageView *_imageView;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation FMDanPhotoPreviewCollectionViewCell

#pragma mark - life Cycle

- (void)awakeFromNib{
    
    //设置图片
    [self markImageView];
}

#pragma mark - 图片设置
//设置图片，将imageView加入到scrollView中
- (void)markImageView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=2.5;
    //设置最小伸缩比例
    _scrollView.minimumZoomScale=1;
    
    [self.contentView addSubview:_scrollView];
    
    _imageView=[[UIImageView alloc]init];
    _imageView.frame = CGRectMake(18, 0, _scrollView.bounds.size.width - 36, _scrollView.bounds.size.height - 10);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    
}

- (void)setPhotoImage:(UIImage *)photoImage{
    
    _photoImage = photoImage;
    
    _imageView.image = _photoImage;
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollView.contentSize = _imageView.bounds.size;
    
    _scrollView.zoomScale = 1.0;
}

#pragma mark - UIScrollViewDelegate
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _imageView.frame = CGRectMake(18, 0, _scrollView.bounds.size.width - 36, _scrollView.bounds.size.height - 10);
}

@end
