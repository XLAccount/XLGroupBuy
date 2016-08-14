//
//  XLDataTool.m
//  团购
//
//  Created by 徐理 on 16/8/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XLDataTool.h"
#import "XLCategoryModal.h"
#import "XLCityModal.h"
#import "XLCityGroupModal.h"
#import "XLSortModal.h"

#define XLSelectedCityFile  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_city.plist"]

#define XLSelectedSortFile  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_sort.plist"]

@interface XLDataTool()
{
    /** 所有的分类 */
    NSArray *_categories;
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的城市组 */
    NSArray *_cityGroups;
    /** 所有的排序 */
    NSArray *_sorts;
}

@property (nonatomic, strong) NSMutableArray *selectecCityNames;
@end

@implementation XLDataTool
XLSingletonM(XLDataTool)

- (NSMutableArray *)selectecCityNames
{
    if (_selectecCityNames == nil){
        _selectecCityNames = [NSMutableArray arrayWithContentsOfFile:XLSelectedCityFile];
        
        
        if (_selectecCityNames == nil){
            _selectecCityNames = [NSMutableArray array];
        }
    }
    return _selectecCityNames;
}

- (NSArray *)categories
{
    if (!_categories) {
        _categories = [XLCategoryModal objectArrayWithFilename:@"categories.plist"];
    
    }
    return _categories;
}

- (NSArray *)cityGroups
{
    
        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:10];
    
    if (self.userTrackingCity){
        
        XLCityGroupModal *cityGroup = [[XLCityGroupModal alloc] init];
        cityGroup.title = @"当前位置";
        cityGroup.cities = @[self.userTrackingCity];
        
        [mutable addObject:cityGroup];
        
    }else{
        
        XLCityGroupModal *cityGroup = [[XLCityGroupModal alloc] init];
        cityGroup.title = @"当前位置";
        cityGroup.cities = @[@"获取当前位置"];
        
        [mutable addObject:cityGroup];
    }

    
        if (self.selectecCityNames.count){
            
            XLCityGroupModal *cityGroup = [[XLCityGroupModal alloc] init];
            cityGroup.title = @"最近访问";
            cityGroup.cities = self.selectecCityNames;
            
            [mutable addObject:cityGroup];
        }
        
    NSArray *array = [XLCityGroupModal objectArrayWithFilename:@"cityGroups.plist"];
    
        
        [mutable addObjectsFromArray:array];
    
    return mutable;
}

- (NSArray *)cities
{
    if (!_cities) {
        _cities = [XLCityModal objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [XLSortModal objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}


- (XLCityModal *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    for (XLCityModal *city in self.cities) {
        if ([city.name isEqualToString:name]) return city;
    }
    return nil;
}

#pragma mark 储存方法
- (void)saveSelectedCity:(NSString *)name
{
    if (name.length == 0) return;
    
    [self.selectecCityNames removeObject:name];
    [self.selectecCityNames insertObject:name atIndex:0];
    
    [self.selectecCityNames writeToFile:XLSelectedCityFile atomically:YES];
    
    
}

- (void)saveSelectedSort:(XLSortModal *)sort
{
    if (sort == nil) return;
    
    [NSKeyedArchiver archiveRootObject:sort toFile:XLSelectedSortFile];
}

#pragma mark 取出储存的数据
- (XLCityModal *)selectedCity
{
    NSString *cityName = [self.selectecCityNames firstObject];
    
    XLCityModal *city = [self cityWithName:cityName];
    
    if (city == nil){
        city = [self cityWithName:@"上海"];
        
    }
    return city;
}

- (XLSortModal *)selectedSort
{
    XLSortModal *sort = [NSKeyedUnarchiver unarchiveObjectWithFile:XLSelectedSortFile];
    
    if (sort == nil){
        sort = [self.sorts firstObject];
    }
    
    return sort;
}

- (XLCategoryModal *)categoryWithName:(NSString *)name
{
    for (XLCategoryModal *category in self.categories) {
        if ([category.name isEqualToString:name]) return category;
        
        // 遍历子类别
        for (NSString *subcategory in category.subcategories) {
            if ([subcategory isEqualToString:name]) return category;
        }
    }
    return nil;
}
@end
