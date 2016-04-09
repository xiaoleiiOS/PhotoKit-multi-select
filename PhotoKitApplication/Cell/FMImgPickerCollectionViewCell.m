//
//  FMImgPickerCollectionViewCell.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "FMImgPickerCollectionViewCell.h"

@interface FMImgPickerCollectionViewCell ()


@property (nonatomic , strong) IBOutlet UIImageView * isChoosenImageView;

@end

@implementation FMImgPickerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setContentImg:(UIImage *)contentImg {
    if (contentImg) {
        _contentImg = contentImg;
        self.mainImageView.image = _contentImg;
        self.mainImageView.userInteractionEnabled = YES;
    }
}
- (void)setIsChoosen:(BOOL)isChoosen {
    _isChoosen = isChoosen;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (isChoosen) {
            self.isChoosenImageView.image = [UIImage imageNamed:@"FMImgPickerCollectionViewCell_img_select"];
            
        }else {
            self.isChoosenImageView.image = [UIImage imageNamed:@"FMImgPickerCollectionViewCell_img_noselect"];
        }
        self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.1,1.1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.0,1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)setIsChoosenImgHidden:(BOOL)isChoosenImgHidden {
    
    _isChoosenImgHidden             = isChoosenImgHidden;
    self.isChoosenImageView.hidden  = isChoosenImgHidden;
}

#pragma mark - action

- (IBAction)selectBtnClick:(UIButton *)sender {
    
    if (_block) {
        _block();
    }
}


@end
