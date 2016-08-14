//
//  XLBiasLineLabel.m
//  团购
//
//  Created by 徐理 on 16/8/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLBiasLineLabel.h"

@implementation XLBiasLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    创建图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    设置颜色
    [[UIColor grayColor] set];
    
//    设置宽度
    CGContextSetLineWidth(context, 1);
    
//    起点
    CGContextMoveToPoint(context, 0, 0);
    
//    终点
    CGContextAddLineToPoint(context, self.width, self.height);

    CGContextMoveToPoint(context, self.width, 0);
    CGContextAddLineToPoint(context, 0, self.height);

//    画线
    CGContextStrokePath(context);
}

@end
