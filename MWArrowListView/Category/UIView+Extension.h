//
//  UIView+Extension.h
//  MWArrowListView
//
//  Created by caifeng on 2017/1/6.
//  Copyright © 2017年 facaishu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mScreenWidth [UIScreen mainScreen].bounds.size.width
#define mScreenHeight [UIScreen mainScreen].bounds.size.height

#define mTextSize(text,font) [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:\
                        NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : \
                        [UIFont systemFontOfSize:font]} context:NULL].size

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@end
