//
//  UILabel+FMJJKAlertActionFont.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "UILabel+FMJJKAlertActionFont.h"


@implementation UILabel (FMJJKAlertActionFont)

- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if(appearanceFont)
    {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
}

@end
