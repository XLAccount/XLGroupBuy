//
//  XLCategoryModal.m
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLCategoryModal.h"

@implementation XLCategoryModal

- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subcategories;
}

- (NSString *)image
{
    return self.small_icon;
}

- (NSString *)highlightedImage
{
    return self.small_highlighted_icon;
}
@end
