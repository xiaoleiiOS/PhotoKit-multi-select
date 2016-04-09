//
//  BMAoutSizeLabel.m
//  PhotoKitApplication
//
//  Created by 王晓磊 on 16/4/1.
//  Copyright © 2016年 王晓磊. All rights reserved.
//

#import "BMAoutSizeLabel.h"

@implementation BMAoutSizeLabel

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"font"];
}
 
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self aoutSize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self aoutSize];
    }
    return self;
}

#pragma mark- 添加监听
-(void)aoutSize{
    _MaxSize=self.frame.size;
    self.numberOfLines=0;
    //添加kvo监听
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
    //
    if (self.text.length>0) {[self changeSizeWithString];}
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    [self changeSizeWithString];
}

#pragma mark- 改变self大小
-(void)changeSizeWithString{
    CGRect rect = [self.text boundingRectWithSize:_MaxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:@{NSFontAttributeName:self.font}
                                          context:nil];
    
    CGRect labrect =self.frame;
    labrect.size=rect.size;
    self.frame=labrect;
}
#pragma mark- 外部方法 计算字符串 占位大小
+(CGSize)sizeWithString:(NSString *)str
                  fount:(UIFont*)fount
                maxSize:(CGSize)size {
    
    CGRect rect = [str boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                 attributes:@{NSFontAttributeName:fount}
                                    context:nil];
    return rect.size;
}
@end
