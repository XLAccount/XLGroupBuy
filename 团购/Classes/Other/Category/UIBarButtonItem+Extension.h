//
//  UIBarButtonItem+Extension.h
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)name highImageName:(NSString *)HName target:(id)target action:(SEL)action;

@end
