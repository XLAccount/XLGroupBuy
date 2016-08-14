//
//  XLDataTool.h
//  团购
//
//  Created by 徐理 on 16/8/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareSingle.h"
@class XLCityModal;
@class XLSortModal;
@class XLCategoryModal;

@interface XLDataTool : NSObject


XLSingletonH(XLDataTool)
/**
 *  所有的分类
 */
@property (strong, nonatomic, readonly) NSArray *categories;
/**
 *  所有的城市
 */
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组
 */
@property (strong, nonatomic, readonly) NSArray *cityGroups;
/**
 *  所有的排序
 */
@property (strong, nonatomic, readonly) NSArray *sorts;

@property (nonatomic, copy) NSString *userTrackingCity;

- (XLCityModal *)cityWithName:(NSString *)name;

/** 保存选中城市的名称 */
- (void)saveSelectedCity:(NSString *)name;
/** 选中的排序 */
- (void)saveSelectedSort:(XLSortModal *)sort;

- (XLCategoryModal *)categoryWithName:(NSString *)name;

- (XLCityModal *)selectedCity;
- (XLSortModal *)selectedSort;
@end
