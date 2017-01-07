//
//  ViewController.m
//  MWArrowListView
//
//  Created by caifeng on 2017/1/6.
//  Copyright © 2017年 facaishu. All rights reserved.
//

#import "ViewController.h"
#import "CategoryHeader.h"
#import "MWArrowListView.h"

@interface ViewController ()<MWArrowListViewDelegate>

@property (nonatomic, strong) UIButton *moveButton;

@property (nonatomic, strong) MWArrowListView *arrowListView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // add moveButton
    [self setupMoveButton];
}


#pragma - Event Handle

#pragma mark **** button点击事件
- (void)buttonClick {
    
    _moveButton.selected = !_moveButton.selected;
    
    NSString *title = nil;
    if (_moveButton.selected) {
        title = @"dismiss";
    } else {
        title = @"show";
    }
    
    // 修改movebutton 的size
    CGSize size = mTextSize(title , 15);
    CGFloat btnW = fmax(size.width, size.height) + 20;
    
    _moveButton.width = btnW;
    _moveButton.height = btnW;
    _moveButton.layer.cornerRadius = 0.5 * btnW;
    _moveButton.clipsToBounds = YES;
    
    if (_moveButton.selected) {
        
//        CGFloat x = _moveButton.x;
//        CGFloat y = CGRectGetMaxY(_moveButton.frame);
        
        // 创建arrowlisttView  frame 可以视为bounds 在内部进一步修改
        _arrowListView = [[MWArrowListView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
        // 设置要依附的视图frame
        _arrowListView.attachViewRect = _moveButton.frame;
        _arrowListView.delegate = self;
        _arrowListView.dataArray = @[@"text0", @"text1", @"text2", @"text3", @"text4", @"text5", @"text6"];
        [self.view addSubview:_arrowListView];

    } else {
        [_arrowListView removeFromSuperview];
    }

}

#pragma mark **** 拖动手势事件
- (void)handlePanAction:(UIPanGestureRecognizer *)panGesture {

    UIView *panView = panGesture.view;// panView == _moveButton
    CGPoint point = [panGesture locationInView:panView.superview];
    panView.center = point;

    // 联动ArrowListView
    if (_arrowListView) {
        _arrowListView.attachViewRect = _moveButton.frame;
        [_arrowListView reLayout];
    }
    
    // 拖拽手势结束时处理边缘问题
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        [self handleButtonEdgeIssue];
    }
}


#pragma mark - MWArrowListViewDelegate
- (void)didSelectedWithIndex:(NSInteger)index {

    [self buttonClick];
    
    NSLog(@"selectIdex = %ld", index);
    
}

#pragma mark - Helper Method

#pragma mark **** moveButton边缘阻尼动画
- (void)dampingAnimationWithCenter:(CGPoint)center {

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _moveButton.center = center;
        
        // 动画结束后联动ArrowListView
        if (_arrowListView) {
            _arrowListView.attachViewRect = _moveButton.frame;
            [_arrowListView reLayout];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark **** 处理moveButton边界问题
- (void)handleButtonEdgeIssue {
    
    CGFloat btnX = _moveButton.x;
    CGFloat btnY = _moveButton.y;
    CGFloat btnW = _moveButton.width;
    CGFloat btnH = _moveButton.height;
    
    // 不超过边缘时返回
    if (btnX > 0 && btnX + btnW < mScreenWidth && btnY > 0 && btnY + btnH < mScreenHeight) return;
    
    CGFloat centerX;
    CGFloat centerY;
    
    // 计算centerX
    if (btnX < 0) {
        
        centerX = btnW * 0.5;
    } else if (btnX > mScreenWidth - btnW) {
       
        centerX = mScreenWidth - btnW * 0.5;
    } else {
    
        centerX = _moveButton.centerX;
    }
    
    // 计算centerY
    if (btnY < 0) {
        
        centerY = btnH * 0.5;
    } else if (btnY > mScreenHeight - btnH) {
        
        centerY = mScreenHeight - btnH * 0.5;
    } else {
        
        centerY = btnY + btnH * 0.5;
    }
    CGPoint center = CGPointMake(centerX, centerY);
    
    // 设置moveButton 的center
    [self dampingAnimationWithCenter:center];
}

#pragma mark **** 设置可以移动的button
- (void)setupMoveButton {

    CGSize size = mTextSize(@"show", 15);
    CGFloat width = fmax(size.width, size.height) + 20;
    
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moveButton.frame = CGRectMake(0, 0, width, width);
    moveButton.center = self.view.center;
    moveButton.layer.cornerRadius = 30;
    moveButton.clipsToBounds = YES;
    [moveButton setTitle:@"show" forState:UIControlStateNormal];
    [moveButton setTitle:@"dismiss" forState:UIControlStateSelected];
    [moveButton setBackgroundImage:[UIImage getImageFromColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [moveButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // add panGesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    [moveButton addGestureRecognizer:pan];
    
    [self.view addSubview:_moveButton = moveButton];
}




@end
