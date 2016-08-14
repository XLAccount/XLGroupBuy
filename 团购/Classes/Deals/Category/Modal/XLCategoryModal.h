//
//  XLCategoryModal.h
//  团购
//
//  Created by 徐理 on 16/8/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLDropDownMenu.h"

@interface XLCategoryModal : NSObject<XLDropDownMenuDelegete>

/** 类别名称 */
@property (copy, nonatomic) NSString *name;
/** 大图标 */
@property (copy, nonatomic) NSString *icon;
/** 大图标(高亮) */
@property (copy, nonatomic) NSString *highlighted_icon;
/** 小图标 */
@property (copy, nonatomic) NSString *small_icon;
/** 小图标(高亮) */
@property (copy, nonatomic) NSString *small_highlighted_icon;
/** 子类别 */
@property (strong, nonatomic) NSArray *subcategories;

/** 这种类别显示在地图上的大头针图标 */
@property (nonatomic, copy) NSString *map_icon;

@end
