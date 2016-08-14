
//
//  XLEmptyView.m
//  团购
//
//  Created by 徐理 on 16/8/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLEmptyView.h"

@implementation XLEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.contentMode = UIViewContentModeCenter;
    
    
    return self;
}

- (void)didMoveToSuperview
{

#warning 如果父控件不为nil，才需要添加约束
    if (self.superview) {
        // 填充整个父控件
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }


}

@end
