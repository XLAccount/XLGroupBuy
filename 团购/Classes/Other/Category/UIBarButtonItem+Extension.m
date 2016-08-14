
//
//  UIBarButtonItem+Extension.m
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)name highImageName:(NSString *)HName target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:HName] forState:UIControlStateHighlighted];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentMode = UIViewContentModeScaleAspectFit;
    btn.size = btn.currentImage.size;
    
    return [[self alloc] initWithCustomView:btn];
}

@end
