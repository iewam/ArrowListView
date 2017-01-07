//
//  MWArrowListView.h
//  MWArrowListView
//
//  Created by caifeng on 2017/1/6.
//  Copyright © 2017年 facaishu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    MWArrowPositionTop,
    MWArrowPositionLeft,
    MWArrowPositionBottom,
    MWArrowPositionRight
    
} MWArrowPosition;

@protocol MWArrowListViewDelegate <NSObject>

- (void)didSelectedWithIndex:(NSInteger)index;

@end


@interface MWArrowListView : UIView

@property (nonatomic, assign) CGRect attachViewRect;/**<吸附视图的frame*/

@property (strong, nonatomic) NSArray *dataArray;

@property (nonatomic, weak) id<MWArrowListViewDelegate> delegate;

/**
 重新布局
 */
- (void)reLayout;

@end
