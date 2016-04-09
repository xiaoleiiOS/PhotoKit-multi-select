//
//  FMblackBaseViewController.h
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  黑色navigation的Base，只要是黑色的可以继承
 */
@interface FMblackBaseViewController : UIViewController

/**
 *  提示框
 *
 *  @param message message description
 */
-(void)showMessage:(NSString *)message;

#pragma mark - 改变push动画方法
- (CATransition *)pushAnimation;

#pragma mark - 改变pop动画方法
- (CATransition *)popAnimation;

@end
