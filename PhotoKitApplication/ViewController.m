//
//  ViewController.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "ViewController.h"
#import "FMImgPickerViewController.h"
#import  <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)actionClick:(id)sender {
    
    //判断是否有相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied){ //无权限
        [self showMessage:@"没有相册权限 请到设置隐私中开启"];
    }else{
        
        FMImgPickerViewController *imgPickerVC = [[FMImgPickerViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imgPickerVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
