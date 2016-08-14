//
//  XLNavMenu.m
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLNavMenu.h"

@implementation XLNavMenu

+ (instancetype)navMenu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XLNavMenu" owner:nil options:nil] lastObject];
}

//通过xib加载控件的时候调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.clickBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



@end
