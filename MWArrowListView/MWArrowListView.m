//
//  MWArrowListView.m
//  MWArrowListView
//
//  Created by caifeng on 2017/1/6.
//  Copyright © 2017年 facaishu. All rights reserved.
//

#import "MWArrowListView.h"
#import "CategoryHeader.h"

static const CGFloat arrowSpace = 20;/**<箭头跨度*/
static const CGFloat arrowHeight = 10;/**<箭头高度*/

@interface MWArrowListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGFloat arrowRightX;/**<箭头右侧的x*/
@property (nonatomic, assign) MWArrowPosition position;/**<箭头位置*/

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MWArrowListView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // add tableView
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    // 计算绘制数据
    CGFloat point0_x = 0.0, point0_y = 0.0, point1_x = 0.0, point1_y = 0.0,
            point2_x = 0.0, point2_y = 0.0, point3_x = 0.0, point3_y = 0.0,
            point4_x = 0.0, point4_y = 0.0, point5_x = 0.0, point5_y = 0.0,
            point6_x = 0.0, point6_y = 0.0;
    
    if (_position == MWArrowPositionBottom) {// 箭头在下方
        
        point0_x = 0;
        point0_y = arrowHeight;
        
        point1_x = 0;
        point1_y = self.height;
        
        point2_x = self.width;
        point2_y = self.height;
        
        point3_x = self.width;
        point3_y = arrowHeight;
        
        point4_x = _arrowRightX;
        point4_y = arrowHeight;
        
        point5_x = _arrowRightX - arrowSpace * 0.5;
        point5_y = 0;
        
        point6_x = _arrowRightX - arrowSpace;
        point6_y = arrowHeight;
    }
    
    if (_position == MWArrowPositionTop) {// 箭头在上方
        
        point0_x = 0;
        point0_y = 0;
        
        point1_x = 0;
        point1_y = self.height - arrowHeight;
        
        point2_x = _arrowRightX - arrowSpace;
        point2_y = self.height - arrowHeight;
        
        point3_x = _arrowRightX - arrowSpace * 0.5;
        point3_y = self.height;
        
        point4_x = _arrowRightX;
        point4_y = self.height - arrowHeight;
        
        point5_x = self.width;
        point5_y = self.height - arrowHeight;
        
        point6_x = self.width;
        point6_y = 0;
    }
    

    // 开始绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point0_x, point0_y);
    CGContextAddLineToPoint(context, point1_x, point1_y);
    CGContextAddLineToPoint(context, point2_x, point2_y);
    CGContextAddLineToPoint(context, point3_x, point3_y);
    CGContextAddLineToPoint(context, point4_x, point4_y);
    CGContextAddLineToPoint(context, point5_x, point5_y);
    CGContextAddLineToPoint(context, point6_x, point6_y);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextFillPath(context);
}


#pragma mark **** 视图移动到父视图

- (void)didMoveToWindow {

    [self reLayout];
    
}

#pragma mark - Helper Method

#pragma mark **** 重新布局
- (void)reLayout {
    
    // attachView center
    CGPoint attachCenter = CGPointMake(CGRectGetMidX(_attachViewRect), CGRectGetMidY(_attachViewRect));
    CGFloat attachCenterX = attachCenter.x;
    CGFloat attachY = CGRectGetMinY(_attachViewRect);
    CGFloat attachMaxY = CGRectGetMaxY(_attachViewRect);
    
    CGFloat centerX;
    CGFloat centerY;
    if (attachCenterX < self.width * 0.5) {// 左侧超出边界
        
        centerX = self.width * 0.5;
        _arrowRightX = attachCenterX + arrowSpace * 0.5;
        
    } else if (attachCenterX + self.width * 0.5 > mScreenWidth) {// 右侧超出边界

        centerX = mScreenWidth - self.width * 0.5;
        _arrowRightX = self.width - (mScreenWidth - attachCenterX) + arrowSpace * 0.5;
        
    } else {
    
        centerX = attachCenterX;
        _arrowRightX = self.width * 0.5 + arrowSpace * 0.5;
        
    }
    
    
    if (attachMaxY + self.height > mScreenHeight) {
        centerY = attachY - self.height * 0.5;
        _position = MWArrowPositionTop;
    } else {
        centerY = attachMaxY + self.height * 0.5;
        _position = MWArrowPositionBottom;
    }
    
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = center;
    

    // 重绘
    [self setNeedsDisplay];
    // 重新布局tabelView
    [self layoutTableView];
}


- (void)layoutTableView {
    CGRect frame = CGRectZero;
    if (_position == MWArrowPositionTop) {
        frame = CGRectMake(0, 0, self.width, self.height - arrowHeight);
    } else {
        frame = CGRectMake(0, arrowHeight, self.width, self.height - arrowHeight);
    }
    self.tableView.frame = frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectedWithIndex:indexPath.row];
}

#pragma mark - Getter && Setter

- (UITableView *)tableView {

    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)setAttachViewRect:(CGRect)attachViewRect {

    _attachViewRect = attachViewRect;
}


@end
